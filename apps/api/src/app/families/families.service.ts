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

  findOne(uuid: string) {
    return this.prisma.family.findUnique({
      where: {
        uuid,
      },
    });
  }

  update(uuid: string, updateFamilyDto: UpdateFamilyDto) {
    return this.prisma.family.update({
      where: {
        uuid,
      },
      data: updateFamilyDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.family.delete({
      where: {
        uuid,
      },
    });
  }
}
