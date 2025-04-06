import { Public } from '@bg-empire/api-auth';
import { Controller, Get, Res, VERSION_NEUTRAL } from '@nestjs/common';
import { PrometheusController } from '@willsoto/nestjs-prometheus';
import type { Response } from 'express';
import { AppService } from './app.service';

@Controller({ version: VERSION_NEUTRAL })
export class AppController extends PrometheusController {
  constructor(private readonly appService: AppService) {
    super();
  }

  @Public()
  @Get('metrics')
  override index(@Res({ passthrough: true }) response: Response) {
    return super.index(response);
  }

  @Public()
  @Get('info')
  getData() {
    return this.appService.getData();
  }

  @Public()
  @Get('health')
  health() {
    return this.appService.health();
  }
}
