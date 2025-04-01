import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { GameTypesService } from './game-types.service';
import { CreateGameTypeDto } from './dto/create-game-type.dto';
import { UpdateGameTypeDto } from './dto/update-game-type.dto';
import { ParseCUIDPipe } from '../pipes/parse-cuid.pipe';

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

  @Get(':id')
  findOne(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.gameTypesService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', new ParseCUIDPipe()) id: string, @Body() updateGameTypeDto: UpdateGameTypeDto) {
    return this.gameTypesService.update(id, updateGameTypeDto);
  }

  @Delete(':id')
  remove(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.gameTypesService.remove(id);
  }
}
