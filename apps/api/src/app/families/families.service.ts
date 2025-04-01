import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateFamilyDto } from './dto/create-family.dto';
import { UpdateFamilyDto } from './dto/update-family.dto';

@Injectable()
export class FamiliesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createFamilyDto: CreateFamilyDto) {
    return this.prisma.family.create({ data: createFamilyDto });
  }

  findAll() {
    return this.prisma.family.findMany();
  }

  findOne(id: string) {
    return this.prisma.family.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: string, updateFamilyDto: UpdateFamilyDto) {
    return this.prisma.family.update({
      where: {
        id,
      },
      data: updateFamilyDto,
    });
  }

  remove(id: string) {
    return this.prisma.family.delete({
      where: {
        id,
      },
    });
  }
}
