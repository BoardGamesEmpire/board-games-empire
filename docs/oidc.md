# OIDC Authentication Architecture

This document outlines the architecture for implementing OpenID Connect (OIDC) authentication alongside local authentication in your Board Game Tracker application.

## Data Model Overview

The authentication system is built around the following models:

1. **User** - Enhanced with external identity support
2. **IdentityProvider** - Configuration for OIDC providers
3. **UserExternalIdentity** - Links users to their external identities
4. **OidcAuthSession** - Manages OIDC authentication flows
5. **AuthStrategy** - Enum defining supported authentication methods

## Authentication Flow

### Local Authentication Flow

1. User enters email/username and password
2. System validates credentials against stored password hash
3. Upon successful validation, a JWT token is issued
4. User is authenticated for subsequent requests

### OIDC Authentication Flow

1. **Initiation**:
   - User clicks "Login with [Provider]"
   - System creates an `OidcAuthSession` with state, nonce, and PKCE parameters
   - User is redirected to the provider's authorization endpoint

2. **Authorization**:
   - User authenticates with the provider
   - Provider redirects back to the application callback URL with an authorization code

3. **Token Exchange**:
   - System validates the state parameter against the stored `OidcAuthSession`
   - System exchanges the authorization code for tokens using the token endpoint
   - System validates the ID token (signature, expiration, nonce, etc.)

4. **User Profile Processing**:
   - System extracts user information from the ID token and/or userinfo endpoint
   - System looks up existing `UserExternalIdentity` for the provider and external ID

5. **Account Linking or Creation**:
   - If a matching `UserExternalIdentity` exists:
     - User is logged in to the associated account
   - If no match exists but email matches an existing user:
     - (Optional) System prompts user to link accounts
     - A new `UserExternalIdentity` is created and linked to the existing user
   - If no match exists at all:
     - System creates a new `User` with `isExternalUser=true`
     - System creates a new `UserExternalIdentity` linked to the new user

6. **Session Establishment**:
   - System issues a JWT token for the authenticated user
   - External tokens are stored securely for later use if needed

## Implementation Components

### 1. NestJS Module Structure

```
apps/api/src/auth/
  ├── strategies/
  │   ├── local.strategy.ts        # Local authentication strategy
  │   ├── jwt.strategy.ts          # JWT verification strategy
  │   └── oidc.strategy.ts         # OIDC authentication strategy
  ├── guards/
  │   ├── auth.guard.ts            # Generic authentication guard
  │   ├── local-auth.guard.ts      # Local authentication guard
  │   └── oidc-auth.guard.ts       # OIDC authentication guard
  ├── controllers/
  │   ├── auth.controller.ts       # Main authentication endpoints
  │   └── oidc.controller.ts       # OIDC-specific endpoints
  ├── services/
  │   ├── auth.service.ts          # Core authentication logic
  │   ├── jwt.service.ts           # JWT token handling
  │   ├── oidc.service.ts          # OIDC authentication logic
  │   └── identity-provider.service.ts  # Identity provider management
  └── auth.module.ts               # Authentication module definition
```

### 2. Key Interfaces and DTOs

```typescript
// oidc-auth-request.dto.ts
export class OidcAuthRequestDto {
  @IsString()
  @IsNotEmpty()
  provider: string;
  
  @IsOptional()
  @IsString()
  redirectUri?: string;
}

// oidc-callback.dto.ts
export class OidcCallbackDto {
  @IsString()
  @IsNotEmpty()
  state: string;
  
  @IsString()
  @IsNotEmpty()
  code: string;
}

// identity-provider.dto.ts
export class CreateIdentityProviderDto {
  @IsString()
  @IsNotEmpty()
  name: string;
  
  @IsString()
  @IsNotEmpty()
  provider: string;
  
  @IsString()
  @IsNotEmpty()
  clientId: string;
  
  @IsString()
  @IsNotEmpty()
  clientSecret: string;
  
  @IsOptional()
  @IsString()
  discoveryUrl?: string;
  
  // Additional fields...
}
```

### 3. API Endpoints

```typescript
// auth.controller.ts
@Controller('auth')
export class AuthController {
  // Local login
  @Post('login')
  @UseGuards(LocalAuthGuard)
  login(@Request() req) {
    return this.authService.login(req.user);
  }
  
  // User registration
  @Post('register')
  register(@Body() createUserDto: CreateUserDto) {
    return this.authService.register(createUserDto);
  }
  
  // Get current user profile
  @Get('profile')
  @UseGuards(JwtAuthGuard)
  getProfile(@Request() req) {
    return req.user;
  }
}

// oidc.controller.ts
@Controller('auth/oidc')
export class OidcController {
  // Initiate OIDC authentication
  @Get(':provider')
  async initiateOidcAuth(
    @Param('provider') provider: string,
    @Query('redirectUri') redirectUri: string,
  ) {
    return this.oidcService.initiateAuthentication(provider, redirectUri);
  }
  
  // OIDC callback handling
  @Get('callback')
  async oidcCallback(
    @Query() query: OidcCallbackDto,
  ) {
    return this.oidcService.handleCallback(query.state, query.code);
  }
  
  // Link external account to existing user
  @Post('link/:provider')
  @UseGuards(JwtAuthGuard)
  async linkAccount(
    @Param('provider') provider: string,
    @Request() req,
  ) {
    return this.oidcService.initiateAccountLinking(provider, req.user.id);
  }
}
```

## Security Considerations

1. **Token Storage**:
   - Access and refresh tokens must be encrypted before storage
   - Consider using a dedicated encryption service

2. **PKCE Implementation**:
   - Use PKCE (Proof Key for Code Exchange) for all OIDC flows
   - Store code_verifier securely in the OidcAuthSession

3. **State Parameter Validation**:
   - Always validate the state parameter to prevent CSRF attacks
   - Set short expiration times for OidcAuthSession records

4. **ID Token Validation**:
   - Validate signature, expiration, issuer, audience, and nonce
   - Consider using a library like `jose` for JWT validation

5. **Provider Configuration**:
   - Store client secrets securely using environment variables or secrets manager
   - Consider allowing only admin users to manage identity providers

## Account Linking Strategy

When a user authenticates via OIDC:

1. **Automatic Linking** (Default):
   - If the email from OIDC matches an existing user, automatically link accounts
   - User can then log in with either method

2. **Manual Linking** (More Secure):
   - User must explicitly link accounts by authenticating with both methods
   - Prevents account takeover if email addresses can be spoofed

3. **Hybrid Approach**:
   - Automatic linking for providers with verified emails (like Google)
   - Manual linking for providers where email verification is uncertain

Configure this behavior based on your security requirements.

## Extending for Additional Providers

The modular design makes it easy to add new identity providers:

1. Add the provider to the `AuthStrategy` enum
2. Create a record in the `IdentityProvider` table with appropriate configuration
3. Ensure the OIDC service can handle any provider-specific requirements

No code changes are needed for standard OIDC providers that follow the specification.
