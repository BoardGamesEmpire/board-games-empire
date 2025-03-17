import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGameTypeDto } from './dto/create-game-type.dto';
import { UpdateGameTypeDto } from './dto/update-game-type.dto';

@Injectable()
export class GameTypesService {
  constructor(private readonly prisma: PrismaService) {}

  create(createGameTypeDto: CreateGameTypeDto) {
    return this.prisma.gameType.create({ data: createGameTypeDto });
  }

  findAll() {
    return this.prisma.gameType.findMany();
  }

  findOne(uuid: string) {
    return this.prisma.gameType.findUnique({
      where: {
        uuid,
      },
    });
  }

  update(uuid: string, updateGameTypeDto: UpdateGameTypeDto) {
    return this.prisma.gameType.update({
      where: {
        uuid,
      },
      data: updateGameTypeDto,
    });
  }

  remove(uuid: string) {
    return this.prisma.gameType.delete({
      where: {
        uuid,
      },
    });
  }
}
