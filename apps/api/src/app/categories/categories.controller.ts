import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';

@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Post()
  create(@Body() createCategoryDto: CreateCategoryDto) {
    return this.categoriesService.create(createCategoryDto);
  }

  @Get()
  findAll() {
    return this.categoriesService.findAll();
  }

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.categoriesService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateCategoryDto: UpdateCategoryDto) {
    return this.categoriesService.update(uuid, updateCategoryDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.categoriesService.remove(uuid);
  }
}
