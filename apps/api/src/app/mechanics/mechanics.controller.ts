import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { MechanicsService } from './mechanics.service';
import { CreateMechanicDto } from './dto/create-mechanic.dto';
import { UpdateMechanicDto } from './dto/update-mechanic.dto';
import { ParseCUIDPipe } from '../pipes/parse-cuid.pipe';

@Controller('mechanics')
export class MechanicsController {
  constructor(private readonly mechanicsService: MechanicsService) {}

  @Post()
  create(@Body() createMechanicDto: CreateMechanicDto) {
    return this.mechanicsService.create(createMechanicDto);
  }

  @Get()
  findAll() {
    return this.mechanicsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.mechanicsService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', new ParseCUIDPipe()) id: string, @Body() updateMechanicDto: UpdateMechanicDto) {
    return this.mechanicsService.update(id, updateMechanicDto);
  }

  @Delete(':id')
  remove(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.mechanicsService.remove(id);
  }
}
