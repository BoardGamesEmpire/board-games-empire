-- CreateEnum
CREATE TYPE "achievement_types" AS ENUM ('Collector', 'Completionist', 'EventsAttended', 'EventsHosted', 'FriendsAdded', 'GameMaster', 'GameMastery', 'GamesOwned', 'GamesPlayed', 'GamesRated', 'PlayStreak', 'Socialite', 'WinStreak');

-- CreateEnum
CREATE TYPE "artist_roles" AS ENUM ('Primary', 'Cover', 'Component', 'Illustration', 'Graphic', 'Supporting');

-- CreateEnum
CREATE TYPE "auth_strategies" AS ENUM ('Apple', 'Custom', 'Facebook', 'GitHub', 'Google', 'Local', 'Microsoft');

-- CreateEnum
CREATE TYPE "campaign_statuses" AS ENUM ('Planning', 'Active', 'OnHiatus', 'Completed', 'Abandoned', 'Cancelled');

-- CreateEnum
CREATE TYPE "designer_roles" AS ENUM ('Primary', 'Secondary', 'Developer', 'Contributor');

-- CreateEnum
CREATE TYPE "event_participant_roles" AS ENUM ('CoHost', 'Guest', 'Host', 'Moderator', 'Organizer', 'Participant', 'Spectator');

-- CreateEnum
CREATE TYPE "event_participation_statuses" AS ENUM ('Attending', 'Invited', 'Maybe', 'NotAttending');

-- CreateEnum
CREATE TYPE "attendee_types" AS ENUM ('Participant', 'Guest', 'Organizer');

-- CreateEnum
CREATE TYPE "family_types" AS ENUM ('Series', 'Universe', 'Reimplementation', 'System', 'Brand', 'Collection', 'Publisher');

-- CreateEnum
CREATE TYPE "friendship_statuses" AS ENUM ('Accepted', 'Blocked', 'Declined', 'Pending', 'Unfriended');

-- CreateEnum
CREATE TYPE "game_conditions" AS ENUM ('Acceptable', 'Good', 'LikeNew', 'New', 'Poor', 'VeryGood');

-- CreateEnum
CREATE TYPE "game_platforms" AS ENUM ('Android', 'BoardGameArena', 'EpicGames', 'iOS', 'OtherDigital', 'PhysicalOnly', 'PlayStation', 'Steam', 'Switch', 'Tabletopia', 'TabletopSimulator', 'Vassal', 'WebBased', 'Xbox');

-- CreateEnum
CREATE TYPE "pricing_models" AS ENUM ('Free', 'Freemium', 'Mixed', 'PaidUpfront', 'Subscription');

-- CreateEnum
CREATE TYPE "game_night_types" AS ENUM ('AdultsOnly', 'CasualGathering', 'CompetitivePlay', 'FamilyNight', 'KidFriendly', 'LearningSession', 'LongGameDay', 'MixedAges', 'PartyGames', 'StrategyNight');

-- CreateEnum
CREATE TYPE "game_play_contexts" AS ENUM ('Campaign', 'Casual', 'Competitive', 'Convention', 'Demo', 'League', 'OneShot', 'OrganizedEvent', 'Tournament', 'Virtual');

-- CreateEnum
CREATE TYPE "result_types" AS ENUM ('Custom', 'Elimination', 'Placement', 'Points', 'Score', 'Time');

-- CreateEnum
CREATE TYPE "weight_sources" AS ENUM ('Internal', 'BoardGameGeek', 'UserAverage', 'ExpertRating');

-- CreateEnum
CREATE TYPE "learning_curves" AS ENUM ('Gentle', 'Moderate', 'Stepped', 'Steep', 'Cliff');

-- CreateEnum
CREATE TYPE "time_measures" AS ENUM ('Minutes', 'Hours', 'Days', 'Weeks', 'Months', 'Years');

-- CreateEnum
CREATE TYPE "household_game_ownerships" AS ENUM ('Borrowed', 'Digital', 'HouseholdOwned', 'MemberOwned');

-- CreateEnum
CREATE TYPE "InterestLevel" AS ENUM ('Favorite', 'VeryInterested', 'Interested', 'Neutral', 'Disinterested', 'StronglyDislike', 'WillNotPlay');

-- CreateEnum
CREATE TYPE "invite_statuses" AS ENUM ('Accepted', 'AwaitingApproval', 'Declined', 'Expired', 'Pending', 'Revoked', 'Withdrawn');

-- CreateEnum
CREATE TYPE "learning_difficulties" AS ENUM ('Challenging', 'Easy', 'Moderate', 'VeryDifficult', 'VeryEasy');

-- CreateEnum
CREATE TYPE "mechanic_relationship_types" AS ENUM ('Alternative', 'Complementary', 'Conflicting', 'Evolution', 'Prerequisite', 'Similar', 'SubMechanic');

-- CreateEnum
CREATE TYPE "media_types" AS ENUM ('ActionShot', 'BoardState', 'BoxArt', 'Card', 'ComponentPhoto', 'GameSetup', 'Other', 'RuleBook', 'SessionPhoto', 'Video');

-- CreateEnum
CREATE TYPE "notification_types" AS ENUM ('EventInvite', 'EventReminder', 'GameCollectionUpdate', 'GameReturnReminder', 'GameReview', 'General', 'HouseholdInvite', 'System', 'UserMention', 'UserTag', 'WishListItem');

-- CreateEnum
CREATE TYPE "permissions" AS ENUM ('ManageUsers', 'ViewUsers', 'ViewOwnProfile', 'UpdateOwnProfile', 'CreateHousehold', 'UpdateHousehold', 'DeleteHousehold', 'ManageHouseholdMembers', 'ViewHousehold', 'JoinHousehold', 'InviteToHousehold', 'AddGameToCollection', 'RemoveGameFromCollection', 'UpdateGameInCollection', 'ViewGameCollection', 'CreateEvent', 'UpdateEvent', 'DeleteEvent', 'ViewEvent', 'ManageEventParticipants', 'InviteToEvent', 'JoinEvent', 'CreateGameSession', 'UpdateGameSession', 'DeleteGameSession', 'ViewGameSession', 'JoinGameSession', 'RecordGamePlay', 'CreateCampaign', 'UpdateCampaign', 'DeleteCampaign', 'ManageCampaignMembers', 'CreateRuleVariant', 'UpdateRuleVariant', 'DeleteRuleVariant', 'CreateGame', 'UpdateGame', 'DeleteGame', 'ModerateContent', 'ManageSystemSettings', 'ViewPublicContent', 'CreatePrivateGame', 'ViewPrivateGames', 'ApproveGameCreationRequests', 'CreateUserGameCustomization', 'UpdateUserGameCustomization', 'DeleteUserGameCustomization', 'ViewUserGameCustomization', 'CreateHouseholdGameCustomization', 'UpdateHouseholdGameCustomization', 'DeleteHouseholdGameCustomization', 'ViewHouseholdGameCustomization', 'ImportGameFromExternalAPI', 'ManageGameMetadata', 'ShareGameWithUser', 'ShareGameWithHousehold', 'EditSharedGame', 'ViewSharedGame', 'ChangeGameVisibility');

-- CreateEnum
CREATE TYPE "policy_effects" AS ENUM ('Allow', 'Deny');

-- CreateEnum
CREATE TYPE "resource_types" AS ENUM ('Campaign', 'Event', 'Game', 'GameCollection', 'GameCreationRequest', 'GameCustomization', 'GamePlaySession', 'GameSharing', 'Household', 'HouseholdGameCustomization', 'RuleVariant', 'System', 'User', 'UserGameCustomization');

-- CreateEnum
CREATE TYPE "PlayDesire" AS ENUM ('Anytime', 'Occasionally', 'RarelyInterested', 'OnceMore', 'OnlyIfAsked', 'ReluctantlyWilling', 'NeverAgain');

-- CreateEnum
CREATE TYPE "player_dynamics" AS ENUM ('Competitive', 'Cooperative', 'Creative', 'Divisive', 'Energizing', 'Hilarious', 'Relaxing', 'Strategic', 'TeamBased');

-- CreateEnum
CREATE TYPE "publisher_roles" AS ENUM ('Primary', 'Localization', 'Distribution', 'Reprint');

-- CreateEnum
CREATE TYPE "rule_types" AS ENUM ('Addition', 'Clarification', 'Modification', 'Replacement', 'Restriction', 'Removal');

-- CreateEnum
CREATE TYPE "rule_compatibility_modes" AS ENUM ('AllExpansions', 'AllVersions', 'BaseGameOnly', 'ExactMatch', 'SpecificExpansions', 'SpecificVersions');

-- CreateEnum
CREATE TYPE "rule_categories" AS ENUM ('ActionEconomy', 'Advancement', 'CharacterCreation', 'Combat', 'Condition', 'Custom', 'Economy', 'Environment', 'Equipment', 'Experience', 'General', 'Initiative', 'Magic', 'Movement', 'Other', 'RestAndRecovery', 'SocialInteraction');

-- CreateEnum
CREATE TYPE "visibility_types" AS ENUM ('Friends', 'FriendsOfFriends', 'FriendsOfHouseholds', 'Household', 'Private', 'Public');

-- CreateTable
CREATE TABLE "achievements" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "icon" TEXT,
    "type" "achievement_types" NOT NULL,
    "threshold" INTEGER NOT NULL DEFAULT 1,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "achievements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "artists" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "fullName" TEXT,
    "website" TEXT,
    "biography" TEXT,
    "country" TEXT,
    "boardGameGeekUrl" TEXT,
    "twitterHandle" TEXT,
    "instagramHandle" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "artists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_artists" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "artistId" TEXT NOT NULL,
    "role" "artist_roles" NOT NULL DEFAULT 'Primary',
    "details" TEXT,

    CONSTRAINT "game_artists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "identity_providers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "clientSecret" TEXT NOT NULL,
    "discoveryUrl" TEXT,
    "authorizationUrl" TEXT,
    "tokenUrl" TEXT,
    "userInfoUrl" TEXT,
    "jwksUrl" TEXT,
    "scopes" TEXT[] DEFAULT ARRAY['openid', 'email', 'profile']::TEXT[],
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "identity_providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_external_identities" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "externalId" TEXT NOT NULL,
    "email" TEXT,
    "rawProfile" JSONB,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "tokenExpiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_external_identities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "oidc_auth_sessions" (
    "id" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "nonce" TEXT,
    "codeVerifier" TEXT,
    "redirectUri" TEXT NOT NULL,
    "userId" TEXT,
    "providerId" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "oidc_auth_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaigns" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "image" TEXT,
    "gameId" TEXT NOT NULL,
    "status" "campaign_statuses" NOT NULL DEFAULT 'Active',
    "startDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endDate" TIMESTAMP(3),
    "householdId" TEXT NOT NULL,
    "gameMasterId" TEXT NOT NULL,
    "currentLevel" INTEGER,
    "currentChapter" TEXT,
    "campaignNotes" TEXT,
    "gameSystemId" TEXT,
    "useCustomRules" BOOLEAN NOT NULL DEFAULT false,
    "customRules" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_characters" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "playerId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "class" TEXT,
    "race" TEXT,
    "level" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "experience" INTEGER,
    "attributes" JSONB,
    "inventory" JSONB,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaign_characters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_locations" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "locationType" TEXT,
    "isSecret" BOOLEAN NOT NULL DEFAULT false,
    "mapImage" TEXT,
    "notes" TEXT,
    "parentLocationId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaign_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_npcs" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "role" TEXT,
    "isSecret" BOOLEAN NOT NULL DEFAULT false,
    "isRecurring" BOOLEAN NOT NULL DEFAULT false,
    "stats" JSONB,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaign_npcs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_npc_appearances" (
    "id" TEXT NOT NULL,
    "npcId" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "role" TEXT,
    "wasEncountered" BOOLEAN NOT NULL DEFAULT true,
    "wasSignificant" BOOLEAN NOT NULL DEFAULT false,
    "significantEvent" TEXT,
    "notes" TEXT,

    CONSTRAINT "campaign_npc_appearances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_sessions" (
    "id" TEXT NOT NULL,
    "characterId" TEXT NOT NULL,
    "gamePlaySessionId" TEXT NOT NULL,
    "levelDuringSession" INTEGER,
    "experienceGained" INTEGER,
    "notesDuringSession" TEXT,

    CONSTRAINT "character_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_member_permissions" (
    "id" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "grantedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaign_member_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_session_outcomes" (
    "id" TEXT NOT NULL,
    "gamePlaySessionId" TEXT NOT NULL,
    "campaignId" TEXT NOT NULL,
    "storySummary" TEXT,
    "keyDecisions" JSONB,
    "worldChanges" JSONB,
    "npcChanges" JSONB,
    "treasureFound" JSONB,
    "experienceAwarded" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaign_session_outcomes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "parentCategoryId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_categories" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "designers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "fullName" TEXT,
    "website" TEXT,
    "biography" TEXT,
    "country" TEXT,
    "boardGameGeekUrl" TEXT,
    "debutYear" INTEGER,
    "totalCollaborators" INTEGER,
    "mostFrequentCollaboratorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "designers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_designers" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "designerId" TEXT NOT NULL,
    "role" "designer_roles" NOT NULL DEFAULT 'Primary',

    CONSTRAINT "game_designers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "designer_collaborations" (
    "id" TEXT NOT NULL,
    "primaryDesignerId" TEXT NOT NULL,
    "collaboratorId" TEXT NOT NULL,
    "collaborationCount" INTEGER NOT NULL DEFAULT 1,
    "firstCollaboration" INTEGER,
    "latestCollaboration" INTEGER,
    "strength" DOUBLE PRECISION,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "designer_collaborations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "createdById" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "image" TEXT,
    "description" TEXT,
    "location" TEXT,
    "url" TEXT,
    "visibility" "visibility_types" NOT NULL DEFAULT 'Friends',
    "allowGuestInvites" BOOLEAN NOT NULL DEFAULT true,
    "maxTotalParticipants" INTEGER,
    "strictCapacity" BOOLEAN NOT NULL DEFAULT false,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_attendees" (
    "id" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "attendeeType" "attendee_types" NOT NULL DEFAULT 'Participant',
    "userId" TEXT,
    "guestName" TEXT,
    "guestEmail" TEXT,
    "status" "event_participation_statuses" NOT NULL DEFAULT 'Invited',
    "role" "event_participant_roles" NOT NULL DEFAULT 'Participant',
    "invitedById" TEXT,
    "notes" TEXT,
    "rsvpDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "event_attendees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_game_votes" (
    "id" TEXT NOT NULL,
    "eventGameId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "eventId" TEXT,

    CONSTRAINT "event_game_votes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_games" (
    "id" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "suggestedById" TEXT NOT NULL,

    CONSTRAINT "event_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_member_permissions" (
    "id" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "grantedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "event_member_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "excluded_games" (
    "id" TEXT NOT NULL,
    "householdMemberId" TEXT NOT NULL,
    "gameCollectionId" TEXT NOT NULL,
    "excludedReason" TEXT,
    "excludedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "excluded_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "families" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "publisherId" TEXT,
    "logoUrl" TEXT,
    "website" TEXT,
    "familyType" "family_types" NOT NULL DEFAULT 'Series',
    "parentFamilyId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "families_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_families" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "familyId" TEXT NOT NULL,
    "position" INTEGER,
    "releaseOrder" INTEGER,
    "storyOrder" INTEGER,
    "isStandalone" BOOLEAN NOT NULL DEFAULT true,
    "requiredGameIds" TEXT[],
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_families_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_collections" (
    "id" TEXT NOT NULL,
    "familyId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "isComplete" BOOLEAN NOT NULL DEFAULT false,
    "missingCount" INTEGER,
    "collectedOn" TIMESTAMP(3),
    "notifyOnNewReleases" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "family_collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "friendships" (
    "id" TEXT NOT NULL,
    "requestorId" TEXT NOT NULL,
    "recipientId" TEXT NOT NULL,
    "status" "friendship_statuses" NOT NULL DEFAULT 'Pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "friendships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_household_access" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "canEdit" BOOLEAN NOT NULL DEFAULT false,
    "canShare" BOOLEAN NOT NULL DEFAULT false,
    "sharedById" TEXT NOT NULL,
    "sharedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_household_access_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_user_access" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "canEdit" BOOLEAN NOT NULL DEFAULT false,
    "canShare" BOOLEAN NOT NULL DEFAULT false,
    "sharedById" TEXT NOT NULL,
    "sharedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_user_access_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_expansions" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "baseGameId" TEXT NOT NULL,
    "description" TEXT,
    "releaseYear" INTEGER,
    "isStandalone" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_expansions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expansion_compatibilities" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "expansionId" TEXT NOT NULL,
    "isRecommended" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "expansion_compatibilities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_expansion_rule_variants" (
    "id" TEXT NOT NULL,
    "ruleVariantId" TEXT NOT NULL,
    "gameExpansionId" TEXT NOT NULL,
    "overrideCategory" "rule_categories",
    "overrideRuleText" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_expansion_rule_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_implementations" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "platform" "game_platforms" NOT NULL,
    "title" TEXT,
    "url" TEXT,
    "publisherId" TEXT,
    "releaseDate" TIMESTAMP(3),
    "version" TEXT,
    "lastUpdated" TIMESTAMP(3),
    "pricingModel" "pricing_models",
    "basePrice" DOUBLE PRECISION,
    "hasPurchases" BOOLEAN NOT NULL DEFAULT false,
    "isSubscription" BOOLEAN NOT NULL DEFAULT false,
    "supportsSolo" BOOLEAN NOT NULL DEFAULT false,
    "supportsLocal" BOOLEAN NOT NULL DEFAULT false,
    "supportsOnline" BOOLEAN NOT NULL DEFAULT false,
    "hasAsyncPlay" BOOLEAN NOT NULL DEFAULT false,
    "hasRealtime" BOOLEAN NOT NULL DEFAULT false,
    "hasTutorial" BOOLEAN NOT NULL DEFAULT false,
    "appStoreId" TEXT,
    "googlePlayId" TEXT,
    "steamAppId" TEXT,
    "boardGameArenaId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_implementations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "implementation_ratings" (
    "id" TEXT NOT NULL,
    "implementationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "rating" DOUBLE PRECISION NOT NULL,
    "review" TEXT,
    "usabilityRating" DOUBLE PRECISION,
    "featureRating" DOUBLE PRECISION,
    "aiRating" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "implementation_ratings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_sessions" (
    "id" TEXT NOT NULL,
    "eventId" TEXT,
    "gameId" TEXT NOT NULL,
    "campaignId" TEXT,
    "gameVersionId" TEXT,
    "sessionNumber" INTEGER,
    "chapter" TEXT,
    "milestone" TEXT,
    "campaignLocationId" TEXT,
    "playDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "duration" INTEGER,
    "location" TEXT,
    "context" "game_play_contexts" NOT NULL DEFAULT 'Casual',
    "householdId" TEXT,
    "venue" TEXT,
    "isComplete" BOOLEAN NOT NULL DEFAULT false,
    "wasInterrupted" BOOLEAN NOT NULL DEFAULT false,
    "playtime" INTEGER,
    "turns" INTEGER,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_play_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_participants" (
    "id" TEXT NOT NULL,
    "gamePlaySessionId" TEXT NOT NULL,
    "userId" TEXT,
    "guestName" TEXT,
    "campaignCharacterId" TEXT,
    "playerPosition" INTEGER,
    "team" TEXT,
    "finalScore" DOUBLE PRECISION,
    "placement" INTEGER,
    "winner" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "game_play_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_results" (
    "id" TEXT NOT NULL,
    "gamePlaySessionId" TEXT NOT NULL,
    "resultType" "result_types" NOT NULL DEFAULT 'Score',
    "scoringPhase" TEXT,
    "scoreDetails" JSONB,
    "teamScores" JSONB,
    "individualMetrics" JSONB,

    CONSTRAINT "game_play_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_session_expansions" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "expansionId" TEXT NOT NULL,

    CONSTRAINT "game_play_session_expansions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_reviews" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "rating" DOUBLE PRECISION NOT NULL,
    "visibility" "visibility_types" NOT NULL DEFAULT 'Household',
    "comment" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_systems" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "publisher" TEXT,
    "version" TEXT,
    "description" TEXT,
    "attributeSchema" JSONB,
    "classOptions" JSONB,
    "raceOptions" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_systems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_versions" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "versionName" TEXT NOT NULL,
    "releaseYear" INTEGER,
    "isBaseline" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_version_rule_variants" (
    "id" TEXT NOT NULL,
    "ruleVariantId" TEXT NOT NULL,
    "gameVersionId" TEXT NOT NULL,
    "overrideCategory" "rule_categories",
    "overrideRuleText" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_version_rule_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_weights" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "overallWeight" DOUBLE PRECISION,
    "rulesWeight" DOUBLE PRECISION,
    "strategyWeight" DOUBLE PRECISION,
    "luckWeight" DOUBLE PRECISION,
    "mathWeight" DOUBLE PRECISION,
    "socialWeight" DOUBLE PRECISION,
    "teachingTime" INTEGER,
    "learningCurve" "learning_curves",
    "weightSource" "weight_sources" NOT NULL DEFAULT 'Internal',
    "externalUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_weights_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_weight_votes" (
    "id" TEXT NOT NULL,
    "gameWeightId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "overallWeight" DOUBLE PRECISION,
    "rulesWeight" DOUBLE PRECISION,
    "strategyWeight" DOUBLE PRECISION,
    "luckWeight" DOUBLE PRECISION,
    "mathWeight" DOUBLE PRECISION,
    "socialWeight" DOUBLE PRECISION,
    "comments" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_weight_votes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "games" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "description" TEXT,
    "image" TEXT,
    "publishYear" INTEGER,
    "minPlayers" INTEGER,
    "maxPlayers" INTEGER,
    "playingTime" INTEGER,
    "minPlayTime" INTEGER,
    "minPlayTimeMeasure" "time_measures",
    "maxPlayTime" INTEGER,
    "maxPlayTimeMeasure" "time_measures",
    "minAge" INTEGER,
    "totalPlayCount" INTEGER NOT NULL DEFAULT 0,
    "averageRating" DOUBLE PRECISION,
    "complexity" DOUBLE PRECISION,
    "ownedByCount" INTEGER NOT NULL DEFAULT 0,
    "isPrivate" BOOLEAN NOT NULL DEFAULT false,
    "visibility" "visibility_types" NOT NULL DEFAULT 'Public',
    "createdById" TEXT,
    "isFromExternal" BOOLEAN NOT NULL DEFAULT false,
    "externalId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_collections" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "rating" INTEGER,
    "playCount" INTEGER,
    "playAgain" BOOLEAN,
    "favorite" BOOLEAN,
    "comment" TEXT,
    "lastPlayed" TIMESTAMP(3),
    "lastUpdated" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_media" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "mediaType" "media_types" NOT NULL,
    "url" TEXT NOT NULL,
    "thumbnailUrl" TEXT,
    "title" TEXT,
    "description" TEXT,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "uploadedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "loaned_games" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "loanToUserId" TEXT,
    "loanTo" TEXT,
    "loanToEmail" TEXT,
    "loanDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expectedReturnDate" TIMESTAMP(3),
    "actualReturnDate" TIMESTAMP(3),
    "notes" TEXT,

    CONSTRAINT "loaned_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_permissions" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "resourceType" "resource_types" NOT NULL,
    "resourceId" TEXT,

    CONSTRAINT "group_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permission_groups" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "permission_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_members" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "group_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_games" (
    "id" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "ownershipType" "household_game_ownerships" NOT NULL DEFAULT 'MemberOwned',
    "storageLocation" TEXT,
    "condition" "game_conditions",
    "missingPieces" TEXT,
    "houseRating" DOUBLE PRECISION,
    "playCount" INTEGER NOT NULL DEFAULT 0,
    "lastPlayed" TIMESTAMP(3),
    "isFavorite" BOOLEAN NOT NULL DEFAULT false,
    "bestPlayerCount" INTEGER,
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "unavailableReason" TEXT,
    "championedById" TEXT,
    "maintainedById" TEXT,
    "teacherId" TEXT,
    "mostFrequentWinner" TEXT,
    "winHistory" JSONB,
    "playerDynamics" "player_dynamics"[],
    "idealFor" "game_night_types"[],
    "learningDifficulty" "learning_difficulties",
    "teachingNotes" TEXT,
    "houseRuleCount" INTEGER NOT NULL DEFAULT 0,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_customizations" (
    "id" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "title" TEXT,
    "subtitle" TEXT,
    "description" TEXT,
    "image" TEXT,
    "publishYear" INTEGER,
    "minPlayers" INTEGER,
    "maxPlayers" INTEGER,
    "playingTime" INTEGER,
    "minPlayTime" INTEGER,
    "maxPlayTime" INTEGER,
    "minAge" INTEGER,
    "complexity" DOUBLE PRECISION,
    "customizedById" TEXT NOT NULL,
    "customizationNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_game_customizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_experiences" (
    "id" TEXT NOT NULL,
    "householdGameId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "photos" TEXT[],
    "tags" TEXT[],
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_game_experiences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_experience_participants" (
    "id" TEXT NOT NULL,
    "experienceId" TEXT NOT NULL,
    "memberId" TEXT NOT NULL,
    "role" TEXT,
    "hadFun" BOOLEAN,
    "notes" TEXT,
    "isHighlighted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_game_experience_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_interests" (
    "id" TEXT NOT NULL,
    "householdGameId" TEXT NOT NULL,
    "householdMemberId" TEXT NOT NULL,
    "interestLevel" "InterestLevel" NOT NULL DEFAULT 'Neutral',
    "playDesire" "PlayDesire" NOT NULL DEFAULT 'Anytime',
    "comments" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_game_interests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_customization_permissions" (
    "id" TEXT NOT NULL,
    "customizationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "grantedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_game_customization_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "households" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "name" TEXT NOT NULL,
    "image" TEXT,
    "languageId" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "households_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_roles" (
    "id" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_members" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "showAllGames" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "household_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_invites" (
    "id" TEXT NOT NULL,
    "eventId" TEXT NOT NULL,
    "invitedUserId" TEXT NOT NULL,
    "invitedById" TEXT NOT NULL,
    "status" "invite_statuses" NOT NULL DEFAULT 'Pending',
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "event_invites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "languages" (
    "abbreviation" VARCHAR(2) NOT NULL,
    "code" VARCHAR(3) NOT NULL,
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "languages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mechanics" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "complexity" INTEGER,
    "usageCount" INTEGER,
    "compatibilityScore" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mechanics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mechanic_relationships" (
    "id" TEXT NOT NULL,
    "primaryMechanicId" TEXT NOT NULL,
    "relatedMechanicId" TEXT NOT NULL,
    "relationshipType" "mechanic_relationship_types" NOT NULL,
    "strength" DOUBLE PRECISION NOT NULL,
    "description" TEXT,
    "createdById" TEXT,
    "communityRating" DOUBLE PRECISION,
    "supportEvidence" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "mechanic_relationships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_mechanics" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "gameId" TEXT NOT NULL,
    "mechanicId" TEXT NOT NULL,

    CONSTRAINT "game_mechanics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session_media" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "caption" TEXT,
    "uploadedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "session_media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "notification_types" NOT NULL,
    "message" TEXT NOT NULL,
    "relatedEntityId" TEXT,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permission_policies" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "resourceType" "resource_types" NOT NULL,
    "effect" "policy_effects" NOT NULL DEFAULT 'Allow',
    "conditions" JSONB,
    "permissions" TEXT[],
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "permission_policies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_policy_assignments" (
    "id" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "policyId" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "role_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_policy_assignments" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "policyId" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_policy_assignments" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "policyId" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "group_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "resource_policy_assignments" (
    "id" TEXT NOT NULL,
    "policyId" TEXT NOT NULL,
    "resourceType" "resource_types" NOT NULL,
    "resourceId" TEXT NOT NULL,
    "appliesToId" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "resource_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "publishers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "legalName" TEXT,
    "website" TEXT,
    "country" TEXT,
    "foundedYear" INTEGER,
    "parentCompanyId" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "logoUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "publishers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_publishers" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "publisherId" TEXT NOT NULL,
    "role" "publisher_roles" NOT NULL DEFAULT 'Primary',
    "releaseYear" INTEGER,
    "region" TEXT,

    CONSTRAINT "game_publishers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "id" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variants" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "campaignId" TEXT,
    "gameId" TEXT,
    "householdId" TEXT,
    "category" "rule_categories" NOT NULL DEFAULT 'General',
    "ruleType" "rule_types" NOT NULL DEFAULT 'Addition',
    "compatibilityMode" "rule_compatibility_modes" NOT NULL DEFAULT 'ExactMatch',
    "modifiesCore" BOOLEAN NOT NULL DEFAULT false,
    "replacedRuleRef" TEXT,
    "rulebookPage" INTEGER,
    "rulebookEdition" TEXT,
    "ruleText" TEXT NOT NULL,
    "examples" TEXT,
    "createdById" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "source" TEXT,
    "discussionLink" TEXT,
    "version" TEXT NOT NULL DEFAULT '1.0',
    "previousVersionId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rule_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variant_usages" (
    "id" TEXT NOT NULL,
    "ruleVariantId" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "wasEffective" BOOLEAN,
    "notes" TEXT,

    CONSTRAINT "rule_variant_usages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variant_usage_versions" (
    "id" TEXT NOT NULL,
    "ruleVariantUsageId" TEXT NOT NULL,
    "gameVersionId" TEXT NOT NULL,
    "wasApplicable" BOOLEAN NOT NULL DEFAULT true,
    "requiresErrata" BOOLEAN NOT NULL DEFAULT false,
    "errataDetails" TEXT,

    CONSTRAINT "rule_variant_usage_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variant_usage_expansions" (
    "id" TEXT NOT NULL,
    "ruleVariantUsageId" TEXT NOT NULL,
    "gameExpansionId" TEXT NOT NULL,
    "wasApplicable" BOOLEAN NOT NULL DEFAULT true,
    "requiredModification" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,

    CONSTRAINT "rule_variant_usage_expansions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_settings" (
    "id" TEXT NOT NULL,
    "allowPasswordResets" BOOLEAN NOT NULL DEFAULT true,
    "allowUserRegistration" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "system_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_tags" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "addedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tokens" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "id" TEXT NOT NULL,
    "token" VARCHAR(64) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "avatar" TEXT,
    "profileImage" TEXT,
    "username" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "bio" TEXT,
    "firstName" TEXT,
    "lastName" TEXT,
    "password" TEXT,
    "authStrategy" "auth_strategies" NOT NULL DEFAULT 'Local',
    "isExternalUser" BOOLEAN NOT NULL DEFAULT false,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "emailVerificationToken" TEXT,
    "emailVerificationTokenExpires" TIMESTAMP(3),
    "passwordResetToken" TEXT,
    "passwordResetTokenExpires" TIMESTAMP(3),
    "accountLocked" BOOLEAN NOT NULL DEFAULT false,
    "accountLockedUntil" TIMESTAMP(3),
    "failedLoginAttempts" INTEGER NOT NULL DEFAULT 0,
    "lastFailedLogin" TIMESTAMP(3),
    "lastLogin" TIMESTAMP(3),
    "lastPasswordChange" TIMESTAMP(3),
    "twoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
    "twoFactorSecret" TEXT,
    "recoveryCodesHash" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_preferences" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "theme" TEXT NOT NULL DEFAULT 'system',
    "accentColor" TEXT,
    "showOnlineStatus" BOOLEAN NOT NULL DEFAULT true,
    "showLastActive" BOOLEAN NOT NULL DEFAULT true,
    "allowFriendRequests" BOOLEAN NOT NULL DEFAULT true,
    "showCollectionToFriends" BOOLEAN NOT NULL DEFAULT true,
    "showGamePlayHistory" BOOLEAN NOT NULL DEFAULT true,
    "emailNotifications" JSONB,
    "pushNotifications" JSONB,
    "preferredPlayerCount" INTEGER,
    "preferredGameLength" INTEGER,
    "favoriteCategories" TEXT[],
    "favoriteMechanics" TEXT[],
    "dislikedCategories" TEXT[],
    "dislikedMechanics" TEXT[],
    "languageId" TEXT,
    "defaultReviewVisibility" "visibility_types" NOT NULL DEFAULT 'Private',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_permissions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "resourceType" "resource_types" NOT NULL,
    "resourceId" TEXT,
    "grantedById" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_login_histories" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "success" BOOLEAN NOT NULL DEFAULT true,
    "failureReason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_login_histories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_devices" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "deviceName" TEXT,
    "deviceIdentifier" TEXT NOT NULL,
    "lastUsed" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isTrusted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_game_customizations" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "title" TEXT,
    "subtitle" TEXT,
    "description" TEXT,
    "image" TEXT,
    "publishYear" INTEGER,
    "minPlayers" INTEGER,
    "maxPlayers" INTEGER,
    "playingTime" INTEGER,
    "minPlayTime" INTEGER,
    "maxPlayTime" INTEGER,
    "minAge" INTEGER,
    "complexity" DOUBLE PRECISION,
    "customizationNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_game_customizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_game_customization_permissions" (
    "id" TEXT NOT NULL,
    "customizationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "grantedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_game_customization_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_achievements" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "achievementId" TEXT NOT NULL,
    "earnedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "progress" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "user_achievements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wish_lists" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'My Wishlist',

    CONSTRAINT "wish_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wish_list_games" (
    "id" TEXT NOT NULL,
    "wishListId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "wish_list_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_DesignerCollaborationToGame" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_DesignerCollaborationToGame_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "game_artists_gameId_artistId_key" ON "game_artists"("gameId", "artistId");

-- CreateIndex
CREATE UNIQUE INDEX "identity_providers_name_key" ON "identity_providers"("name");

-- CreateIndex
CREATE UNIQUE INDEX "identity_providers_provider_key" ON "identity_providers"("provider");

-- CreateIndex
CREATE UNIQUE INDEX "user_external_identities_providerId_externalId_key" ON "user_external_identities"("providerId", "externalId");

-- CreateIndex
CREATE UNIQUE INDEX "oidc_auth_sessions_state_key" ON "oidc_auth_sessions"("state");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_npc_appearances_npcId_sessionId_key" ON "campaign_npc_appearances"("npcId", "sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "character_sessions_characterId_gamePlaySessionId_key" ON "character_sessions"("characterId", "gamePlaySessionId");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_member_permissions_campaignId_userId_permission_key" ON "campaign_member_permissions"("campaignId", "userId", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_session_outcomes_gamePlaySessionId_key" ON "campaign_session_outcomes"("gamePlaySessionId");

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_key" ON "categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_categories_gameId_categoryId_key" ON "game_categories"("gameId", "categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "unique_primary_category_per_game" ON "game_categories"("gameId", "isPrimary");

-- CreateIndex
CREATE UNIQUE INDEX "designers_name_key" ON "designers"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_designers_gameId_designerId_key" ON "game_designers"("gameId", "designerId");

-- CreateIndex
CREATE INDEX "designer_collaborations_primaryDesignerId_idx" ON "designer_collaborations"("primaryDesignerId");

-- CreateIndex
CREATE INDEX "designer_collaborations_collaboratorId_idx" ON "designer_collaborations"("collaboratorId");

-- CreateIndex
CREATE UNIQUE INDEX "designer_collaborations_primaryDesignerId_collaboratorId_key" ON "designer_collaborations"("primaryDesignerId", "collaboratorId");

-- CreateIndex
CREATE UNIQUE INDEX "event_game_votes_eventGameId_userId_key" ON "event_game_votes"("eventGameId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "event_member_permissions_eventId_userId_permission_key" ON "event_member_permissions"("eventId", "userId", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "excluded_games_householdMemberId_gameCollectionId_key" ON "excluded_games"("householdMemberId", "gameCollectionId");

-- CreateIndex
CREATE UNIQUE INDEX "families_name_key" ON "families"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_families_gameId_familyId_key" ON "game_families"("gameId", "familyId");

-- CreateIndex
CREATE UNIQUE INDEX "family_collections_familyId_userId_key" ON "family_collections"("familyId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "friendships_requestorId_recipientId_key" ON "friendships"("requestorId", "recipientId");

-- CreateIndex
CREATE UNIQUE INDEX "game_household_access_gameId_householdId_key" ON "game_household_access"("gameId", "householdId");

-- CreateIndex
CREATE UNIQUE INDEX "game_user_access_gameId_userId_key" ON "game_user_access"("gameId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "expansion_compatibilities_gameId_expansionId_key" ON "expansion_compatibilities"("gameId", "expansionId");

-- CreateIndex
CREATE UNIQUE INDEX "game_expansion_rule_variants_ruleVariantId_gameExpansionId_key" ON "game_expansion_rule_variants"("ruleVariantId", "gameExpansionId");

-- CreateIndex
CREATE UNIQUE INDEX "game_implementations_gameId_platform_key" ON "game_implementations"("gameId", "platform");

-- CreateIndex
CREATE UNIQUE INDEX "implementation_ratings_implementationId_userId_key" ON "implementation_ratings"("implementationId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "game_play_session_expansions_sessionId_expansionId_key" ON "game_play_session_expansions"("sessionId", "expansionId");

-- CreateIndex
CREATE UNIQUE INDEX "game_reviews_userId_gameId_key" ON "game_reviews"("userId", "gameId");

-- CreateIndex
CREATE UNIQUE INDEX "game_systems_name_key" ON "game_systems"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_version_rule_variants_ruleVariantId_gameVersionId_key" ON "game_version_rule_variants"("ruleVariantId", "gameVersionId");

-- CreateIndex
CREATE UNIQUE INDEX "game_weights_gameId_key" ON "game_weights"("gameId");

-- CreateIndex
CREATE UNIQUE INDEX "game_weight_votes_gameWeightId_userId_key" ON "game_weight_votes"("gameWeightId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "game_collections_userId_gameId_key" ON "game_collections"("userId", "gameId");

-- CreateIndex
CREATE UNIQUE INDEX "group_permissions_groupId_permission_resourceType_resourceI_key" ON "group_permissions"("groupId", "permission", "resourceType", "resourceId");

-- CreateIndex
CREATE UNIQUE INDEX "permission_groups_name_key" ON "permission_groups"("name");

-- CreateIndex
CREATE UNIQUE INDEX "group_members_groupId_userId_key" ON "group_members"("groupId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "household_games_householdId_gameId_key" ON "household_games"("householdId", "gameId");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_customizations_householdId_gameId_key" ON "household_game_customizations"("householdId", "gameId");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_experience_participants_experienceId_memberI_key" ON "household_game_experience_participants"("experienceId", "memberId");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_interests_householdGameId_householdMemberId_key" ON "household_game_interests"("householdGameId", "householdMemberId");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_customization_permissions_customizationId_us_key" ON "household_game_customization_permissions"("customizationId", "userId", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "household_roles_householdId_userId_roleId_key" ON "household_roles"("householdId", "userId", "roleId");

-- CreateIndex
CREATE UNIQUE INDEX "household_members_householdId_userId_key" ON "household_members"("householdId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "languages_abbreviation_key" ON "languages"("abbreviation");

-- CreateIndex
CREATE UNIQUE INDEX "languages_code_key" ON "languages"("code");

-- CreateIndex
CREATE UNIQUE INDEX "languages_name_key" ON "languages"("name");

-- CreateIndex
CREATE UNIQUE INDEX "mechanics_name_key" ON "mechanics"("name");

-- CreateIndex
CREATE INDEX "mechanic_relationships_primaryMechanicId_idx" ON "mechanic_relationships"("primaryMechanicId");

-- CreateIndex
CREATE INDEX "mechanic_relationships_relatedMechanicId_idx" ON "mechanic_relationships"("relatedMechanicId");

-- CreateIndex
CREATE UNIQUE INDEX "mechanic_relationships_primaryMechanicId_relatedMechanicId__key" ON "mechanic_relationships"("primaryMechanicId", "relatedMechanicId", "relationshipType");

-- CreateIndex
CREATE UNIQUE INDEX "game_mechanics_gameId_mechanicId_key" ON "game_mechanics"("gameId", "mechanicId");

-- CreateIndex
CREATE UNIQUE INDEX "permission_policies_name_key" ON "permission_policies"("name");

-- CreateIndex
CREATE UNIQUE INDEX "role_policy_assignments_roleId_policyId_key" ON "role_policy_assignments"("roleId", "policyId");

-- CreateIndex
CREATE UNIQUE INDEX "user_policy_assignments_userId_policyId_key" ON "user_policy_assignments"("userId", "policyId");

-- CreateIndex
CREATE UNIQUE INDEX "group_policy_assignments_groupId_policyId_key" ON "group_policy_assignments"("groupId", "policyId");

-- CreateIndex
CREATE UNIQUE INDEX "resource_policy_assignments_policyId_resourceType_resourceI_key" ON "resource_policy_assignments"("policyId", "resourceType", "resourceId", "appliesToId");

-- CreateIndex
CREATE UNIQUE INDEX "publishers_name_key" ON "publishers"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_publishers_gameId_publisherId_key" ON "game_publishers"("gameId", "publisherId");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "role_permissions_roleId_permission_key" ON "role_permissions"("roleId", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variants_previousVersionId_key" ON "rule_variants"("previousVersionId");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variant_usages_ruleVariantId_sessionId_key" ON "rule_variant_usages"("ruleVariantId", "sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variant_usage_versions_ruleVariantUsageId_gameVersionI_key" ON "rule_variant_usage_versions"("ruleVariantUsageId", "gameVersionId");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variant_usage_expansions_ruleVariantUsageId_gameExpans_key" ON "rule_variant_usage_expansions"("ruleVariantUsageId", "gameExpansionId");

-- CreateIndex
CREATE UNIQUE INDEX "tags_name_key" ON "tags"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_tags_gameId_tagId_key" ON "game_tags"("gameId", "tagId");

-- CreateIndex
CREATE UNIQUE INDEX "tokens_token_key" ON "tokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_preferences_userId_key" ON "user_preferences"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_userId_roleId_key" ON "user_roles"("userId", "roleId");

-- CreateIndex
CREATE UNIQUE INDEX "user_permissions_userId_permission_resourceType_resourceId_key" ON "user_permissions"("userId", "permission", "resourceType", "resourceId");

-- CreateIndex
CREATE UNIQUE INDEX "user_devices_userId_deviceIdentifier_key" ON "user_devices"("userId", "deviceIdentifier");

-- CreateIndex
CREATE UNIQUE INDEX "user_game_customizations_userId_gameId_key" ON "user_game_customizations"("userId", "gameId");

-- CreateIndex
CREATE UNIQUE INDEX "user_game_customization_permissions_customizationId_userId__key" ON "user_game_customization_permissions"("customizationId", "userId", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "user_achievements_userId_achievementId_key" ON "user_achievements"("userId", "achievementId");

-- CreateIndex
CREATE INDEX "_DesignerCollaborationToGame_B_index" ON "_DesignerCollaborationToGame"("B");

-- AddForeignKey
ALTER TABLE "game_artists" ADD CONSTRAINT "game_artists_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_artists" ADD CONSTRAINT "game_artists_artistId_fkey" FOREIGN KEY ("artistId") REFERENCES "artists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_external_identities" ADD CONSTRAINT "user_external_identities_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_external_identities" ADD CONSTRAINT "user_external_identities_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "identity_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "oidc_auth_sessions" ADD CONSTRAINT "oidc_auth_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "oidc_auth_sessions" ADD CONSTRAINT "oidc_auth_sessions_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "identity_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_gameMasterId_fkey" FOREIGN KEY ("gameMasterId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_gameSystemId_fkey" FOREIGN KEY ("gameSystemId") REFERENCES "game_systems"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_characters" ADD CONSTRAINT "campaign_characters_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_characters" ADD CONSTRAINT "campaign_characters_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_locations" ADD CONSTRAINT "campaign_locations_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_locations" ADD CONSTRAINT "campaign_locations_parentLocationId_fkey" FOREIGN KEY ("parentLocationId") REFERENCES "campaign_locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_npcs" ADD CONSTRAINT "campaign_npcs_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_npc_appearances" ADD CONSTRAINT "campaign_npc_appearances_npcId_fkey" FOREIGN KEY ("npcId") REFERENCES "campaign_npcs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_npc_appearances" ADD CONSTRAINT "campaign_npc_appearances_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_sessions" ADD CONSTRAINT "character_sessions_characterId_fkey" FOREIGN KEY ("characterId") REFERENCES "campaign_characters"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_sessions" ADD CONSTRAINT "character_sessions_gamePlaySessionId_fkey" FOREIGN KEY ("gamePlaySessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_member_permissions" ADD CONSTRAINT "campaign_member_permissions_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_member_permissions" ADD CONSTRAINT "campaign_member_permissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_member_permissions" ADD CONSTRAINT "campaign_member_permissions_grantedById_fkey" FOREIGN KEY ("grantedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_session_outcomes" ADD CONSTRAINT "campaign_session_outcomes_gamePlaySessionId_fkey" FOREIGN KEY ("gamePlaySessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_session_outcomes" ADD CONSTRAINT "campaign_session_outcomes_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_parentCategoryId_fkey" FOREIGN KEY ("parentCategoryId") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_categories" ADD CONSTRAINT "game_categories_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_categories" ADD CONSTRAINT "game_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_designers" ADD CONSTRAINT "game_designers_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_designers" ADD CONSTRAINT "game_designers_designerId_fkey" FOREIGN KEY ("designerId") REFERENCES "designers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "designer_collaborations" ADD CONSTRAINT "designer_collaborations_primaryDesignerId_fkey" FOREIGN KEY ("primaryDesignerId") REFERENCES "designers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "designer_collaborations" ADD CONSTRAINT "designer_collaborations_collaboratorId_fkey" FOREIGN KEY ("collaboratorId") REFERENCES "designers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_attendees" ADD CONSTRAINT "event_attendees_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_attendees" ADD CONSTRAINT "event_attendees_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_attendees" ADD CONSTRAINT "event_attendees_invitedById_fkey" FOREIGN KEY ("invitedById") REFERENCES "event_attendees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_game_votes" ADD CONSTRAINT "event_game_votes_eventGameId_fkey" FOREIGN KEY ("eventGameId") REFERENCES "event_games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_game_votes" ADD CONSTRAINT "event_game_votes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_game_votes" ADD CONSTRAINT "event_game_votes_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_games" ADD CONSTRAINT "event_games_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_games" ADD CONSTRAINT "event_games_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_games" ADD CONSTRAINT "event_games_suggestedById_fkey" FOREIGN KEY ("suggestedById") REFERENCES "event_attendees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_member_permissions" ADD CONSTRAINT "event_member_permissions_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_member_permissions" ADD CONSTRAINT "event_member_permissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_member_permissions" ADD CONSTRAINT "event_member_permissions_grantedById_fkey" FOREIGN KEY ("grantedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "excluded_games" ADD CONSTRAINT "excluded_games_householdMemberId_fkey" FOREIGN KEY ("householdMemberId") REFERENCES "household_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "excluded_games" ADD CONSTRAINT "excluded_games_gameCollectionId_fkey" FOREIGN KEY ("gameCollectionId") REFERENCES "game_collections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "families" ADD CONSTRAINT "families_publisherId_fkey" FOREIGN KEY ("publisherId") REFERENCES "publishers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "families" ADD CONSTRAINT "families_parentFamilyId_fkey" FOREIGN KEY ("parentFamilyId") REFERENCES "families"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_families" ADD CONSTRAINT "game_families_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_families" ADD CONSTRAINT "game_families_familyId_fkey" FOREIGN KEY ("familyId") REFERENCES "families"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_collections" ADD CONSTRAINT "family_collections_familyId_fkey" FOREIGN KEY ("familyId") REFERENCES "families"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_collections" ADD CONSTRAINT "family_collections_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendships" ADD CONSTRAINT "friendships_requestorId_fkey" FOREIGN KEY ("requestorId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendships" ADD CONSTRAINT "friendships_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_household_access" ADD CONSTRAINT "game_household_access_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_household_access" ADD CONSTRAINT "game_household_access_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_household_access" ADD CONSTRAINT "game_household_access_sharedById_fkey" FOREIGN KEY ("sharedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_user_access" ADD CONSTRAINT "game_user_access_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_user_access" ADD CONSTRAINT "game_user_access_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_user_access" ADD CONSTRAINT "game_user_access_sharedById_fkey" FOREIGN KEY ("sharedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_expansions" ADD CONSTRAINT "game_expansions_baseGameId_fkey" FOREIGN KEY ("baseGameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expansion_compatibilities" ADD CONSTRAINT "expansion_compatibilities_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expansion_compatibilities" ADD CONSTRAINT "expansion_compatibilities_expansionId_fkey" FOREIGN KEY ("expansionId") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_expansion_rule_variants" ADD CONSTRAINT "game_expansion_rule_variants_ruleVariantId_fkey" FOREIGN KEY ("ruleVariantId") REFERENCES "rule_variants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_expansion_rule_variants" ADD CONSTRAINT "game_expansion_rule_variants_gameExpansionId_fkey" FOREIGN KEY ("gameExpansionId") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_implementations" ADD CONSTRAINT "game_implementations_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_implementations" ADD CONSTRAINT "game_implementations_publisherId_fkey" FOREIGN KEY ("publisherId") REFERENCES "publishers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "implementation_ratings" ADD CONSTRAINT "implementation_ratings_implementationId_fkey" FOREIGN KEY ("implementationId") REFERENCES "game_implementations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "implementation_ratings" ADD CONSTRAINT "implementation_ratings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_gameVersionId_fkey" FOREIGN KEY ("gameVersionId") REFERENCES "game_versions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_campaignLocationId_fkey" FOREIGN KEY ("campaignLocationId") REFERENCES "campaign_locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_participants" ADD CONSTRAINT "game_play_participants_gamePlaySessionId_fkey" FOREIGN KEY ("gamePlaySessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_participants" ADD CONSTRAINT "game_play_participants_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_participants" ADD CONSTRAINT "game_play_participants_campaignCharacterId_fkey" FOREIGN KEY ("campaignCharacterId") REFERENCES "campaign_characters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_results" ADD CONSTRAINT "game_play_results_gamePlaySessionId_fkey" FOREIGN KEY ("gamePlaySessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_session_expansions" ADD CONSTRAINT "game_play_session_expansions_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_session_expansions" ADD CONSTRAINT "game_play_session_expansions_expansionId_fkey" FOREIGN KEY ("expansionId") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_reviews" ADD CONSTRAINT "game_reviews_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_reviews" ADD CONSTRAINT "game_reviews_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_versions" ADD CONSTRAINT "game_versions_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_version_rule_variants" ADD CONSTRAINT "game_version_rule_variants_ruleVariantId_fkey" FOREIGN KEY ("ruleVariantId") REFERENCES "rule_variants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_version_rule_variants" ADD CONSTRAINT "game_version_rule_variants_gameVersionId_fkey" FOREIGN KEY ("gameVersionId") REFERENCES "game_versions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_weights" ADD CONSTRAINT "game_weights_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_weight_votes" ADD CONSTRAINT "game_weight_votes_gameWeightId_fkey" FOREIGN KEY ("gameWeightId") REFERENCES "game_weights"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_weight_votes" ADD CONSTRAINT "game_weight_votes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "games" ADD CONSTRAINT "games_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_collections" ADD CONSTRAINT "game_collections_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_collections" ADD CONSTRAINT "game_collections_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_media" ADD CONSTRAINT "game_media_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_media" ADD CONSTRAINT "game_media_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loaned_games" ADD CONSTRAINT "loaned_games_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loaned_games" ADD CONSTRAINT "loaned_games_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loaned_games" ADD CONSTRAINT "loaned_games_loanToUserId_fkey" FOREIGN KEY ("loanToUserId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_permissions" ADD CONSTRAINT "group_permissions_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "permission_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "permission_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_championedById_fkey" FOREIGN KEY ("championedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_maintainedById_fkey" FOREIGN KEY ("maintainedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customizations" ADD CONSTRAINT "household_game_customizations_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customizations" ADD CONSTRAINT "household_game_customizations_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customizations" ADD CONSTRAINT "household_game_customizations_customizedById_fkey" FOREIGN KEY ("customizedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experiences" ADD CONSTRAINT "household_game_experiences_householdGameId_fkey" FOREIGN KEY ("householdGameId") REFERENCES "household_games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experiences" ADD CONSTRAINT "household_game_experiences_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experience_participants" ADD CONSTRAINT "household_game_experience_participants_experienceId_fkey" FOREIGN KEY ("experienceId") REFERENCES "household_game_experiences"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experience_participants" ADD CONSTRAINT "household_game_experience_participants_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "household_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_interests" ADD CONSTRAINT "household_game_interests_householdGameId_fkey" FOREIGN KEY ("householdGameId") REFERENCES "household_games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_interests" ADD CONSTRAINT "household_game_interests_householdMemberId_fkey" FOREIGN KEY ("householdMemberId") REFERENCES "household_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customization_permissions" ADD CONSTRAINT "household_game_customization_permissions_customizationId_fkey" FOREIGN KEY ("customizationId") REFERENCES "household_game_customizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customization_permissions" ADD CONSTRAINT "household_game_customization_permissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customization_permissions" ADD CONSTRAINT "household_game_customization_permissions_grantedById_fkey" FOREIGN KEY ("grantedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "households" ADD CONSTRAINT "households_languageId_fkey" FOREIGN KEY ("languageId") REFERENCES "languages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "households" ADD CONSTRAINT "households_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_roles" ADD CONSTRAINT "household_roles_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_roles" ADD CONSTRAINT "household_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_roles" ADD CONSTRAINT "household_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_members" ADD CONSTRAINT "household_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_members" ADD CONSTRAINT "household_members_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_invites" ADD CONSTRAINT "event_invites_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_invites" ADD CONSTRAINT "event_invites_invitedUserId_fkey" FOREIGN KEY ("invitedUserId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_invites" ADD CONSTRAINT "event_invites_invitedById_fkey" FOREIGN KEY ("invitedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mechanic_relationships" ADD CONSTRAINT "mechanic_relationships_primaryMechanicId_fkey" FOREIGN KEY ("primaryMechanicId") REFERENCES "mechanics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mechanic_relationships" ADD CONSTRAINT "mechanic_relationships_relatedMechanicId_fkey" FOREIGN KEY ("relatedMechanicId") REFERENCES "mechanics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mechanic_relationships" ADD CONSTRAINT "mechanic_relationships_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_mechanics" ADD CONSTRAINT "game_mechanics_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_mechanics" ADD CONSTRAINT "game_mechanics_mechanicId_fkey" FOREIGN KEY ("mechanicId") REFERENCES "mechanics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session_media" ADD CONSTRAINT "session_media_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session_media" ADD CONSTRAINT "session_media_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "permission_policies" ADD CONSTRAINT "permission_policies_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_policy_assignments" ADD CONSTRAINT "role_policy_assignments_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_policy_assignments" ADD CONSTRAINT "role_policy_assignments_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_policy_assignments" ADD CONSTRAINT "user_policy_assignments_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_policy_assignments" ADD CONSTRAINT "user_policy_assignments_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_policy_assignments" ADD CONSTRAINT "group_policy_assignments_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "permission_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_policy_assignments" ADD CONSTRAINT "group_policy_assignments_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resource_policy_assignments" ADD CONSTRAINT "resource_policy_assignments_policyId_fkey" FOREIGN KEY ("policyId") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resource_policy_assignments" ADD CONSTRAINT "resource_policy_assignments_appliesToId_fkey" FOREIGN KEY ("appliesToId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publishers" ADD CONSTRAINT "publishers_parentCompanyId_fkey" FOREIGN KEY ("parentCompanyId") REFERENCES "publishers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_publishers" ADD CONSTRAINT "game_publishers_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_publishers" ADD CONSTRAINT "game_publishers_publisherId_fkey" FOREIGN KEY ("publisherId") REFERENCES "publishers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "households"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_previousVersionId_fkey" FOREIGN KEY ("previousVersionId") REFERENCES "rule_variants"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usages" ADD CONSTRAINT "rule_variant_usages_ruleVariantId_fkey" FOREIGN KEY ("ruleVariantId") REFERENCES "rule_variants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usages" ADD CONSTRAINT "rule_variant_usages_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_versions" ADD CONSTRAINT "rule_variant_usage_versions_ruleVariantUsageId_fkey" FOREIGN KEY ("ruleVariantUsageId") REFERENCES "rule_variant_usages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_versions" ADD CONSTRAINT "rule_variant_usage_versions_gameVersionId_fkey" FOREIGN KEY ("gameVersionId") REFERENCES "game_versions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_expansions" ADD CONSTRAINT "rule_variant_usage_expansions_ruleVariantUsageId_fkey" FOREIGN KEY ("ruleVariantUsageId") REFERENCES "rule_variant_usages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_expansions" ADD CONSTRAINT "rule_variant_usage_expansions_gameExpansionId_fkey" FOREIGN KEY ("gameExpansionId") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_tags" ADD CONSTRAINT "game_tags_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_tags" ADD CONSTRAINT "game_tags_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "tags"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_tags" ADD CONSTRAINT "game_tags_addedById_fkey" FOREIGN KEY ("addedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tokens" ADD CONSTRAINT "tokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_languageId_fkey" FOREIGN KEY ("languageId") REFERENCES "languages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permissions" ADD CONSTRAINT "user_permissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permissions" ADD CONSTRAINT "user_permissions_grantedById_fkey" FOREIGN KEY ("grantedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_login_histories" ADD CONSTRAINT "user_login_histories_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_devices" ADD CONSTRAINT "user_devices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customizations" ADD CONSTRAINT "user_game_customizations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customizations" ADD CONSTRAINT "user_game_customizations_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customization_permissions" ADD CONSTRAINT "user_game_customization_permissions_customizationId_fkey" FOREIGN KEY ("customizationId") REFERENCES "user_game_customizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customization_permissions" ADD CONSTRAINT "user_game_customization_permissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customization_permissions" ADD CONSTRAINT "user_game_customization_permissions_grantedById_fkey" FOREIGN KEY ("grantedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_achievements" ADD CONSTRAINT "user_achievements_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_achievements" ADD CONSTRAINT "user_achievements_achievementId_fkey" FOREIGN KEY ("achievementId") REFERENCES "achievements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wish_lists" ADD CONSTRAINT "wish_lists_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wish_list_games" ADD CONSTRAINT "wish_list_games_wishListId_fkey" FOREIGN KEY ("wishListId") REFERENCES "wish_lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wish_list_games" ADD CONSTRAINT "wish_list_games_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DesignerCollaborationToGame" ADD CONSTRAINT "_DesignerCollaborationToGame_A_fkey" FOREIGN KEY ("A") REFERENCES "designer_collaborations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DesignerCollaborationToGame" ADD CONSTRAINT "_DesignerCollaborationToGame_B_fkey" FOREIGN KEY ("B") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;
