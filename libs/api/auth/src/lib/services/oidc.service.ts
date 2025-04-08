import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable, InternalServerErrorException, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { AuthStrategy, TokenType } from '@prisma/client';
import { DateTime } from 'luxon';
import * as crypto from 'node:crypto';
import * as querystring from 'node:querystring';
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
    const state = crypto.randomBytes(32).toString('hex');
    const nonce = crypto.randomBytes(32).toString('hex');
    const codeVerifier = crypto.randomBytes(64).toString('hex');
    const codeChallenge = crypto
      .createHash('sha256')
      .update(codeVerifier)
      .digest('base64')
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=/g, '');

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

    const authorizationUrl =
      provider.authorizationUrl ||
      `${provider.discoveryUrl?.replace('/.well-known/openid-configuration', '')}/authorize`;

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
    const session = await this.prisma.oidcAuthSession.findFirst({
      where: { state },
      include: { provider: true },
    });

    if (!session || session.expiresAt < new Date()) {
      throw new UnauthorizedException('Invalid or expired authentication session');
    }

    try {
      const tokenResponse = await this.exchangeCodeForTokens(code, session);

      const idTokenPayload = await this.joseService.verifyIdToken(
        tokenResponse.id_token,
        session.provider.clientId,
        session.nonce,
      );

      const userInfo = idTokenPayload;

      await this.prisma.oidcAuthSession.delete({
        where: { id: session.id },
      });

      const { user, isNew } = await this.findOrCreateUser(
        session.provider.id,
        userInfo.sub,
        userInfo,
        tokenResponse.access_token,
        tokenResponse.refresh_token,
        tokenResponse.expires_in ? new Date(Date.now() + tokenResponse.expires_in * 1000) : undefined,
      );

      const jwtPayload = {
        sub: user.id,
        username: user.username,
        email: user.email,
      };

      const refreshToken = randomBytes(40).toString('hex');
      const refreshTokenExpiry = DateTime.now().plus({ days: 30 }).toJSDate();

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

    if (existingIdentity) {
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

      await this.prisma.userAuthentication.update({
        where: { id: existingIdentity.authentication.id },
        data: { lastLogin: new Date() },
      });

      return { user: existingIdentity.authentication.user, isNew: false };
    }

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
    const provider = await this.prisma.identityProvider.findFirst({
      where: {
        provider: providerName.toLowerCase(),
      },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider '${providerName}' not found`);
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

    // If auth has no password and this is their only external identity, prevent unlinking
    if (
      !auth.password &&
      auth.externalIdentities.length === 1 &&
      auth.externalIdentities[0].providerId === provider.id
    ) {
      throw new UnauthorizedException('Cannot unlink the only authentication method. Please set a password first.');
    }

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

    const authorizationUrl =
      provider.authorizationUrl ||
      `${provider.discoveryUrl?.replace('/.well-known/openid-configuration', '')}/authorize`;

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
