import { WsJwtGuard } from '@bg-empire/api-websocket';
import { Logger, UseGuards } from '@nestjs/common';
import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  WsException,
} from '@nestjs/websockets';
import { from, Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { Server, Socket } from 'socket.io';
import { GameGatewayService } from '../services/game-gateway.service';

@WebSocketGateway({
  namespace: 'game-gateway',
  cors: {
    origin: '*',
    credentials: true,
  },
})
export class GameSourceGatewayEventGateway implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect {
  private readonly logger = new Logger(GameSourceGatewayEventGateway.name);

  @WebSocketServer()
  server: Server;

  constructor(private readonly gameSourceGatewayService: GameGatewayService) {}

  afterInit(_server: Server) {
    this.logger.log('GameSourceGateway WebSocket Server Initialized');
  }

  handleConnection(client: Socket) {
    this.logger.debug(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.logger.debug(`Client disconnected: ${client.id}`);
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('gateway.create')
  handleGatewayCreate(@ConnectedSocket() client: Socket, @MessageBody() createDto: any): Observable<any> {
    this.logger.debug(`Gateway create event from user ${client.data?.user?.id}`);

    try {
      this.validateAdminRole(client.data?.user);
    } catch (error) {
      return of({
        event: 'gateway.created.error',
        data: { error: error.message },
      });
    }

    return from(this.gameSourceGatewayService.create(createDto, client.data?.user?.id)).pipe(
      map((gateway) => ({
        event: 'gateway.created',
        data: gateway,
      })),
      catchError((error) => {
        this.logger.error(`Error creating gateway: ${error.message}`);
        return of({
          event: 'gateway.created.error',
          data: { error: error.message },
        });
      }),
    );
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('gateway.list')
  handleGatewayList(
    @ConnectedSocket() client: Socket,
    @MessageBody() filters?: { enabled?: boolean },
  ): Observable<any> {
    this.logger.debug(`Gateway list event from user ${client.data?.user?.id}`);

    const serviceCall =
      filters?.enabled !== undefined
        ? this.gameSourceGatewayService.findWithFilters(filters.enabled === true)
        : this.gameSourceGatewayService.findAll();

    return from(serviceCall).pipe(
      map((gateways) => ({
        event: 'gateway.listed',
        data: { gateways },
      })),
      catchError((error) => {
        this.logger.error(`Error listing gateways: ${error.message}`);
        return of({
          event: 'gateway.listed.error',
          data: { error: error.message },
        });
      }),
    );
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('gateway.get')
  handleGatewayGet(@ConnectedSocket() client: Socket, @MessageBody() data: { id: string }): Observable<any> {
    this.logger.debug(`Gateway get event from user ${client.data?.user?.id}`);

    if (!data?.id) {
      return of({
        event: 'gateway.fetched.error',
        data: { error: 'Gateway ID is required' },
      });
    }

    return from(this.gameSourceGatewayService.findOne(data.id)).pipe(
      map((gateway) => ({
        event: 'gateway.fetched',
        data: gateway,
      })),
      catchError((error) => {
        this.logger.error(`Error getting gateway: ${error.message}`);
        return of({
          event: 'gateway.fetched.error',
          data: { error: error.message },
        });
      }),
    );
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('gateway.update')
  handleGatewayUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { id: string; updates: any },
  ): Observable<any> {
    this.logger.debug(`Gateway update event from user ${client.data?.user?.id}`);

    try {
      this.validateAdminRole(client.data?.user);
    } catch (error) {
      return of({
        event: 'gateway.updated.error',
        data: { error: error.message },
      });
    }

    if (!data?.id) {
      return of({
        event: 'gateway.updated.error',
        data: { error: 'Gateway ID is required' },
      });
    }

    if (!data?.updates) {
      return of({
        event: 'gateway.updated.error',
        data: { error: 'Update data is required' },
      });
    }

    return from(this.gameSourceGatewayService.update(data.id, data.updates)).pipe(
      map((gateway) => ({
        event: 'gateway.updated',
        data: gateway,
      })),
      catchError((error) => {
        this.logger.error(`Error updating gateway: ${error.message}`);
        return of({
          event: 'gateway.updated.error',
          data: { error: error.message },
        });
      }),
    );
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('gateway.delete')
  handleGatewayDelete(@ConnectedSocket() client: Socket, @MessageBody() data: { id: string }): Observable<any> {
    this.logger.debug(`Gateway delete event from user ${client.data?.user?.id}`);

    try {
      this.validateAdminRole(client.data?.user);
    } catch (error) {
      return of({
        event: 'gateway.deleted.error',
        data: { error: error.message },
      });
    }

    if (!data?.id) {
      return of({
        event: 'gateway.deleted.error',
        data: { error: 'Gateway ID is required' },
      });
    }

    return from(this.gameSourceGatewayService.remove(data.id)).pipe(
      map(() => ({
        event: 'gateway.deleted',
        data: {
          id: data.id,
          message: 'Game source gateway deleted successfully',
        },
      })),
      catchError((error) => {
        this.logger.error(`Error deleting gateway: ${error.message}`);
        return of({
          event: 'gateway.deleted.error',
          data: { error: error.message },
        });
      }),
    );
  }

  @UseGuards(WsJwtGuard)
  @SubscribeMessage('gateway.recordUsage')
  handleGatewayUsageRecord(@ConnectedSocket() client: Socket, @MessageBody() data: { id: string }): Observable<any> {
    this.logger.debug(`Gateway record usage event from user ${client.data?.user?.id}`);

    if (!data?.id) {
      return of({
        event: 'gateway.usageRecorded.error',
        data: { error: 'Gateway ID is required' },
      });
    }

    return from(this.gameSourceGatewayService.recordUsage(data.id)).pipe(
      map((gateway) => ({
        event: 'gateway.usageRecorded',
        data: gateway,
      })),
      catchError((error) => {
        this.logger.error(`Error recording gateway usage: ${error.message}`);
        return of({
          event: 'gateway.usageRecorded.error',
          data: { error: error.message },
        });
      }),
    );
  }

  /**
   * @todo Use casl
   */
  private validateAdminRole(user: any): void {
    if (!user?.roles || !user.roles.includes('Admin')) {
      throw new WsException('Admin role required for this operation');
    }
  }
}
