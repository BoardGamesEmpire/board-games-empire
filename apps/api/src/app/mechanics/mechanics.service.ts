import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
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

  findOne(uuid: string) {
    return this.prisma.mechanic.findUnique({
      where: {
        uuid,
      },
    });
  }

  update(uuid: string, updateMechanicDto: UpdateMechanicDto) {
    return this.prisma.mechanic.update({
      where: {
        uuid,
      },
      data: updateMechanicDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.mechanic.delete({
      where: {
        uuid,
      },
    });
  }
}
