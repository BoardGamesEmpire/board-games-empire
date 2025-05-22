import { PrismaService } from '@bg-empire/api-prisma';
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { AuthType } from '@prisma/client';
import { CreateGameGatewayDto } from '../dto/create-game-gateway.dto';
import { UpdateGameGatewayDto } from '../dto/update-game-gateway.dto';

@Injectable()
export class GameGatewayService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Create a new game gateway
   */
  async create(createGameGatewayDto: CreateGameGatewayDto, userId?: string) {
    await this.validateAuthParameters(createGameGatewayDto.authType, createGameGatewayDto.authParameters);

    const existingGateway = await this.prisma.gameGateway.findUnique({
      where: { name: createGameGatewayDto.name },
    });

    if (existingGateway) {
      throw new BadRequestException(`Game gateway with name "${createGameGatewayDto.name}" already exists`);
    }

    return this.prisma.gameGateway.create({
      data: {
        ...createGameGatewayDto,
        createdById: userId,
      },
    });
  }

  /**
   * Find all game gateways
   */
  findAll() {
    return this.prisma.gameGateway.findMany({
      orderBy: { name: 'asc' },
    });
  }

  /**
   * Find game gateways with filters
   */
  async findWithFilters(enabled?: boolean) {
    return this.prisma.gameGateway.findMany({
      where: enabled !== undefined ? { enabled } : undefined,
      orderBy: { name: 'asc' },
    });
  }

  /**
   * Find a single game gateway by ID
   */
  async findOne(id: string) {
    const gateway = await this.prisma.gameGateway.findUnique({
      where: { id },
    });

    if (!gateway) {
      throw new NotFoundException(`Game gateway with ID "${id}" not found`);
    }

    return gateway;
  }

  /**
   * Update a game gateway
   */
  async update(id: string, updateGameGatewayDto: UpdateGameGatewayDto) {
    const gateway = await this.prisma.gameGateway.findUnique({
      where: { id },
    });

    if (!gateway) {
      throw new NotFoundException(`Game gateway with ID "${id}" not found`);
    }

    // If changing the auth type or parameters, validate them
    if (
      (updateGameGatewayDto.authType && updateGameGatewayDto.authType !== gateway.authType) ||
      updateGameGatewayDto.authParameters
    ) {
      const authType = updateGameGatewayDto.authType || gateway.authType;
      const authParameters = updateGameGatewayDto.authParameters || gateway.authParameters;

      await this.validateAuthParameters(authType, authParameters);
    }

    // If changing the name, check for duplicates
    if (updateGameGatewayDto.name && updateGameGatewayDto.name !== gateway.name) {
      const existingWithName = await this.prisma.gameGateway.findUnique({
        where: { name: updateGameGatewayDto.name },
      });

      if (existingWithName) {
        throw new BadRequestException(`Game gateway with name "${updateGameGatewayDto.name}" already exists`);
      }
    }

    return this.prisma.gameGateway.update({
      where: { id },
      data: updateGameGatewayDto,
    });
  }

  /**
   * Remove a game gateway
   */
  async remove(id: string) {
    const gateway = await this.prisma.gameGateway.findUnique({
      where: { id },
      include: {
        _count: {
          select: {
            gameReferences: true,
            gameImplementations: true,
          },
        },
      },
    });

    if (!gateway) {
      throw new NotFoundException(`Game gateway with ID "${id}" not found`);
    }

    const totalReferences = gateway._count.gameReferences + gateway._count.gameImplementations;
    if (totalReferences > 0) {
      throw new BadRequestException(
        `Cannot delete gateway that is in use. It has ${gateway._count.gameReferences} game references and ${gateway._count.gameImplementations} game implementations.`,
      );
    }

    await this.prisma.gameGateway.delete({
      where: { id },
    });

    return { success: true, message: 'Game gateway deleted successfully' };
  }

  /**
   * Record usage of a game gateway
   */
  async recordUsage(id: string) {
    return this.prisma.gameGateway.update({
      where: { id },
      data: {
        usageCount: { increment: 1 },
        lastUsed: new Date(),
      },
    });
  }

  /**
   * Validate authentication parameters based on auth type
   */
  private async validateAuthParameters(authType: AuthType, authParameters: any): Promise<void> {
    // Skip validation if auth type is None or parameters are undefined
    if (authType === AuthType.None || !authParameters) {
      return;
    }

    // Validate parameters based on auth type
    switch (authType) {
      case AuthType.OAuth:
        this.validateRequiredFields(authParameters, [
          'clientId',
          'clientSecret',
          'authorizationUrl',
          'tokenUrl',
          'redirectUri',
        ]);
        break;

      case AuthType.ApiKey:
        this.validateRequiredFields(authParameters, ['apiKey']);
        if (!authParameters.headerName && !authParameters.queryParamName) {
          throw new BadRequestException(
            'Either headerName or queryParamName must be specified for API Key authentication',
          );
        }
        break;

      case AuthType.BasicAuth:
        this.validateRequiredFields(authParameters, ['username', 'password']);
        break;

      case AuthType.PSK:
        this.validateRequiredFields(authParameters, ['key']);
        break;

      case AuthType.JWT:
        this.validateRequiredFields(authParameters, ['token']);
        break;

      case AuthType.Certificate:
        this.validateRequiredFields(authParameters, ['clientCertificate', 'clientPrivateKey']);
        break;

      case AuthType.HMAC:
        this.validateRequiredFields(authParameters, ['secretKey', 'algorithm']);
        break;

      default:
        throw new BadRequestException(`Unsupported authentication type: ${authType}`);
    }
  }

  /**
   * Validate that required fields exist in the parameters object
   */
  private validateRequiredFields(parameters: any, requiredFields: string[]): void {
    for (const field of requiredFields) {
      if (!parameters[field]) {
        throw new BadRequestException(`Missing required field for authentication parameters: ${field}`);
      }
    }
  }
}
