import { Injectable } from '@nestjs/common';
import { createRemoteJWKSet, jwtVerify } from 'jose';

@Injectable()
export class JoseService {
  private jwkSets = new Map<string, any>();

  /**
   * Verify an ID token
   */
  async verifyIdToken(idToken: string, clientId: string, nonce?: string): Promise<any> {
    try {
      // Parse the token to get the issuer
      const tokenParts = idToken.split('.');
      if (tokenParts.length !== 3) {
        throw new Error('Invalid token format');
      }

      const payload = JSON.parse(Buffer.from(tokenParts[1], 'base64').toString());
      const issuer = payload.iss;

      // Get or create a JWKS client for this issuer
      let jwks = this.jwkSets.get(issuer);
      if (!jwks) {
        jwks = createRemoteJWKSet(new URL(`${issuer}/.well-known/jwks.json`));
        this.jwkSets.set(issuer, jwks);
      }

      // Verify the token
      const { payload: verifiedPayload } = await jwtVerify(idToken, jwks, {
        audience: clientId,
        issuer,
        ...(nonce ? { nonce } : {}),
      });

      return verifiedPayload;
    } catch (error) {
      throw new Error(`ID token verification failed: ${(<Error>error).message}`);
    }
  }
}
