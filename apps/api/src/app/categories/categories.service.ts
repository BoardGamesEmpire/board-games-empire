import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';

@Injectable()
export class CategoriesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createCategoryDto: CreateCategoryDto) {
    return this.prisma.category.create({ data: createCategoryDto });
  }

  findAll() {
    return this.prisma.category.findMany();
  }

  findOne(uuid: string) {
    return this.prisma.category.findUnique({
      where: { uuid },
    });
  }

  update(uuid: string, updateCategoryDto: UpdateCategoryDto) {
    return this.prisma.category.update({
      where: {
        uuid,
      },
      data: updateCategoryDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.category.delete({
      where: {
        uuid,
      },
    });
  }
}
