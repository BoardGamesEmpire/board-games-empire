import { PrismaService } from '@bg-empire/api-prisma';
import { Injectable, Logger } from '@nestjs/common';
import { WebSocketService } from '../services/websocket.service';

@Injectable()
export class GameSearchHandler {
  private readonly logger = new Logger(GameSearchHandler.name);

  constructor(private readonly prisma: PrismaService, private readonly wsService: WebSocketService) {
    this.wsService.registerRequestHandler('searchGames', this.handleSearchGames.bind(this));
  }

  async handleSearchGames(user: any, payload: { query: string; externalSource?: string }) {
    this.logger.log(`Handling game search request from user ${user.id}: ${payload.query}`);

    try {
      if (!payload?.query) {
        throw new Error('Search query is required');
      }

      const { query, externalSource } = payload;
      const internalResults = await this.prisma.game.findMany({
        where: {
          OR: [
            { title: { contains: query, mode: 'insensitive' } },
            { subtitle: { contains: query, mode: 'insensitive' } },
            { description: { contains: query, mode: 'insensitive' } },
          ],
          AND: [
            {
              OR: [
                { visibility: 'Public' },
                { visibility: 'Friends', sharedWithUsers: { some: { userId: user.id } } },
                { createdById: user.id },
              ],
            },
          ],
        },
        select: {
          id: true,
          title: true,
          subtitle: true,
          description: true,
          image: true,
          publishYear: true,
          minPlayers: true,
          maxPlayers: true,
          playingTime: true,
          isFromExternal: true,
          externalId: true,
          createdAt: true,
        },
        take: 20,
      });

      const externalResults = externalSource ? await this.mockExternalSearch(query, externalSource) : [];

      const searchResult = {
        internalResults,
        externalResults,
        searchTerm: query,
        externalSource,
      };

      this.wsService.sendToUser(user.id, 'searchResults', searchResult);

      return searchResult;
    } catch (error) {
      this.logger.error(`Error in game search: ${error.message}`);
      throw error;
    }
  }

  // Mock function to simulate external API calls - call external APIs
  private async mockExternalSearch(query: string, source: string) {
    return [
      {
        id: `ext-${Math.random().toString(36).substring(2, 9)}`,
        title: `${source} Game: ${query}`,
        subtitle: 'External game result',
        description: 'This is a mock external game result',
        image: 'https://via.placeholder.com/150',
        publishYear: 2023,
        minPlayers: 2,
        maxPlayers: 4,
        playingTime: 60,
        isFromExternal: true,
        externalId: `${source}-${Date.now()}`,
        externalSource: source,
      },
    ];
  }
}
