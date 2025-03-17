import { Injectable } from '@nestjs/common';
import { User } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';

@Injectable()
export class AuthService {
  constructor(private readonly usersService: UsersService) {}

  async validateUser(username: string, password: string): Promise<User> {
    const user = await this.usersService.findOneByUsername(username);
    if (!user) {
      return null;
    }

    const compareResult = await bcrypt.compare(password, user.password);
    if (!compareResult) {
      return null;
    }

    return user;
  }
}
