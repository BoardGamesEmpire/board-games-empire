import {
  BadRequestException,
  Controller,
  Get,
  HttpStatus,
  Param,
  Post,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { OidcCallbackDto } from '../dto/oidc-callback.dto';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { OidcService } from '../services/oidc.service';

@ApiTags('OpenID Connect')
@Controller('auth/oidc')
export class OidcController {
  constructor(private readonly oidcService: OidcService) {}

  @ApiOperation({ summary: 'Initiate OIDC authentication' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Authentication initiated, redirect URL provided',
  })
  @Get(':provider')
  async initiateOidcAuth(@Param('provider') provider: string, @Query('redirectUri') redirectUri: string) {
    return this.oidcService.initiateAuthentication(provider, redirectUri);
  }

  @ApiOperation({ summary: 'Handle OIDC callback' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Authentication successful',
  })
  @Get('callback')
  async oidcCallback(@Query() query: OidcCallbackDto) {
    if (!query.state || !query.code) {
      throw new BadRequestException('Missing required parameters');
    }

    return this.oidcService.handleCallback(query.state, query.code);
  }

  @ApiOperation({ summary: 'Link external account to existing user' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Account linking initiated, redirect URL provided',
  })
  @UseGuards(JwtAuthGuard)
  @Post('link/:provider')
  async linkAccount(@Param('provider') provider: string, @Request() req: any) {
    return this.oidcService.initiateAccountLinking(provider, req.user.id);
  }

  @ApiOperation({ summary: 'Unlink external account from user' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Account unlinked successfully',
  })
  @UseGuards(JwtAuthGuard)
  @Post('unlink/:provider')
  async unlinkAccount(@Param('provider') provider: string, @Request() req: any) {
    return this.oidcService.unlinkAccount(provider, req.user.id);
  }

  @ApiOperation({ summary: "Get user's linked accounts" })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Linked accounts retrieved',
  })
  @UseGuards(JwtAuthGuard)
  @Get('accounts')
  async getLinkedAccounts(@Request() req: any) {
    return this.oidcService.getLinkedAccounts(req.user.id);
  }
}
