import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateDesignerDto } from './dto/create-designer.dto';
import { UpdateDesignerDto } from './dto/update-designer.dto';

@Injectable()
export class DesignersService {
  constructor(private readonly prisma: PrismaService) {}

  create(createDesignerDto: CreateDesignerDto) {
    return this.prisma.designer.create({ data: createDesignerDto });
  }

  findAll() {
    return this.prisma.designer.findMany();
  }

  findOne(id: string) {
    return this.prisma.designer.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: string, updateDesignerDto: UpdateDesignerDto) {
    return this.prisma.designer.update({
      where: {
        id,
      },
      data: updateDesignerDto,
    });
  }

  remove(id: string) {
    return this.prisma.designer.delete({
      where: {
        id,
      },
    });
  }
}
