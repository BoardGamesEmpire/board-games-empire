import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { PublishersService } from './publishers.service';
import { CreatePublisherDto } from './dto/create-publisher.dto';
import { UpdatePublisherDto } from './dto/update-publisher.dto';

@Controller('publishers')
export class PublishersController {
  constructor(private readonly publishersService: PublishersService) {}

  @Post()
  create(@Body() createPublisherDto: CreatePublisherDto) {
    return this.publishersService.create(createPublisherDto);
  }

  @Get()
  findAll() {
    return this.publishersService.findAll();
  }

  @Get(':uuid')
  findOne(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.publishersService.findOne(uuid);
  }

  @Patch(':uuid')
  update(@Param('uuid', new ParseUUIDPipe()) uuid: string, @Body() updatePublisherDto: UpdatePublisherDto) {
    return this.publishersService.update(uuid, updatePublisherDto);
  }

  @Delete(':uuid')
  remove(@Param('uuid', new ParseUUIDPipe()) uuid: string) {
    return this.publishersService.remove(uuid);
  }
}
