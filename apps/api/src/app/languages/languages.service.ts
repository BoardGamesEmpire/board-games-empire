import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateLanguageDto } from './dto/create-language.dto';
import { UpdateLanguageDto } from './dto/update-language.dto';

@Injectable()
export class LanguagesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createLanguageDto: CreateLanguageDto) {
    return this.prisma.language.create({ data: createLanguageDto });
  }

  findAll() {
    return this.prisma.language.findMany();
  }

  findOne(id: string) {
    return this.prisma.language.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: string, updateLanguageDto: UpdateLanguageDto) {
    return this.prisma.language.update({
      where: {
        id,
      },
      data: updateLanguageDto,
    });
  }

  remove(id: string) {
    return this.prisma.language.delete({
      where: {
        id,
      },
    });
  }
}
