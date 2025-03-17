import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { LanguagesService } from './languages.service';
import { CreateLanguageDto } from './dto/create-language.dto';
import { UpdateLanguageDto } from './dto/update-language.dto';

@Controller('languages')
export class LanguagesController {
  constructor(private readonly languagesService: LanguagesService) {}

  @Post()
  create(@Body() createLanguageDto: CreateLanguageDto) {
    return this.languagesService.create(createLanguageDto);
  }

  @Get()
  findAll() {
    return this.languagesService.findAll();
  }

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.languagesService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updateLanguageDto: UpdateLanguageDto) {
    return this.languagesService.update(uuid, updateLanguageDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.languagesService.remove(uuid);
  }
}
