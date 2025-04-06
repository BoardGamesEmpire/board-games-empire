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
      const tokenParts = idToken.split('.');
      if (tokenParts.length !== 3) {
        throw new Error('Invalid token format');
      }

      const payload = JSON.parse(Buffer.from(tokenParts[1], 'base64').toString());

      let jwks = this.jwkSets.get(payload.iss);
      if (!jwks) {
        jwks = createRemoteJWKSet(new URL(`${payload.iss}/.well-known/jwks.json`));
        this.jwkSets.set(payload.iss, jwks);
      }

      const { payload: verifiedPayload } = await jwtVerify(idToken, jwks, {
        audience: clientId,
        issuer: payload.iss,
        ...(nonce ? { nonce } : {}),
      });
      return verifiedPayload;
    } catch (error) {
      throw new Error(`ID token verification failed: ${(<Error>error).message}`);
    }
  }
}
