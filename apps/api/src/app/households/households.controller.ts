import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { HouseholdsService } from './households.service';
import { CreateHouseholdDto } from './dto/create-household.dto';
import { UpdateHouseholdDto } from './dto/update-household.dto';

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

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.householdsService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateHouseholdDto: UpdateHouseholdDto) {
    return this.householdsService.update(uuid, updateHouseholdDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.householdsService.remove(uuid);
  }
}
