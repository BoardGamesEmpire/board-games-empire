import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { MechanicsService } from './mechanics.service';
import { CreateMechanicDto } from './dto/create-mechanic.dto';
import { UpdateMechanicDto } from './dto/update-mechanic.dto';

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

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.mechanicsService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateMechanicDto: UpdateMechanicDto) {
    return this.mechanicsService.update(uuid, updateMechanicDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.mechanicsService.remove(uuid);
  }
}
