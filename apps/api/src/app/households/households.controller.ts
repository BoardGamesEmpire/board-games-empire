import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { HouseholdsService } from './households.service';
import { CreateHouseholdDto } from './dto/create-household.dto';
import { UpdateHouseholdDto } from './dto/update-household.dto';
import { ParseCUIDPipe } from '../pipes/parse-cuid.pipe';

@Controller('households')
export class HouseholdsController {
  constructor(private readonly householdsService: HouseholdsService) {}

  @Post()
  create(@Body() createHouseholdDto: CreateHouseholdDto) {
    return this.householdsService.create(createHouseholdDto);
  }

  @Get()
  findAll() {
    return this.householdsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.householdsService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', new ParseCUIDPipe()) id: string, @Body() updateHouseholdDto: UpdateHouseholdDto) {
    return this.householdsService.update(id, updateHouseholdDto);
  }

  @Delete(':id')
  remove(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.householdsService.remove(id);
  }
}
