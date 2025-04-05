import { PartialType } from '@nestjs/swagger';
import { CreateIdentityProviderDto } from './create-identity-provider.dto';

export class UpdateIdentityProviderDto extends PartialType(CreateIdentityProviderDto) {}
