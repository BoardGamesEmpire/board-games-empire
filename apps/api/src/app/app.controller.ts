import { Public } from '@bg-empire/api/auth';
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Public()
  @Get()
  getData() {
    return this.appService.getData();
  }

  @Public()
  @Get('health')
  health() {
    return this.appService.health();
  }
}
