import database from './database.config';
import graphql from './graphql.config';
import jwt from './jwt.config';
import security from './security.config';
import server from './server.config';
import swagger from './swagger.config';
import throttle from './throttle.config';

export const configuration = [server, database, swagger, graphql, jwt, throttle, security];
