import { PartialType } from '@nestjs/swagger';
import { CreateGameTypeDto } from './create-game-type.dto';

export class UpdateGameTypeDto extends PartialType(CreateGameTypeDto) {}
