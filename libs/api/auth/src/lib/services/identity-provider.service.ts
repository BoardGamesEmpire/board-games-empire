import { PrismaService } from '@bg-empire/api-prisma';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateIdentityProviderDto } from '../dto/create-identity-provider.dto';
import { UpdateIdentityProviderDto } from '../dto/update-identity-provider.dto';

@Injectable()
export class IdentityProviderService {
  constructor(private prisma: PrismaService) {}

  /**
   * Get all identity providers
   */
  async findAll() {
    return this.prisma.identityProvider.findMany({
      select: {
        id: true,
        name: true,
        provider: true,
        enabled: true,
        discoveryUrl: true,
        clientId: true,
        // Don't include clientSecret
        authorizationUrl: true,
        tokenUrl: true,
        userInfoUrl: true,
        jwksUrl: true,
        scopes: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  /**
   * Get one identity provider
   */
  async findOne(providerId: string) {
    const provider = await this.prisma.identityProvider.findUnique({
      where: { id: providerId },
      select: {
        id: true,
        name: true,
        provider: true,
        enabled: true,
        discoveryUrl: true,
        clientId: true,
        // Don't include clientSecret
        authorizationUrl: true,
        tokenUrl: true,
        userInfoUrl: true,
        jwksUrl: true,
        scopes: true,
        createdAt: true,
        updatedAt: true,
      },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider with ID "${providerId}" not found`);
    }

    return provider;
  }

  /**
   * Create a new identity provider
   */
  async create(createIdentityProviderDto: CreateIdentityProviderDto) {
    // Check if provider already exists
    const existingProvider = await this.prisma.identityProvider.findFirst({
      where: {
        OR: [{ name: createIdentityProviderDto.name }, { provider: createIdentityProviderDto.provider }],
      },
    });

    if (existingProvider) {
      throw new BadRequestException('Identity provider with this name or provider already exists');
    }

    // If discovery URL is provided, fetch configuration
    if (createIdentityProviderDto.discoveryUrl && !createIdentityProviderDto.authorizationUrl) {
      try {
        const configResponse = await fetch(createIdentityProviderDto.discoveryUrl);
        if (!configResponse.ok) {
          throw new BadRequestException('Failed to fetch OIDC configuration from discovery URL');
        }

        const config = await configResponse.json();
        createIdentityProviderDto.authorizationUrl = config.authorization_endpoint;
        createIdentityProviderDto.tokenUrl = config.token_endpoint;
        createIdentityProviderDto.userInfoUrl = config.userinfo_endpoint;
        createIdentityProviderDto.jwksUrl = config.jwks_uri;
      } catch (error) {
        throw new BadRequestException(`Failed to fetch OIDC configuration: ${error.message}`);
      }
    }

    // Create provider
    return this.prisma.identityProvider.create({
      data: createIdentityProviderDto,
      select: {
        id: true,
        name: true,
        provider: true,
        enabled: true,
        discoveryUrl: true,
        clientId: true,
        // Don't include clientSecret
        authorizationUrl: true,
        tokenUrl: true,
        userInfoUrl: true,
        jwksUrl: true,
        scopes: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  /**
   * Update an identity provider
   */
  async update(providerId: string, updateIdentityProviderDto: UpdateIdentityProviderDto) {
    // Check if provider exists
    const provider = await this.prisma.identityProvider.findUnique({
      where: { id: providerId },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider with ID "${providerId}" not found`);
    }

    // If name or provider is changed, check for uniqueness
    if (updateIdentityProviderDto.name || updateIdentityProviderDto.provider) {
      const existingProvider = await this.prisma.identityProvider.findFirst({
        where: {
          OR: [
            updateIdentityProviderDto.name ? { name: updateIdentityProviderDto.name } : {},
            updateIdentityProviderDto.provider ? { provider: updateIdentityProviderDto.provider } : {},
          ],
          NOT: { id: providerId },
        },
      });

      if (existingProvider) {
        throw new BadRequestException('Identity provider with this name or provider already exists');
      }
    }

    // If discovery URL is updated, fetch configuration
    if (updateIdentityProviderDto.discoveryUrl) {
      try {
        const configResponse = await fetch(updateIdentityProviderDto.discoveryUrl);
        if (!configResponse.ok) {
          throw new BadRequestException('Failed to fetch OIDC configuration from discovery URL');
        }

        const config = await configResponse.json();
        updateIdentityProviderDto.authorizationUrl = config.authorization_endpoint;
        updateIdentityProviderDto.tokenUrl = config.token_endpoint;
        updateIdentityProviderDto.userInfoUrl = config.userinfo_endpoint;
        updateIdentityProviderDto.jwksUrl = config.jwks_uri;
      } catch (error) {
        throw new BadRequestException(`Failed to fetch OIDC configuration: ${error.message}`);
      }
    }

    // Update provider
    return this.prisma.identityProvider.update({
      where: { id: providerId },
      data: updateIdentityProviderDto,
      select: {
        id: true,
        name: true,
        provider: true,
        enabled: true,
        discoveryUrl: true,
        clientId: true,
        // Don't include clientSecret
        authorizationUrl: true,
        tokenUrl: true,
        userInfoUrl: true,
        jwksUrl: true,
        scopes: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  /**
   * Delete an identity provider
   */
  async remove(providerId: string) {
    // Check if provider exists
    const provider = await this.prisma.identityProvider.findUnique({
      where: { id: providerId },
      include: {
        identities: {
          select: { id: true },
        },
      },
    });

    if (!provider) {
      throw new NotFoundException(`Identity provider with ID "${providerId}" not found`);
    }

    // Check if provider is in use
    if (provider.identities.length > 0) {
      throw new BadRequestException('Cannot delete identity provider that is in use');
    }

    // Delete provider
    await this.prisma.identityProvider.delete({
      where: { id: providerId },
    });

    return { message: 'Identity provider deleted successfully' };
  }
}
