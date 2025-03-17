import { Body, Controller, Delete, Get, Param, ParseUUIDPipe, Patch, Post } from '@nestjs/common';
import { DesignersService } from './designers.service';
import type { CreateDesignerDto } from './dto/create-designer.dto';
import type { UpdateDesignerDto } from './dto/update-designer.dto';

@Controller('designers')
export class DesignersController {
  constructor(private readonly designersService: DesignersService) {}

  @Post()
  create(@Body() createDesignerDto: CreateDesignerDto) {
    return this.designersService.create(createDesignerDto);
  }

  @Get()
  findAll() {
    return this.designersService.findAll();
  }

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.designersService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateDesignerDto: UpdateDesignerDto) {
    return this.designersService.update(uuid, updateDesignerDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.designersService.remove(uuid);
  }
}
