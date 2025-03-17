import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  create(createUserDto: CreateUserDto) {
    return this.prisma.user.create({ data: createUserDto });
  }

  findAll() {
    return this.prisma.user.findMany();
  }

  findOne(uuid: string) {
    return this.prisma.user.findUnique({
      where: {
        uuid,
      },
    });
  }

  findOneByUsername(username: string) {
    return this.prisma.user.findUnique({
      where: {
        username,
      },
    });
  }

  update(uuid: string, updateUserDto: UpdateUserDto) {
    return this.prisma.user.update({
      where: {
        uuid,
      },
      data: updateUserDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.user.delete({
      where: {
        uuid,
      },
    });
  }
}
