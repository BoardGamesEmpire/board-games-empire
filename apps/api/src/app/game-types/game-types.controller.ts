import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { GameTypesService } from './game-types.service';
import { CreateGameTypeDto } from './dto/create-game-type.dto';
import { UpdateGameTypeDto } from './dto/update-game-type.dto';

@Controller('game-types')
export class GameTypesController {
  constructor(private readonly gameTypesService: GameTypesService) {}

  @Post()
  create(@Body() createGameTypeDto: CreateGameTypeDto) {
    return this.gameTypesService.create(createGameTypeDto);
  }

  @Get()
  findAll() {
    return this.gameTypesService.findAll();
  }

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.gameTypesService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateGameTypeDto: UpdateGameTypeDto) {
    return this.gameTypesService.update(uuid, updateGameTypeDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.gameTypesService.remove(uuid);
  }
}
