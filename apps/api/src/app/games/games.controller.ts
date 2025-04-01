import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { GamesService } from './games.service';
import { CreateGameDto } from './dto/create-game.dto';
import { UpdateGameDto } from './dto/update-game.dto';
import { ParseCUIDPipe } from '../pipes/parse-cuid.pipe';

@Controller('games')
export class GamesController {
  constructor(private readonly gamesService: GamesService) {}

  @Post()
  create(@Body() createGameDto: CreateGameDto) {
    return this.gamesService.create(createGameDto);
  }

  @Get()
  findAll() {
    return this.gamesService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.gamesService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', new ParseCUIDPipe()) id: string, @Body() updateGameDto: UpdateGameDto) {
    return this.gamesService.update(id, updateGameDto);
  }

  @Delete(':id')
  remove(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.gamesService.remove(id);
  }
}
