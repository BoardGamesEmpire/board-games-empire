import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGameDto } from './dto/create-game.dto';
import { UpdateGameDto } from './dto/update-game.dto';

@Injectable()
export class GamesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createGameDto: CreateGameDto) {
    return this.prisma.game.create({ data: createGameDto });
  }

  findAll() {
    return this.prisma.game.findMany();
  }

  findOne(uuid: string) {
    return this.prisma.game.findUnique({
      where: {
        uuid,
      },
    });
  }

  update(uuid: string, updateGameDto: UpdateGameDto) {
    return this.prisma.game.update({
      where: {
        uuid,
      },
      data: updateGameDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.game.delete({
      where: {
        uuid,
      },
    });
  }
}
