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

  findOne(uuid: string) {
    return this.prisma.language.findUnique({
      where: {
        uuid,
      },
    });
  }

  update(uuid: string, updateLanguageDto: UpdateLanguageDto) {
    return this.prisma.language.update({
      where: {
        uuid,
      },
      data: updateLanguageDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.language.delete({
      where: {
        uuid,
      },
    });
  }
}
