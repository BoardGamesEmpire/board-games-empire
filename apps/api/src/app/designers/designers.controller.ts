import { Body, Controller, Delete, Get, Param, Patch, Post } from '@nestjs/common';
import { DesignersService } from './designers.service';
import type { CreateDesignerDto } from './dto/create-designer.dto';
import type { UpdateDesignerDto } from './dto/update-designer.dto';
import { ParseCUIDPipe } from '../pipes/parse-cuid.pipe';

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

  @Get(':id')
  findOne(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.designersService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', new ParseCUIDPipe()) id: string, @Body() updateDesignerDto: UpdateDesignerDto) {
    return this.designersService.update(id, updateDesignerDto);
  }

  @Delete(':id')
  remove(@Param('id', new ParseCUIDPipe()) id: string) {
    return this.designersService.remove(id);
  }
}
