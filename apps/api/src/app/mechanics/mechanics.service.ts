import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable } from '@nestjs/common';
import { CreateMechanicDto } from './dto/create-mechanic.dto';
import { UpdateMechanicDto } from './dto/update-mechanic.dto';

@Injectable()
export class MechanicsService {
  constructor(private readonly prisma: PrismaService) {}

  create(createMechanicDto: CreateMechanicDto) {
    return this.prisma.mechanic.create({ data: createMechanicDto });
  }

  findAll() {
    return this.prisma.mechanic.findMany();
  }

  findOne(id: string) {
    return this.prisma.mechanic.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: string, updateMechanicDto: UpdateMechanicDto) {
    return this.prisma.mechanic.update({
      where: {
        id,
      },
      data: updateMechanicDto,
    });
  }

  remove(id: string) {
    return this.prisma.mechanic.delete({
      where: {
        id,
      },
    });
  }
}
