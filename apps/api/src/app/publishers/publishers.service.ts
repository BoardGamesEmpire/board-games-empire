import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
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

  findOne(uuid: string) {
    return this.prisma.publisher.findUnique({
      where: {
        uuid,
      },
    });
  }

  update(uuid: string, updatePublisherDto: UpdatePublisherDto) {
    return this.prisma.publisher.update({
      where: {
        uuid,
      },
      data: updatePublisherDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.publisher.delete({
      where: {
        uuid,
      },
    });
  }
}
