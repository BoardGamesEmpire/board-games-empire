import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable, InternalServerErrorException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AuthStrategy, TokenType } from '@prisma/client';
import { createHash, randomBytes } from 'crypto';
import { DateTime } from 'luxon';
import * as querystring from 'querystring';
import { JoseService } from './jose.service';

@Injectable()
export class OidcService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private joseService: JoseService,
    private configService: ConfigService,
  ) {}

  /**
   * Initiate OIDC authentication flow
   */
  async initiateAuthentication(providerName: string, redirectUri: string): Promise<{ authUrl: string }> {
    // Find the identity provider
    const provider = await this.prisma.identityProvider.findFirst({
      where: {
        provider: providerName.toLowerCase(),
        enabled: true,
      },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider '${providerName}' not found or not enabled`);
    }

    // Generate state, nonce and PKCE params
    const state = randomBytes(32).toString('hex');
    const nonce = randomBytes(32).toString('hex');
    const codeVerifier = randomBytes(64).toString('hex');
    const codeChallenge = createHash('sha256')
      .update(codeVerifier)
      .digest('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '');

    // Create auth session
    await this.prisma.oidcAuthSession.create({
      data: {
        state,
        nonce,
        codeVerifier,
        provider: {
          connect: { id: provider.id },
        },
        redirectUri: redirectUri || '/',
        expiresAt: DateTime.now().plus({ minutes: 10 }).toJSDate(),
      },
    });

    // Determine authorization URL
    const authorizationUrl =
      provider.authorizationUrl ||
      `${provider.discoveryUrl?.replace('/.well-known/openid-configuration', '')}/authorize`;

    // Build the authorization URL
    const authUrl = `${authorizationUrl}?${querystring.stringify({
      client_id: provider.clientId,
      redirect_uri: this.configService.get('API_BASE_URL') + '/auth/oidc/callback',
      response_type: 'code',
      scope: provider.scopes.join(' '),
      state,
      nonce,
      code_challenge_method: 'S256',
      code_challenge: codeChallenge,
    })}`;

    return { authUrl };
  }

  /**
   * Handle OIDC callback
   */
  async handleCallback(
    state: string,
    code: string,
  ): Promise<{ access_token: string; refresh_token: string; user: any; isNewUser?: boolean }> {
    // Find the auth session
    const session = await this.prisma.oidcAuthSession.findFirst({
      where: { state },
      include: { provider: true },
    });

    if (!session || session.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired authentication session');
    }

    try {
      // Exchange code for tokens
      const tokenResponse = await this.exchangeCodeForTokens(code, session);

      // Validate ID token
      const idTokenPayload = await this.joseService.verifyIdToken(
        tokenResponse.id_token,
        session.provider.clientId,
        session.nonce,
      );

      // Get user info from token or fetch from userinfo endpoint
      const userInfo = idTokenPayload;

      // Clean up the session
      await this.prisma.oidcAuthSession.delete({
        where: { id: session.id },
      });

      // Find or create user
      const { user, isNew } = await this.findOrCreateUser(
        session.provider.id,
        userInfo.sub,
        userInfo,
        tokenResponse.access_token,
        tokenResponse.refresh_token,
        tokenResponse.expires_in ? new Date(Date.now() + tokenResponse.expires_in * 1000) : undefined,
      );

      // Generate JWT and refresh token
      const jwtPayload = {
        sub: user.id,
        username: user.username,
        email: user.email,
      };

      // Generate refresh token
      const refreshToken = randomBytes(40).toString('hex');
      const refreshTokenExpiry = DateTime.now().plus({ days: 30 }).toJSDate();

      // Store refresh token
      await this.prisma.token.create({
        data: {
          authenticationId: user.authentication.id,
          token: refreshToken,
          type: TokenType.Refresh,
          expiresAt: refreshTokenExpiry,
        },
      });

      return {
        access_token: this.jwtService.sign(jwtPayload),
        refresh_token: refreshToken,
        user: {
          id: user.id,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          avatar: user.avatar,
          bio: user.bio,

          authentication: {
            email: user.authentication.email,
            emailVerified: user.authentication.emailVerified,
            authStrategy: user.authentication.authStrategy,
            isExternalUser: user.authentication.isExternalUser,
            lastLogin: user.authentication.lastLogin,
          },
        },
        isNewUser: isNew,
      };
    } catch (error) {
      throw new InternalServerErrorException(`Authentication failed: ${error.message}`);
    }
  }

  /**
   * Exchange authorization code for tokens
   */
  private async exchangeCodeForTokens(code: string, session: any): Promise<any> {
    const tokenUrl =
      session.provider.tokenUrl ||
      `${session.provider.discoveryUrl?.replace('/.well-known/openid-configuration', '')}/token`;

    try {
      const response = await fetch(tokenUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: querystring.stringify({
          grant_type: 'authorization_code',
          client_id: session.provider.clientId,
          client_secret: session.provider.clientSecret,
          code,
          redirect_uri: this.configService.get('API_BASE_URL') + '/auth/oidc/callback',
          code_verifier: session.codeVerifier,
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new UnauthorizedException(
          `Token exchange failed: ${error.error_description || error.error || 'Unknown error'}`,
        );
      }

      return response.json();
    } catch (error) {
      throw new InternalServerErrorException(`Token exchange failed: ${error.message}`);
    }
  }

  /**
   * Find existing user or create a new one
   */
  private async findOrCreateUser(
    providerId: string,
    externalId: string,
    userInfo: any,
    accessToken?: string,
    refreshToken?: string,
    tokenExpiresAt?: Date,
  ): Promise<{ user: any; isNew: boolean }> {
    // Look for existing external identity
    const existingIdentity = await this.prisma.userExternalIdentity.findUnique({
      where: {
        providerId_externalId: {
          providerId,
          externalId,
        },
      },
      include: {
        authentication: {
          select: {
            id: true,
            email: true,
            authStrategy: true,
            isExternalUser: true,
            emailVerified: true,
          },
          include: {
            user: true,
          },
        },
      },
    });

    // If we found an existing identity, update tokens and return the associated user
    if (existingIdentity) {
      // Update tokens if provided
      if (accessToken || refreshToken) {
        await this.prisma.userExternalIdentity.update({
          where: { id: existingIdentity.id },
          data: {
            accessToken,
            refreshToken,
            tokenExpiresAt,
            updatedAt: new Date(),
          },
        });
      }

      // Update last login timestamp
      await this.prisma.userAuthentication.update({
        where: { id: existingIdentity.authentication.id },
        data: { lastLogin: new Date() },
      });

      return { user: existingIdentity.authentication.user, isNew: false };
    }

    // Look for existing user with the same email
    let auth = null;
    let isNew = false;

    if (userInfo.email) {
      auth = await this.prisma.userAuthentication.findUnique({
        where: { email: userInfo.email },
        include: {
          user: true,
        },
      });

      // If user exists but email is not verified, require explicit linking
      if (auth && !auth.emailVerified) {
        throw new UnauthorizedException('Account exists but email is not verified. Please verify your email first.');
      }
    }

    // If no existing user(auth), create a new one
    if (!auth) {
      const username = await this.generateUniqueUsername(userInfo);

      auth = await this.prisma.userAuthentication.create({
        data: {
          email: userInfo.email,
          authStrategy: this.mapProviderToStrategy(providerId),
          isExternalUser: true,
          // We trust the OIDC provider has verified the email - for now...
          emailVerified: true,
          lastLogin: new Date(),

          user: {
            create: {
              username,
              firstName: userInfo.given_name,
              lastName: userInfo.family_name,
              avatar: userInfo.picture,

              // should supply all defaults
              preferences: {
                create: {},
              },
            },
          },
        },
        include: {
          user: true,
        },
      });

      isNew = true;
    }

    // Create the external identity
    await this.prisma.userExternalIdentity.create({
      data: {
        providerId,
        externalId,

        authenticationId: auth.id,
        email: userInfo.email,
        rawProfile: userInfo,
        accessToken,
        refreshToken,
        tokenExpiresAt,
      },
    });

    return { user: auth.user, isNew };
  }

  /**
   * Generate a unique username based on user info
   */
  private async generateUniqueUsername(userInfo: any): Promise<string> {
    let baseUsername = '';

    // Try to generate a username from the user info
    if (userInfo.preferred_username) {
      baseUsername = userInfo.preferred_username;
    } else if (userInfo.email) {
      baseUsername = userInfo.email.split('@')[0];
    } else if (userInfo.given_name) {
      baseUsername = `${userInfo.given_name}${userInfo.family_name ? userInfo.family_name[0] : ''}`.toLowerCase();
    } else {
      baseUsername = 'user';
    }

    // Clean up the username (remove non-alphanumeric characters)
    baseUsername = baseUsername.replace(/[^a-zA-Z0-9]/g, '');

    // Check if username is available
    const existingUser = await this.prisma.user.findUnique({
      where: { username: baseUsername },
    });

    if (!existingUser) {
      return baseUsername;
    }

    // If username is taken, append a random suffix
    return `${baseUsername}${Math.floor(Math.random() * 10000)}`;
  }

  /**
   * Map provider ID to AuthStrategy enum
   */
  private mapProviderToStrategy(providerId: string): AuthStrategy {
    const providerMap: Record<string, AuthStrategy> = {
      google: AuthStrategy.Google,
      github: AuthStrategy.GitHub,
      microsoft: AuthStrategy.Microsoft,
      apple: AuthStrategy.Apple,
      facebook: AuthStrategy.Facebook,
    };

    return providerMap[providerId] || AuthStrategy.Custom;
  }

  /**
   * Get user's linked accounts
   */
  async getLinkedAccounts(userId: string) {
    const externalIdentities = await this.prisma.userExternalIdentity.findMany({
      where: { authentication: { userId } },
      include: { provider: true },
    });

    return externalIdentities.map((identity) => ({
      id: identity.id,
      provider: identity.provider.name,
      providerId: identity.provider.id,
      externalId: identity.externalId,
      email: identity.email,
      connectedAt: identity.createdAt,
    }));
  }

  /**
   * Unlink an external account from a user
   */
  async unlinkAccount(providerName: string, userId: string) {
    // Find the provider
    const provider = await this.prisma.identityProvider.findFirst({
      where: {
        provider: providerName.toLowerCase(),
      },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider '${providerName}' not found`);
    }

    // Check if this is the only authentication method
    const auth = await this.prisma.userAuthentication.findUnique({
      where: { id: userId },
      include: {
        externalIdentities: true,
      },
    });

    if (!auth) {
      throw new NotFoundException('User not found');
    }

    // If auth has no password and this is their only external identity, prevent unlinking
    if (
      !auth.password &&
      auth.externalIdentities.length === 1 &&
      auth.externalIdentities[0].providerId === provider.id
    ) {
      throw new UnauthorizedException('Cannot unlink the only authentication method. Please set a password first.');
    }

    // Delete the external identity
    await this.prisma.userExternalIdentity.deleteMany({
      where: {
        authenticationId: auth.id,
        providerId: provider.id,
      },
    });

    return { message: 'Account unlinked successfully' };
  }

  /**
   * Initiate account linking for an existing user
   */
  async initiateAccountLinking(providerName: string, userId: string): Promise<{ authUrl: string }> {
    // Find the provider
    const provider = await this.prisma.identityProvider.findFirst({
      where: {
        provider: providerName.toLowerCase(),
        enabled: true,
      },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider '${providerName}' not found or not enabled`);
    }

    const auth = await this.prisma.userAuthentication.findUnique({
      where: { id: userId },
      include: {
        externalIdentities: true,
      },
    });

    if (!auth) {
      throw new NotFoundException('User not found');
    }

    auth.externalIdentities.forEach((identity) => {
      if (identity.providerId === provider.id) {
        throw new UnauthorizedException('Account already linked to this provider');
      }
    });

    // Generate state, nonce and PKCE params
    const state = randomBytes(32).toString('hex');
    const nonce = randomBytes(32).toString('hex');
    const codeVerifier = randomBytes(64).toString('hex');
    const codeChallenge = createHash('sha256')
      .update(codeVerifier)
      .digest('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '');

    // Create auth session with userId for linking
    await this.prisma.oidcAuthSession.create({
      data: {
        state,
        nonce,
        codeVerifier,
        redirectUri: `/profile/linked-accounts?action=link&provider=${providerName}`,
        providerId: provider.id,
        expiresAt: DateTime.now().plus({ minutes: 10 }).toJSDate(),
        authenticationId: auth.id,
      },
    });

    // Determine authorization URL
    const authorizationUrl =
      provider.authorizationUrl ||
      `${provider.discoveryUrl?.replace('/.well-known/openid-configuration', '')}/authorize`;

    // Build the authorization URL
    const authUrl = `${authorizationUrl}?${querystring.stringify({
      client_id: provider.clientId,
      redirect_uri: this.configService.get('API_BASE_URL') + '/auth/oidc/callback',
      response_type: 'code',
      scope: provider.scopes.join(' '),
      state,
      nonce,
      code_challenge_method: 'S256',
      code_challenge: codeChallenge,
    })}`;

    return { authUrl };
  }
}
