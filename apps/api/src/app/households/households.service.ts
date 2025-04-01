import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateHouseholdDto } from './dto/create-household.dto';
import { UpdateHouseholdDto } from './dto/update-household.dto';

@Injectable()
export class HouseholdsService {
  constructor(private readonly prisma: PrismaService) {}

  create(createHouseholdDto: CreateHouseholdDto) {
    return this.prisma.household.create({ data: createHouseholdDto });
  }

  findAll() {
    return this.prisma.household.findMany();
  }

  findOne(id: string) {
    return this.prisma.household.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: string, updateHouseholdDto: UpdateHouseholdDto) {
    return this.prisma.household.update({
      where: {
        id,
      },
      data: updateHouseholdDto,
    });
  }

  remove(id: string) {
    return this.prisma.household.delete({
      where: {
        id,
      },
    });
  }
}
