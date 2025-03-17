import { PartialType } from '@nestjs/swagger';
import { CreateDesignerDto } from './create-designer.dto';

export class UpdateDesignerDto extends PartialType(CreateDesignerDto) {}
