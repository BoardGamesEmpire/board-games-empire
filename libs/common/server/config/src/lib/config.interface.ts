import { ConfigType } from '@nestjs/config';
import database from './configs/database.config';
import graphql from './configs/graphql.config';
import jwt from './configs/jwt.config';
import rabbit from './configs/rabbitmq.config';
import security from './configs/security.config';
import server from './configs/server.config';
import swagger from './configs/swagger.config';
import throttle from './configs/throttle.config';

export interface Configs {
  server: ConfigType<typeof server>;
  database: ConfigType<typeof database>;
  swagger: ConfigType<typeof swagger>;
  graphql: ConfigType<typeof graphql>;
  jwt: ConfigType<typeof jwt>;
  throttle: ConfigType<typeof throttle>;
  security: ConfigType<typeof security>;
  rabbitmq: ConfigType<typeof rabbit>;
}
