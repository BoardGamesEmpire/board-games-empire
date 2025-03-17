import { PartialType } from '@nestjs/swagger';
import { CreateMechanicDto } from './create-mechanic.dto';

export class UpdateMechanicDto extends PartialType(CreateMechanicDto) {}
