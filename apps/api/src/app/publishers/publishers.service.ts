import { PrismaService } from '@bg-empire/api/prisma';
import { Injectable } from '@nestjs/common';
import { CreatePublisherDto } from './dto/create-publisher.dto';
import { UpdatePublisherDto } from './dto/update-publisher.dto';

@Injectable()
export class PublishersService {
  constructor(private readonly prisma: PrismaService) {}

  create(createPublisherDto: CreatePublisherDto) {
    return this.prisma.publisher.create({ data: createPublisherDto });
  }

  findAll() {
    return this.prisma.publisher.findMany();
  }

  findOne(id: string) {
    return this.prisma.publisher.findUnique({
      where: {
        id,
      },
    });
  }

  update(id: string, updatePublisherDto: UpdatePublisherDto) {
    return this.prisma.publisher.update({
      where: {
        id,
      },
      data: updatePublisherDto,
    });
  }

  remove(id: string) {
    return this.prisma.publisher.delete({
      where: {
        id,
      },
    });
  }
}
