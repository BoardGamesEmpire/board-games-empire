import { JwtAuthGuard, Roles } from '@bg-empire/api-auth';
import {
  Body,
  Controller,
  Delete,
  Get,
  HttpStatus,
  Param,
  Patch,
  Post,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CreateGameGatewayDto } from '../dto/create-game-gateway.dto';
import { GameGatewayResponseDto } from '../dto/game-gateway-response.dto';
import { UpdateGameGatewayDto } from '../dto/update-game-gateway.dto';
import { GameGatewayService } from '../services/game-gateway.service';

@ApiTags('Game Gateways')
@Controller('game-gateways')
export class GameGatewayController {
  constructor(private readonly gameGatewayService: GameGatewayService) {}

  @ApiOperation({ summary: 'Create a new game gateway' })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'The game gateway has been successfully created',
    type: GameGatewayResponseDto,
  })
  @ApiResponse({
    status: HttpStatus.BAD_REQUEST,
    description: 'Invalid input or gateway with the same name already exists',
  })
  @UseGuards(JwtAuthGuard)
  @Roles('Admin')
  @Post()
  async create(@Body() createGameGatewayDto: CreateGameGatewayDto, @Request() req: any) {
    return this.gameGatewayService.create(createGameGatewayDto, req.user.id);
  }

  @ApiOperation({ summary: 'Get all game gateways' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'List of all game gateways',
    type: [GameGatewayResponseDto],
  })
  @UseGuards(JwtAuthGuard)
  @Get()
  async findAll(@Query('enabled') enabled?: boolean) {
    if (enabled !== undefined) {
      return this.gameGatewayService.findWithFilters(enabled === true);
    }

    return this.gameGatewayService.findAll();
  }

  @ApiOperation({ summary: 'Get a specific game gateway by ID' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'The game gateway',
    type: GameGatewayResponseDto,
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'Game gateway not found',
  })
  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.gameGatewayService.findOne(id);
  }

  @ApiOperation({ summary: 'Update a game gateway' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'The game gateway has been successfully updated',
    type: GameGatewayResponseDto,
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'Game gateway not found',
  })
  @ApiResponse({
    status: HttpStatus.BAD_REQUEST,
    description: 'Invalid input data',
  })
  @UseGuards(JwtAuthGuard)
  @Roles('Admin')
  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateGameSourceGatewayDto: UpdateGameGatewayDto) {
    return this.gameGatewayService.update(id, updateGameSourceGatewayDto);
  }

  @ApiOperation({ summary: 'Delete a game gateway' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'The game gateway has been successfully deleted',
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'Game gateway not found',
  })
  @ApiResponse({
    status: HttpStatus.BAD_REQUEST,
    description: 'Cannot delete a gateway that is in use',
  })
  @UseGuards(JwtAuthGuard)
  @Roles('Admin')
  @Delete(':id')
  async remove(@Param('id') id: string) {
    return this.gameGatewayService.remove(id);
  }

  @ApiOperation({ summary: 'Record usage of a game gateway' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Usage recorded successfully',
    type: GameGatewayResponseDto,
  })
  @ApiResponse({
    status: HttpStatus.NOT_FOUND,
    description: 'Game gateway not found',
  })
  @UseGuards(JwtAuthGuard)
  @Post(':id/record-usage')
  async recordUsage(@Param('id') id: string) {
    return this.gameGatewayService.recordUsage(id);
  }
}
