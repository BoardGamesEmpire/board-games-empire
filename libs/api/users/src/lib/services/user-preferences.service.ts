import { PrismaService } from '@bg-empire/api/prisma';
import { Injectable, NotFoundException } from '@nestjs/common';
import { UpdateUserPreferencesDto } from '../dto/update-user-preferences.dto';

@Injectable()
export class UserPreferencesService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Find user preferences by user ID
   */
  async findByUserId(userId: string) {
    const preferences = await this.prisma.userPreferences.findUnique({
      where: { userId },
      include: {
        language: true,
      },
    });

    if (!preferences) {
      // Create default preferences if not found
      return this.createDefaultPreferences(userId);
    }

    return preferences;
  }

  /**
   * Update user preferences
   */
  async update(userId: string, updatePreferencesDto: UpdateUserPreferencesDto) {
    // Check if user exists
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    // Check if preferences exist, create if not
    const existingPreferences = await this.prisma.userPreferences.findUnique({
      where: { userId },
    });

    if (!existingPreferences) {
      // Create preferences with the provided updates
      return this.prisma.userPreferences.create({
        data: {
          userId,
          ...updatePreferencesDto,
        },
        include: {
          language: true,
        },
      });
    }

    // Update preferences
    return this.prisma.userPreferences.update({
      where: { userId },
      data: updatePreferencesDto,
      include: {
        language: true,
      },
    });
  }

  /**
   * Create default user preferences
   */
  private async createDefaultPreferences(userId: string) {
    // Check if user exists
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    // Find default language (English)
    const defaultLanguage = await this.prisma.language.findFirst({
      where: { code: 'eng' },
    });

    // Create default preferences
    return this.prisma.userPreferences.create({
      data: {
        userId,
        theme: 'system',
        showOnlineStatus: true,
        showLastActive: true,
        allowFriendRequests: true,
        showCollectionToFriends: true,
        showGamePlayHistory: true,
        languageId: defaultLanguage?.id,
        defaultReviewVisibility: 'Private',
      },
      include: {
        language: true,
      },
    });
  }
}
