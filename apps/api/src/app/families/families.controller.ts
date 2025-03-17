import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { FamiliesService } from './families.service';
import { CreateFamilyDto } from './dto/create-family.dto';
import { UpdateFamilyDto } from './dto/update-family.dto';

@Controller('families')
export class FamiliesController {
  constructor(private readonly familiesService: FamiliesService) {}

  @Post()
  create(@Body() createFamilyDto: CreateFamilyDto) {
    return this.familiesService.create(createFamilyDto);
  }

  @Get()
  findAll() {
    return this.familiesService.findAll();
  }

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.familiesService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateFamilyDto: UpdateFamilyDto) {
    return this.familiesService.update(uuid, updateFamilyDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.familiesService.remove(uuid);
  }
}
