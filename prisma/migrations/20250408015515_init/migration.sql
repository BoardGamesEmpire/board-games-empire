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
CREATE TYPE "notification_types" AS ENUM ('EventInvite', 'EventReminder', 'GameCollectionUpdate', 'GameReturnReminder', 'GameReview', 'General', 'HouseholdInvite', 'System', 'UserMention', 'UserTag', 'ListItem');

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
CREATE TYPE "token_types" AS ENUM ('Access', 'Refresh', 'EmailVerification', 'PasswordReset', 'SessionReference');

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
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "achievements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "artists" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "full_name" TEXT,
    "website" TEXT,
    "biography" TEXT,
    "country" TEXT,
    "social_media" JSONB,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "artists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_artists" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,
    "game_id" TEXT NOT NULL,
    "artist_id" TEXT NOT NULL,
    "role" "artist_roles" NOT NULL DEFAULT 'Primary',
    "details" TEXT,

    CONSTRAINT "game_artists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "identity_providers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "client_id" TEXT NOT NULL,
    "client_secret" TEXT NOT NULL,
    "discovery_url" TEXT,
    "authorization_url" TEXT,
    "token_url" TEXT,
    "user_info_url" TEXT,
    "jwks_url" TEXT,
    "scopes" TEXT[] DEFAULT ARRAY['openid', 'email', 'profile', 'offline_access']::TEXT[],
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "identity_providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_external_identities" (
    "id" TEXT NOT NULL,
    "authentication_id" TEXT NOT NULL,
    "provider_id" TEXT NOT NULL,
    "external_id" TEXT NOT NULL,
    "email" TEXT,
    "raw_profile" JSONB,
    "access_token" TEXT,
    "refresh_token" TEXT,
    "token_expires_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_external_identities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "oidc_auth_sessions" (
    "id" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "nonce" TEXT,
    "code_verifier" TEXT,
    "redirect_uri" TEXT NOT NULL,
    "authentication_id" TEXT,
    "provider_id" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "oidc_auth_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" TEXT NOT NULL,
    "authentication_id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "device_info" JSONB,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "last_active" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "is_valid" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_authentications" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "auth_strategy" "auth_strategies" NOT NULL DEFAULT 'Local',
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "last_password_change" TIMESTAMPTZ(3),
    "account_locked" BOOLEAN NOT NULL DEFAULT false,
    "account_locked_until" TIMESTAMPTZ(3),
    "failed_login_attempts" INTEGER NOT NULL DEFAULT 0,
    "last_failed_login" TIMESTAMPTZ(3),
    "last_login" TIMESTAMPTZ(3),
    "two_factor_enabled" BOOLEAN NOT NULL DEFAULT false,
    "two_factor_secret" TEXT,
    "recovery_codes_hash" TEXT,
    "is_external_user" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_authentications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaigns" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "image" TEXT,
    "game_id" TEXT NOT NULL,
    "status" "campaign_statuses" NOT NULL DEFAULT 'Active',
    "start_date" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_date" TIMESTAMPTZ(3),
    "household_id" TEXT NOT NULL,
    "game_master_id" TEXT NOT NULL,
    "current_level" INTEGER,
    "current_chapter" TEXT,
    "campaign_notes" TEXT,
    "game_system_id" TEXT,
    "use_custom_rules" BOOLEAN NOT NULL DEFAULT false,
    "custom_rules" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_characters" (
    "id" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "player_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "class" TEXT,
    "race" TEXT,
    "level" INTEGER,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "experience" INTEGER,
    "attributes" JSONB,
    "inventory" JSONB,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "campaign_characters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_locations" (
    "id" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "location_type" TEXT,
    "is_secret" BOOLEAN NOT NULL DEFAULT false,
    "map_image" TEXT,
    "notes" TEXT,
    "parent_location_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "campaign_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_npcs" (
    "id" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "role" TEXT,
    "is_secret" BOOLEAN NOT NULL DEFAULT false,
    "is_recurring" BOOLEAN NOT NULL DEFAULT false,
    "stats" JSONB,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "campaign_npcs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_npc_appearances" (
    "id" TEXT NOT NULL,
    "npc_id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "role" TEXT,
    "was_encountered" BOOLEAN NOT NULL DEFAULT true,
    "was_significant" BOOLEAN NOT NULL DEFAULT false,
    "significant_event" TEXT,
    "notes" TEXT,

    CONSTRAINT "campaign_npc_appearances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "character_sessions" (
    "id" TEXT NOT NULL,
    "character_id" TEXT NOT NULL,
    "game_play_session_id" TEXT NOT NULL,
    "level_during_session" INTEGER,
    "experience_gained" INTEGER,
    "notes_during_session" TEXT,

    CONSTRAINT "character_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_member_permissions" (
    "id" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "granted_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "campaign_member_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaign_session_outcomes" (
    "id" TEXT NOT NULL,
    "game_play_session_id" TEXT NOT NULL,
    "campaign_id" TEXT NOT NULL,
    "story_summary" TEXT,
    "key_decisions" JSONB,
    "world_changes" JSONB,
    "npc_changes" JSONB,
    "treasure_found" JSONB,
    "experience_awarded" INTEGER,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "campaign_session_outcomes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "parent_category_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_categories" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "category_id" TEXT NOT NULL,
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "designers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "full_name" TEXT,
    "website" TEXT,
    "biography" TEXT,
    "country" TEXT,
    "board_game_geek_url" TEXT,
    "debut_year" INTEGER,
    "total_collaborators" INTEGER,
    "most_frequent_collaborator_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "designers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_designers" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "designer_id" TEXT NOT NULL,
    "role" "designer_roles" NOT NULL DEFAULT 'Primary',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_designers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "designer_collaborations" (
    "id" TEXT NOT NULL,
    "primary_designer_id" TEXT NOT NULL,
    "collaborator_id" TEXT NOT NULL,
    "collaboration_count" INTEGER NOT NULL DEFAULT 1,
    "first_collaboration" INTEGER,
    "latest_collaboration" INTEGER,
    "strength" DOUBLE PRECISION,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "designer_collaborations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_designer_collaborations" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "designer_collaboration_id" TEXT NOT NULL,
    "notes" TEXT,
    "contribution_type" TEXT,
    "year" INTEGER,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_designer_collaborations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" TEXT NOT NULL,
    "household_id" TEXT NOT NULL,
    "created_by_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "image" TEXT,
    "description" TEXT,
    "location" TEXT,
    "url" TEXT,
    "visibility" "visibility_types" NOT NULL DEFAULT 'Friends',
    "allow_guest_invites" BOOLEAN NOT NULL DEFAULT true,
    "max_total_participants" INTEGER,
    "strict_capacity" BOOLEAN NOT NULL DEFAULT false,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_attendees" (
    "id" TEXT NOT NULL,
    "event_id" TEXT NOT NULL,
    "attendee_type" "attendee_types" NOT NULL DEFAULT 'Participant',
    "user_id" TEXT,
    "guest_name" TEXT,
    "guest_email" TEXT,
    "status" "event_participation_statuses" NOT NULL DEFAULT 'Invited',
    "role" "event_participant_roles" NOT NULL DEFAULT 'Participant',
    "invited_by_id" TEXT,
    "notes" TEXT,
    "rsvp_date" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "event_attendees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_game_votes" (
    "id" TEXT NOT NULL,
    "event_game_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "event_id" TEXT,

    CONSTRAINT "event_game_votes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_games" (
    "id" TEXT NOT NULL,
    "event_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "suggested_by_id" TEXT NOT NULL,

    CONSTRAINT "event_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_member_permissions" (
    "id" TEXT NOT NULL,
    "event_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "granted_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "event_member_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "excluded_games" (
    "id" TEXT NOT NULL,
    "household_member_id" TEXT NOT NULL,
    "game_collection_id" TEXT NOT NULL,
    "excluded_reason" TEXT,
    "excluded_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "excluded_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "families" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "publisher_id" TEXT,
    "logo_url" TEXT,
    "website" TEXT,
    "family_type" "family_types" NOT NULL DEFAULT 'Series',
    "parent_family_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "families_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_families" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "family_id" TEXT NOT NULL,
    "position" INTEGER,
    "release_order" INTEGER,
    "story_order" INTEGER,
    "is_standalone" BOOLEAN NOT NULL DEFAULT true,
    "required_game_ids" TEXT[],
    "note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_families_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "family_collections" (
    "id" TEXT NOT NULL,
    "family_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "is_complete" BOOLEAN NOT NULL DEFAULT false,
    "missing_count" INTEGER,
    "collected_on" TIMESTAMPTZ(3),
    "notify_on_new_releases" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "family_collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "friendships" (
    "id" TEXT NOT NULL,
    "requestor_id" TEXT NOT NULL,
    "recipient_id" TEXT NOT NULL,
    "status" "friendship_statuses" NOT NULL DEFAULT 'Pending',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "friendships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_household_access" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "household_id" TEXT NOT NULL,
    "can_edit" BOOLEAN NOT NULL DEFAULT false,
    "can_share" BOOLEAN NOT NULL DEFAULT false,
    "shared_by_id" TEXT NOT NULL,
    "shared_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_household_access_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_user_access" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "can_edit" BOOLEAN NOT NULL DEFAULT false,
    "can_share" BOOLEAN NOT NULL DEFAULT false,
    "shared_by_id" TEXT NOT NULL,
    "shared_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_user_access_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_expansions" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "base_game_id" TEXT NOT NULL,
    "description" TEXT,
    "release_year" INTEGER,
    "is_standalone" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_expansions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expansion_compatibilities" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "expansion_id" TEXT NOT NULL,
    "is_recommended" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "expansion_compatibilities_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_expansion_rule_variants" (
    "id" TEXT NOT NULL,
    "rule_variant_id" TEXT NOT NULL,
    "game_expansion_id" TEXT NOT NULL,
    "override_category" "rule_categories",
    "override_rule_text" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_expansion_rule_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_implementations" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "platform" "game_platforms" NOT NULL,
    "title" TEXT,
    "url" TEXT,
    "publisher_id" TEXT,
    "release_date" TIMESTAMPTZ(3),
    "version" TEXT,
    "last_updated" TIMESTAMPTZ(3),
    "pricing_model" "pricing_models",
    "base_price" DOUBLE PRECISION,
    "has_purchases" BOOLEAN NOT NULL DEFAULT false,
    "is_subscription" BOOLEAN NOT NULL DEFAULT false,
    "supports_solo" BOOLEAN NOT NULL DEFAULT false,
    "supports_local" BOOLEAN NOT NULL DEFAULT false,
    "supports_online" BOOLEAN NOT NULL DEFAULT false,
    "has_async_play" BOOLEAN NOT NULL DEFAULT false,
    "has_realtime" BOOLEAN NOT NULL DEFAULT false,
    "has_tutorial" BOOLEAN NOT NULL DEFAULT false,
    "app_store_id" TEXT,
    "google_play_id" TEXT,
    "steam_app_id" TEXT,
    "board_game_arena_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_implementations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "implementation_ratings" (
    "id" TEXT NOT NULL,
    "implementation_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "rating" DOUBLE PRECISION NOT NULL,
    "review" TEXT,
    "usability_rating" DOUBLE PRECISION,
    "feature_rating" DOUBLE PRECISION,
    "ai_rating" DOUBLE PRECISION,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "implementation_ratings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_sessions" (
    "id" TEXT NOT NULL,
    "event_id" TEXT,
    "game_id" TEXT NOT NULL,
    "campaign_id" TEXT,
    "game_version_id" TEXT,
    "session_number" INTEGER,
    "chapter" TEXT,
    "milestone" TEXT,
    "campaign_location_id" TEXT,
    "play_date" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "duration" INTEGER,
    "location" TEXT,
    "context" "game_play_contexts" NOT NULL DEFAULT 'Casual',
    "household_id" TEXT,
    "venue" TEXT,
    "is_complete" BOOLEAN NOT NULL DEFAULT false,
    "was_interrupted" BOOLEAN NOT NULL DEFAULT false,
    "playtime" INTEGER,
    "turns" INTEGER,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_play_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_participants" (
    "id" TEXT NOT NULL,
    "game_play_session_id" TEXT NOT NULL,
    "user_id" TEXT,
    "guest_name" TEXT,
    "campaign_character_id" TEXT,
    "player_position" INTEGER,
    "team" TEXT,
    "final_score" DOUBLE PRECISION,
    "placement" INTEGER,
    "winner" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "game_play_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_results" (
    "id" TEXT NOT NULL,
    "game_play_session_id" TEXT NOT NULL,
    "result_type" "result_types" NOT NULL DEFAULT 'Score',
    "scoring_phase" TEXT,
    "score_details" JSONB,
    "team_scores" JSONB,
    "individual_metrics" JSONB,

    CONSTRAINT "game_play_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_play_session_expansions" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "expansion_id" TEXT NOT NULL,

    CONSTRAINT "game_play_session_expansions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_reviews" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "rating" DOUBLE PRECISION NOT NULL,
    "visibility" "visibility_types" NOT NULL DEFAULT 'Household',
    "comment" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_systems" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "publisher" TEXT,
    "version" TEXT,
    "description" TEXT,
    "attribute_schema" JSONB,
    "class_options" JSONB,
    "race_options" JSONB,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_systems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_versions" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "version_name" TEXT NOT NULL,
    "release_year" INTEGER,
    "is_baseline" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_version_rule_variants" (
    "id" TEXT NOT NULL,
    "rule_variant_id" TEXT NOT NULL,
    "game_version_id" TEXT NOT NULL,
    "override_category" "rule_categories",
    "override_rule_text" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_version_rule_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_weights" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "overall_weight" DOUBLE PRECISION,
    "rules_weight" DOUBLE PRECISION,
    "strategy_weight" DOUBLE PRECISION,
    "luck_weight" DOUBLE PRECISION,
    "math_weight" DOUBLE PRECISION,
    "social_weight" DOUBLE PRECISION,
    "teaching_time" INTEGER,
    "learning_curve" "learning_curves",
    "weight_source" "weight_sources" NOT NULL DEFAULT 'Internal',
    "external_url" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_weights_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_weight_votes" (
    "id" TEXT NOT NULL,
    "game_weight_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "overall_weight" DOUBLE PRECISION,
    "rules_weight" DOUBLE PRECISION,
    "strategy_weight" DOUBLE PRECISION,
    "luck_weight" DOUBLE PRECISION,
    "math_weight" DOUBLE PRECISION,
    "social_weight" DOUBLE PRECISION,
    "comments" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_weight_votes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "games" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "description" TEXT,
    "image" TEXT,
    "publish_year" INTEGER,
    "min_players" INTEGER,
    "max_players" INTEGER,
    "playing_time" INTEGER,
    "min_play_time" INTEGER,
    "min_play_time_measure" "time_measures",
    "max_play_time" INTEGER,
    "max_play_time_measure" "time_measures",
    "min_age" INTEGER,
    "total_play_count" INTEGER NOT NULL DEFAULT 0,
    "average_rating" DOUBLE PRECISION,
    "complexity" DOUBLE PRECISION,
    "owned_by_count" INTEGER NOT NULL DEFAULT 0,
    "is_private" BOOLEAN NOT NULL DEFAULT false,
    "visibility" "visibility_types" NOT NULL DEFAULT 'Public',
    "created_by_id" TEXT,
    "is_from_external" BOOLEAN NOT NULL DEFAULT false,
    "external_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_collections" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 1,
    "rating" INTEGER,
    "play_count" INTEGER,
    "play_again" BOOLEAN,
    "favorite" BOOLEAN,
    "comment" TEXT,
    "last_played" TIMESTAMPTZ(3),
    "last_updated" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_collections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_media" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "media_type" "media_types" NOT NULL,
    "url" TEXT NOT NULL,
    "thumbnail_url" TEXT,
    "title" TEXT,
    "description" TEXT,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "uploaded_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "loaned_games" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "loaned_to_user_id" TEXT,
    "loaned_to" TEXT,
    "loaned_to_email" TEXT,
    "loan_date" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expected_return_date" TIMESTAMPTZ(3),
    "actual_return_date" TIMESTAMPTZ(3),
    "notes" TEXT,

    CONSTRAINT "loaned_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_permissions" (
    "id" TEXT NOT NULL,
    "group_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "resource_type" "resource_types" NOT NULL,
    "resource_id" TEXT,

    CONSTRAINT "group_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permission_groups" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "permission_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_members" (
    "id" TEXT NOT NULL,
    "group_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "group_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_games" (
    "id" TEXT NOT NULL,
    "household_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "ownership_type" "household_game_ownerships" NOT NULL DEFAULT 'MemberOwned',
    "storage_location" TEXT,
    "condition" "game_conditions",
    "missing_pieces" TEXT,
    "house_rating" DOUBLE PRECISION,
    "play_count" INTEGER NOT NULL DEFAULT 0,
    "last_played" TIMESTAMPTZ(3),
    "is_favorite" BOOLEAN NOT NULL DEFAULT false,
    "best_player_count" INTEGER,
    "is_available" BOOLEAN NOT NULL DEFAULT true,
    "unavailable_reason" TEXT,
    "championed_by_id" TEXT,
    "maintained_by_id" TEXT,
    "teacher_id" TEXT,
    "most_frequent_winner" TEXT,
    "win_history" JSONB,
    "playerDynamics" "player_dynamics"[],
    "ideal_for" "game_night_types"[],
    "learning_difficulty" "learning_difficulties",
    "teaching_notes" TEXT,
    "house_rule_count" INTEGER NOT NULL DEFAULT 0,
    "notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_customizations" (
    "id" TEXT NOT NULL,
    "household_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "title" TEXT,
    "subtitle" TEXT,
    "description" TEXT,
    "image" TEXT,
    "publish_year" INTEGER,
    "min_players" INTEGER,
    "max_players" INTEGER,
    "playing_time" INTEGER,
    "min_play_time" INTEGER,
    "max_play_time" INTEGER,
    "min_age" INTEGER,
    "complexity" DOUBLE PRECISION,
    "customized_by_id" TEXT NOT NULL,
    "customization_notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_game_customizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_experiences" (
    "id" TEXT NOT NULL,
    "household_game_id" TEXT NOT NULL,
    "date" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "photos" TEXT[],
    "tags" TEXT[],
    "created_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_game_experiences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_experience_participants" (
    "id" TEXT NOT NULL,
    "experience_id" TEXT NOT NULL,
    "member_id" TEXT NOT NULL,
    "role" TEXT,
    "had_fun" BOOLEAN,
    "notes" TEXT,
    "is_highlighted" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_game_experience_participants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_interests" (
    "id" TEXT NOT NULL,
    "household_game_id" TEXT NOT NULL,
    "household_member_id" TEXT NOT NULL,
    "interest_level" "InterestLevel" NOT NULL DEFAULT 'Neutral',
    "play_desire" "PlayDesire" NOT NULL DEFAULT 'Anytime',
    "comments" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_game_interests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_game_customization_permissions" (
    "id" TEXT NOT NULL,
    "customization_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "granted_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_game_customization_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "households" (
    "id" TEXT NOT NULL,
    "description" TEXT,
    "name" TEXT NOT NULL,
    "image" TEXT,
    "language_id" TEXT NOT NULL,
    "owner_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "households_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_roles" (
    "id" TEXT NOT NULL,
    "household_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "household_members" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "household_id" TEXT NOT NULL,
    "show_all_games" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "household_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_invites" (
    "id" TEXT NOT NULL,
    "event_id" TEXT NOT NULL,
    "invited_user_id" TEXT NOT NULL,
    "invited_by_id" TEXT NOT NULL,
    "status" "invite_statuses" NOT NULL DEFAULT 'Pending',
    "expires_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

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
CREATE TABLE "lists" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'My Wishlist',
    "user_id" TEXT NOT NULL,

    CONSTRAINT "lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_lists" (
    "id" TEXT NOT NULL,
    "list_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "game_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mechanics" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "complexity" INTEGER,
    "usage_count" INTEGER,
    "compatibility_score" DOUBLE PRECISION,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "mechanics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mechanic_relationships" (
    "id" TEXT NOT NULL,
    "primary_mechanic_id" TEXT NOT NULL,
    "related_mechanic_id" TEXT NOT NULL,
    "relationship_type" "mechanic_relationship_types" NOT NULL,
    "strength" DOUBLE PRECISION NOT NULL,
    "description" TEXT,
    "created_by_id" TEXT,
    "community_rating" DOUBLE PRECISION,
    "support_evidence" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "mechanic_relationships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_mechanics" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "game_id" TEXT NOT NULL,
    "mechanic_id" TEXT NOT NULL,

    CONSTRAINT "game_mechanics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session_media" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "caption" TEXT,
    "uploaded_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "session_media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "type" "notification_types" NOT NULL,
    "message" TEXT NOT NULL,
    "related_entity_id" TEXT,
    "is_read" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permission_policies" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "resource_type" "resource_types" NOT NULL,
    "effect" "policy_effects" NOT NULL DEFAULT 'Allow',
    "conditions" JSONB,
    "permissions" TEXT[],
    "created_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "permission_policies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_policy_assignments" (
    "id" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,
    "policy_id" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "role_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_policy_assignments" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "policy_id" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "expires_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "group_policy_assignments" (
    "id" TEXT NOT NULL,
    "group_id" TEXT NOT NULL,
    "policy_id" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "group_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "resource_policy_assignments" (
    "id" TEXT NOT NULL,
    "policy_id" TEXT NOT NULL,
    "resource_type" "resource_types" NOT NULL,
    "resource_id" TEXT NOT NULL,
    "applies_to_id" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 100,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "resource_policy_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "publishers" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "legal_name" TEXT,
    "website" TEXT,
    "country" TEXT,
    "founded_year" INTEGER,
    "parent_company_id" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "logo_url" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "publishers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_publishers" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,
    "game_id" TEXT NOT NULL,
    "publisher_id" TEXT NOT NULL,
    "role" "publisher_roles" NOT NULL DEFAULT 'Primary',
    "release_year" INTEGER,
    "region" TEXT,

    CONSTRAINT "game_publishers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "is_system" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "id" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variants" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "campaign_id" TEXT,
    "game_id" TEXT,
    "household_id" TEXT,
    "category" "rule_categories" NOT NULL DEFAULT 'General',
    "rule_type" "rule_types" NOT NULL DEFAULT 'Addition',
    "compatibility_mode" "rule_compatibility_modes" NOT NULL DEFAULT 'ExactMatch',
    "modifies_core" BOOLEAN NOT NULL DEFAULT false,
    "replaced_rule_ref" TEXT,
    "rulebook_page" INTEGER,
    "rulebook_edition" TEXT,
    "rule_text" TEXT NOT NULL,
    "examples" TEXT,
    "created_by_id" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "source" TEXT,
    "discussion_link" TEXT,
    "version" TEXT NOT NULL DEFAULT '1.0',
    "previous_version_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "rule_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variant_usages" (
    "id" TEXT NOT NULL,
    "rule_variant_id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "was_effective" BOOLEAN,
    "notes" TEXT,

    CONSTRAINT "rule_variant_usages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variant_usage_versions" (
    "id" TEXT NOT NULL,
    "rule_variant_usage_id" TEXT NOT NULL,
    "game_version_id" TEXT NOT NULL,
    "was_applicable" BOOLEAN NOT NULL DEFAULT true,
    "requires_errata" BOOLEAN NOT NULL DEFAULT false,
    "errata_details" TEXT,

    CONSTRAINT "rule_variant_usage_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rule_variant_usage_expansions" (
    "id" TEXT NOT NULL,
    "rule_variant_usage_id" TEXT NOT NULL,
    "game_expansion_id" TEXT NOT NULL,
    "was_applicable" BOOLEAN NOT NULL DEFAULT true,
    "required_modification" BOOLEAN NOT NULL DEFAULT false,
    "notes" TEXT,

    CONSTRAINT "rule_variant_usage_expansions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "system_settings" (
    "id" TEXT NOT NULL,
    "allow_password_resets" BOOLEAN NOT NULL DEFAULT true,
    "allow_user_registration" BOOLEAN NOT NULL DEFAULT true,
    "allow_username_change" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "system_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_tags" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "tag_id" TEXT NOT NULL,
    "added_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tokens" (
    "id" TEXT NOT NULL,
    "type" "token_types" NOT NULL,
    "token" VARCHAR(512) NOT NULL,
    "authentication_id" TEXT NOT NULL,
    "is_revoked" BOOLEAN NOT NULL DEFAULT false,
    "is_used" BOOLEAN NOT NULL DEFAULT false,
    "revocation_reason" VARCHAR(255),
    "metadata" JSONB,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "used_at" TIMESTAMPTZ(3),
    "revoked_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "first_name" TEXT,
    "last_name" TEXT,
    "avatar" TEXT,
    "profile_image" TEXT,
    "username" TEXT NOT NULL,
    "bio" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_preferences" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "theme" TEXT NOT NULL DEFAULT 'system',
    "accent_color" TEXT,
    "show_online_status" BOOLEAN NOT NULL DEFAULT true,
    "show_last_active" BOOLEAN NOT NULL DEFAULT true,
    "allow_friend_requests" BOOLEAN NOT NULL DEFAULT true,
    "show_collection_to_friends" BOOLEAN NOT NULL DEFAULT true,
    "show_game_play_history" BOOLEAN NOT NULL DEFAULT true,
    "email_notifications" JSONB,
    "push_notifications" JSONB,
    "preferred_player_count" INTEGER,
    "preferred_game_length" INTEGER,
    "favorite_categories" TEXT[],
    "favorite_mechanics" TEXT[],
    "disliked_categories" TEXT[],
    "disliked_mechanics" TEXT[],
    "language_id" TEXT,
    "default_review_visibility" "visibility_types" NOT NULL DEFAULT 'Private',
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_permissions" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "resource_type" "resource_types" NOT NULL,
    "resource_id" TEXT,
    "granted_by_id" TEXT NOT NULL,
    "expires_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_login_histories" (
    "id" TEXT NOT NULL,
    "authentication_id" TEXT NOT NULL,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "success" BOOLEAN NOT NULL DEFAULT true,
    "failure_reason" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_login_histories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_devices" (
    "id" TEXT NOT NULL,
    "authentication_id" TEXT NOT NULL,
    "device_name" TEXT,
    "device_identifier" TEXT NOT NULL,
    "last_used" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_trusted" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_game_customizations" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "title" TEXT,
    "subtitle" TEXT,
    "description" TEXT,
    "image" TEXT,
    "publish_year" INTEGER,
    "min_players" INTEGER,
    "max_players" INTEGER,
    "playing_time" INTEGER,
    "min_play_time" INTEGER,
    "max_play_time" INTEGER,
    "min_age" INTEGER,
    "complexity" DOUBLE PRECISION,
    "customization_notes" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_game_customizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_game_customization_permissions" (
    "id" TEXT NOT NULL,
    "customization_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "permission" "permissions" NOT NULL,
    "granted_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "user_game_customization_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_achievements" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "achievement_id" TEXT NOT NULL,
    "earned_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "progress" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "user_achievements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "game_artists_game_id_artist_id_key" ON "game_artists"("game_id", "artist_id");

-- CreateIndex
CREATE UNIQUE INDEX "identity_providers_name_key" ON "identity_providers"("name");

-- CreateIndex
CREATE UNIQUE INDEX "identity_providers_provider_key" ON "identity_providers"("provider");

-- CreateIndex
CREATE UNIQUE INDEX "user_external_identities_provider_id_external_id_key" ON "user_external_identities"("provider_id", "external_id");

-- CreateIndex
CREATE UNIQUE INDEX "oidc_auth_sessions_state_key" ON "oidc_auth_sessions"("state");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_token_key" ON "user_sessions"("token");

-- CreateIndex
CREATE INDEX "user_sessions_token_idx" ON "user_sessions"("token");

-- CreateIndex
CREATE INDEX "user_sessions_authentication_id_is_valid_idx" ON "user_sessions"("authentication_id", "is_valid");

-- CreateIndex
CREATE UNIQUE INDEX "user_authentications_user_id_key" ON "user_authentications"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_authentications_email_key" ON "user_authentications"("email");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_npc_appearances_npc_id_session_id_key" ON "campaign_npc_appearances"("npc_id", "session_id");

-- CreateIndex
CREATE UNIQUE INDEX "character_sessions_character_id_game_play_session_id_key" ON "character_sessions"("character_id", "game_play_session_id");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_member_permissions_campaign_id_user_id_permission_key" ON "campaign_member_permissions"("campaign_id", "user_id", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "campaign_session_outcomes_game_play_session_id_key" ON "campaign_session_outcomes"("game_play_session_id");

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_key" ON "categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_categories_game_id_category_id_key" ON "game_categories"("game_id", "category_id");

-- CreateIndex
CREATE UNIQUE INDEX "unique_primary_category_per_game" ON "game_categories"("game_id", "is_primary");

-- CreateIndex
CREATE UNIQUE INDEX "designers_name_key" ON "designers"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_designers_game_id_designer_id_key" ON "game_designers"("game_id", "designer_id");

-- CreateIndex
CREATE INDEX "designer_collaborations_primary_designer_id_idx" ON "designer_collaborations"("primary_designer_id");

-- CreateIndex
CREATE INDEX "designer_collaborations_collaborator_id_idx" ON "designer_collaborations"("collaborator_id");

-- CreateIndex
CREATE UNIQUE INDEX "designer_collaborations_primary_designer_id_collaborator_id_key" ON "designer_collaborations"("primary_designer_id", "collaborator_id");

-- CreateIndex
CREATE INDEX "game_designer_collaborations_game_id_idx" ON "game_designer_collaborations"("game_id");

-- CreateIndex
CREATE INDEX "game_designer_collaborations_designer_collaboration_id_idx" ON "game_designer_collaborations"("designer_collaboration_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_designer_collaborations_game_id_designer_collaboration_key" ON "game_designer_collaborations"("game_id", "designer_collaboration_id");

-- CreateIndex
CREATE UNIQUE INDEX "event_game_votes_event_game_id_user_id_key" ON "event_game_votes"("event_game_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "event_member_permissions_event_id_user_id_permission_key" ON "event_member_permissions"("event_id", "user_id", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "excluded_games_household_member_id_game_collection_id_key" ON "excluded_games"("household_member_id", "game_collection_id");

-- CreateIndex
CREATE UNIQUE INDEX "families_name_key" ON "families"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_families_game_id_family_id_key" ON "game_families"("game_id", "family_id");

-- CreateIndex
CREATE UNIQUE INDEX "family_collections_family_id_user_id_key" ON "family_collections"("family_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "friendships_requestor_id_recipient_id_key" ON "friendships"("requestor_id", "recipient_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_household_access_game_id_household_id_key" ON "game_household_access"("game_id", "household_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_user_access_game_id_user_id_key" ON "game_user_access"("game_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "expansion_compatibilities_game_id_expansion_id_key" ON "expansion_compatibilities"("game_id", "expansion_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_expansion_rule_variants_rule_variant_id_game_expansion_key" ON "game_expansion_rule_variants"("rule_variant_id", "game_expansion_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_implementations_game_id_platform_key" ON "game_implementations"("game_id", "platform");

-- CreateIndex
CREATE UNIQUE INDEX "implementation_ratings_implementation_id_user_id_key" ON "implementation_ratings"("implementation_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_play_session_expansions_session_id_expansion_id_key" ON "game_play_session_expansions"("session_id", "expansion_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_reviews_user_id_game_id_key" ON "game_reviews"("user_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_systems_name_key" ON "game_systems"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_version_rule_variants_rule_variant_id_game_version_id_key" ON "game_version_rule_variants"("rule_variant_id", "game_version_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_weights_game_id_key" ON "game_weights"("game_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_weight_votes_game_weight_id_user_id_key" ON "game_weight_votes"("game_weight_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_collections_user_id_game_id_key" ON "game_collections"("user_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "group_permissions_group_id_permission_resource_type_resourc_key" ON "group_permissions"("group_id", "permission", "resource_type", "resource_id");

-- CreateIndex
CREATE UNIQUE INDEX "permission_groups_name_key" ON "permission_groups"("name");

-- CreateIndex
CREATE UNIQUE INDEX "group_members_group_id_user_id_key" ON "group_members"("group_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "household_games_household_id_game_id_key" ON "household_games"("household_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_customizations_household_id_game_id_key" ON "household_game_customizations"("household_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_experience_participants_experience_id_member_key" ON "household_game_experience_participants"("experience_id", "member_id");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_interests_household_game_id_household_member_key" ON "household_game_interests"("household_game_id", "household_member_id");

-- CreateIndex
CREATE UNIQUE INDEX "household_game_customization_permissions_customization_id_u_key" ON "household_game_customization_permissions"("customization_id", "user_id", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "household_roles_household_id_user_id_role_id_key" ON "household_roles"("household_id", "user_id", "role_id");

-- CreateIndex
CREATE UNIQUE INDEX "household_members_household_id_user_id_key" ON "household_members"("household_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "languages_abbreviation_key" ON "languages"("abbreviation");

-- CreateIndex
CREATE UNIQUE INDEX "languages_code_key" ON "languages"("code");

-- CreateIndex
CREATE UNIQUE INDEX "languages_name_key" ON "languages"("name");

-- CreateIndex
CREATE UNIQUE INDEX "mechanics_name_key" ON "mechanics"("name");

-- CreateIndex
CREATE INDEX "mechanic_relationships_primary_mechanic_id_idx" ON "mechanic_relationships"("primary_mechanic_id");

-- CreateIndex
CREATE INDEX "mechanic_relationships_related_mechanic_id_idx" ON "mechanic_relationships"("related_mechanic_id");

-- CreateIndex
CREATE UNIQUE INDEX "mechanic_relationships_primary_mechanic_id_related_mechanic_key" ON "mechanic_relationships"("primary_mechanic_id", "related_mechanic_id", "relationship_type");

-- CreateIndex
CREATE UNIQUE INDEX "game_mechanics_game_id_mechanic_id_key" ON "game_mechanics"("game_id", "mechanic_id");

-- CreateIndex
CREATE UNIQUE INDEX "permission_policies_name_key" ON "permission_policies"("name");

-- CreateIndex
CREATE UNIQUE INDEX "role_policy_assignments_role_id_policy_id_key" ON "role_policy_assignments"("role_id", "policy_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_policy_assignments_user_id_policy_id_key" ON "user_policy_assignments"("user_id", "policy_id");

-- CreateIndex
CREATE UNIQUE INDEX "group_policy_assignments_group_id_policy_id_key" ON "group_policy_assignments"("group_id", "policy_id");

-- CreateIndex
CREATE UNIQUE INDEX "resource_policy_assignments_policy_id_resource_type_resourc_key" ON "resource_policy_assignments"("policy_id", "resource_type", "resource_id", "applies_to_id");

-- CreateIndex
CREATE UNIQUE INDEX "publishers_name_key" ON "publishers"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_publishers_game_id_publisher_id_key" ON "game_publishers"("game_id", "publisher_id");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "role_permissions_role_id_permission_key" ON "role_permissions"("role_id", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variants_previous_version_id_key" ON "rule_variants"("previous_version_id");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variant_usages_rule_variant_id_session_id_key" ON "rule_variant_usages"("rule_variant_id", "session_id");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variant_usage_versions_rule_variant_usage_id_game_vers_key" ON "rule_variant_usage_versions"("rule_variant_usage_id", "game_version_id");

-- CreateIndex
CREATE UNIQUE INDEX "rule_variant_usage_expansions_rule_variant_usage_id_game_ex_key" ON "rule_variant_usage_expansions"("rule_variant_usage_id", "game_expansion_id");

-- CreateIndex
CREATE UNIQUE INDEX "tags_name_key" ON "tags"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_tags_game_id_tag_id_key" ON "game_tags"("game_id", "tag_id");

-- CreateIndex
CREATE UNIQUE INDEX "tokens_token_key" ON "tokens"("token");

-- CreateIndex
CREATE UNIQUE INDEX "users_username_key" ON "users"("username");

-- CreateIndex
CREATE UNIQUE INDEX "user_preferences_user_id_key" ON "user_preferences"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_user_id_role_id_key" ON "user_roles"("user_id", "role_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_permissions_user_id_permission_resource_type_resource__key" ON "user_permissions"("user_id", "permission", "resource_type", "resource_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_devices_authentication_id_device_identifier_key" ON "user_devices"("authentication_id", "device_identifier");

-- CreateIndex
CREATE UNIQUE INDEX "user_game_customizations_user_id_game_id_key" ON "user_game_customizations"("user_id", "game_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_game_customization_permissions_customization_id_user_i_key" ON "user_game_customization_permissions"("customization_id", "user_id", "permission");

-- CreateIndex
CREATE UNIQUE INDEX "user_achievements_user_id_achievement_id_key" ON "user_achievements"("user_id", "achievement_id");

-- AddForeignKey
ALTER TABLE "game_artists" ADD CONSTRAINT "game_artists_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_artists" ADD CONSTRAINT "game_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_external_identities" ADD CONSTRAINT "user_external_identities_authentication_id_fkey" FOREIGN KEY ("authentication_id") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_external_identities" ADD CONSTRAINT "user_external_identities_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "identity_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "oidc_auth_sessions" ADD CONSTRAINT "oidc_auth_sessions_authentication_id_fkey" FOREIGN KEY ("authentication_id") REFERENCES "user_authentications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "oidc_auth_sessions" ADD CONSTRAINT "oidc_auth_sessions_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "identity_providers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_authentication_id_fkey" FOREIGN KEY ("authentication_id") REFERENCES "user_authentications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_authentications" ADD CONSTRAINT "user_authentications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_game_master_id_fkey" FOREIGN KEY ("game_master_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_game_system_id_fkey" FOREIGN KEY ("game_system_id") REFERENCES "game_systems"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_characters" ADD CONSTRAINT "campaign_characters_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_characters" ADD CONSTRAINT "campaign_characters_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_locations" ADD CONSTRAINT "campaign_locations_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_locations" ADD CONSTRAINT "campaign_locations_parent_location_id_fkey" FOREIGN KEY ("parent_location_id") REFERENCES "campaign_locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_npcs" ADD CONSTRAINT "campaign_npcs_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_npc_appearances" ADD CONSTRAINT "campaign_npc_appearances_npc_id_fkey" FOREIGN KEY ("npc_id") REFERENCES "campaign_npcs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_npc_appearances" ADD CONSTRAINT "campaign_npc_appearances_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_sessions" ADD CONSTRAINT "character_sessions_character_id_fkey" FOREIGN KEY ("character_id") REFERENCES "campaign_characters"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "character_sessions" ADD CONSTRAINT "character_sessions_game_play_session_id_fkey" FOREIGN KEY ("game_play_session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_member_permissions" ADD CONSTRAINT "campaign_member_permissions_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_member_permissions" ADD CONSTRAINT "campaign_member_permissions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_member_permissions" ADD CONSTRAINT "campaign_member_permissions_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_session_outcomes" ADD CONSTRAINT "campaign_session_outcomes_game_play_session_id_fkey" FOREIGN KEY ("game_play_session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaign_session_outcomes" ADD CONSTRAINT "campaign_session_outcomes_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_parent_category_id_fkey" FOREIGN KEY ("parent_category_id") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_categories" ADD CONSTRAINT "game_categories_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_categories" ADD CONSTRAINT "game_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_designers" ADD CONSTRAINT "game_designers_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_designers" ADD CONSTRAINT "game_designers_designer_id_fkey" FOREIGN KEY ("designer_id") REFERENCES "designers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "designer_collaborations" ADD CONSTRAINT "designer_collaborations_primary_designer_id_fkey" FOREIGN KEY ("primary_designer_id") REFERENCES "designers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "designer_collaborations" ADD CONSTRAINT "designer_collaborations_collaborator_id_fkey" FOREIGN KEY ("collaborator_id") REFERENCES "designers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_designer_collaborations" ADD CONSTRAINT "game_designer_collaborations_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_designer_collaborations" ADD CONSTRAINT "game_designer_collaborations_designer_collaboration_id_fkey" FOREIGN KEY ("designer_collaboration_id") REFERENCES "designer_collaborations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_attendees" ADD CONSTRAINT "event_attendees_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_attendees" ADD CONSTRAINT "event_attendees_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_attendees" ADD CONSTRAINT "event_attendees_invited_by_id_fkey" FOREIGN KEY ("invited_by_id") REFERENCES "event_attendees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_game_votes" ADD CONSTRAINT "event_game_votes_event_game_id_fkey" FOREIGN KEY ("event_game_id") REFERENCES "event_games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_game_votes" ADD CONSTRAINT "event_game_votes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_game_votes" ADD CONSTRAINT "event_game_votes_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_games" ADD CONSTRAINT "event_games_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_games" ADD CONSTRAINT "event_games_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_games" ADD CONSTRAINT "event_games_suggested_by_id_fkey" FOREIGN KEY ("suggested_by_id") REFERENCES "event_attendees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_member_permissions" ADD CONSTRAINT "event_member_permissions_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_member_permissions" ADD CONSTRAINT "event_member_permissions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_member_permissions" ADD CONSTRAINT "event_member_permissions_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "excluded_games" ADD CONSTRAINT "excluded_games_household_member_id_fkey" FOREIGN KEY ("household_member_id") REFERENCES "household_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "excluded_games" ADD CONSTRAINT "excluded_games_game_collection_id_fkey" FOREIGN KEY ("game_collection_id") REFERENCES "game_collections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "families" ADD CONSTRAINT "families_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "publishers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "families" ADD CONSTRAINT "families_parent_family_id_fkey" FOREIGN KEY ("parent_family_id") REFERENCES "families"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_families" ADD CONSTRAINT "game_families_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_families" ADD CONSTRAINT "game_families_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "families"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_collections" ADD CONSTRAINT "family_collections_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "families"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "family_collections" ADD CONSTRAINT "family_collections_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendships" ADD CONSTRAINT "friendships_requestor_id_fkey" FOREIGN KEY ("requestor_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "friendships" ADD CONSTRAINT "friendships_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_household_access" ADD CONSTRAINT "game_household_access_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_household_access" ADD CONSTRAINT "game_household_access_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_household_access" ADD CONSTRAINT "game_household_access_shared_by_id_fkey" FOREIGN KEY ("shared_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_user_access" ADD CONSTRAINT "game_user_access_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_user_access" ADD CONSTRAINT "game_user_access_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_user_access" ADD CONSTRAINT "game_user_access_shared_by_id_fkey" FOREIGN KEY ("shared_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_expansions" ADD CONSTRAINT "game_expansions_base_game_id_fkey" FOREIGN KEY ("base_game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expansion_compatibilities" ADD CONSTRAINT "expansion_compatibilities_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expansion_compatibilities" ADD CONSTRAINT "expansion_compatibilities_expansion_id_fkey" FOREIGN KEY ("expansion_id") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_expansion_rule_variants" ADD CONSTRAINT "game_expansion_rule_variants_rule_variant_id_fkey" FOREIGN KEY ("rule_variant_id") REFERENCES "rule_variants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_expansion_rule_variants" ADD CONSTRAINT "game_expansion_rule_variants_game_expansion_id_fkey" FOREIGN KEY ("game_expansion_id") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_implementations" ADD CONSTRAINT "game_implementations_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_implementations" ADD CONSTRAINT "game_implementations_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "publishers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "implementation_ratings" ADD CONSTRAINT "implementation_ratings_implementation_id_fkey" FOREIGN KEY ("implementation_id") REFERENCES "game_implementations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "implementation_ratings" ADD CONSTRAINT "implementation_ratings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_game_version_id_fkey" FOREIGN KEY ("game_version_id") REFERENCES "game_versions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_campaign_location_id_fkey" FOREIGN KEY ("campaign_location_id") REFERENCES "campaign_locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_sessions" ADD CONSTRAINT "game_play_sessions_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_participants" ADD CONSTRAINT "game_play_participants_game_play_session_id_fkey" FOREIGN KEY ("game_play_session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_participants" ADD CONSTRAINT "game_play_participants_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_participants" ADD CONSTRAINT "game_play_participants_campaign_character_id_fkey" FOREIGN KEY ("campaign_character_id") REFERENCES "campaign_characters"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_results" ADD CONSTRAINT "game_play_results_game_play_session_id_fkey" FOREIGN KEY ("game_play_session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_session_expansions" ADD CONSTRAINT "game_play_session_expansions_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_play_session_expansions" ADD CONSTRAINT "game_play_session_expansions_expansion_id_fkey" FOREIGN KEY ("expansion_id") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_reviews" ADD CONSTRAINT "game_reviews_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_reviews" ADD CONSTRAINT "game_reviews_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_versions" ADD CONSTRAINT "game_versions_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_version_rule_variants" ADD CONSTRAINT "game_version_rule_variants_rule_variant_id_fkey" FOREIGN KEY ("rule_variant_id") REFERENCES "rule_variants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_version_rule_variants" ADD CONSTRAINT "game_version_rule_variants_game_version_id_fkey" FOREIGN KEY ("game_version_id") REFERENCES "game_versions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_weights" ADD CONSTRAINT "game_weights_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_weight_votes" ADD CONSTRAINT "game_weight_votes_game_weight_id_fkey" FOREIGN KEY ("game_weight_id") REFERENCES "game_weights"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_weight_votes" ADD CONSTRAINT "game_weight_votes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "games" ADD CONSTRAINT "games_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_collections" ADD CONSTRAINT "game_collections_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_collections" ADD CONSTRAINT "game_collections_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_media" ADD CONSTRAINT "game_media_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_media" ADD CONSTRAINT "game_media_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loaned_games" ADD CONSTRAINT "loaned_games_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loaned_games" ADD CONSTRAINT "loaned_games_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loaned_games" ADD CONSTRAINT "loaned_games_loaned_to_user_id_fkey" FOREIGN KEY ("loaned_to_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_permissions" ADD CONSTRAINT "group_permissions_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "permission_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "permission_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_members" ADD CONSTRAINT "group_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_championed_by_id_fkey" FOREIGN KEY ("championed_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_maintained_by_id_fkey" FOREIGN KEY ("maintained_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_games" ADD CONSTRAINT "household_games_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customizations" ADD CONSTRAINT "household_game_customizations_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customizations" ADD CONSTRAINT "household_game_customizations_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customizations" ADD CONSTRAINT "household_game_customizations_customized_by_id_fkey" FOREIGN KEY ("customized_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experiences" ADD CONSTRAINT "household_game_experiences_household_game_id_fkey" FOREIGN KEY ("household_game_id") REFERENCES "household_games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experiences" ADD CONSTRAINT "household_game_experiences_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experience_participants" ADD CONSTRAINT "household_game_experience_participants_experience_id_fkey" FOREIGN KEY ("experience_id") REFERENCES "household_game_experiences"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_experience_participants" ADD CONSTRAINT "household_game_experience_participants_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "household_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_interests" ADD CONSTRAINT "household_game_interests_household_game_id_fkey" FOREIGN KEY ("household_game_id") REFERENCES "household_games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_interests" ADD CONSTRAINT "household_game_interests_household_member_id_fkey" FOREIGN KEY ("household_member_id") REFERENCES "household_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customization_permissions" ADD CONSTRAINT "household_game_customization_permissions_customization_id_fkey" FOREIGN KEY ("customization_id") REFERENCES "household_game_customizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customization_permissions" ADD CONSTRAINT "household_game_customization_permissions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_game_customization_permissions" ADD CONSTRAINT "household_game_customization_permissions_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "households" ADD CONSTRAINT "households_language_id_fkey" FOREIGN KEY ("language_id") REFERENCES "languages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "households" ADD CONSTRAINT "households_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_roles" ADD CONSTRAINT "household_roles_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_roles" ADD CONSTRAINT "household_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_roles" ADD CONSTRAINT "household_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_members" ADD CONSTRAINT "household_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "household_members" ADD CONSTRAINT "household_members_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_invites" ADD CONSTRAINT "event_invites_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_invites" ADD CONSTRAINT "event_invites_invited_user_id_fkey" FOREIGN KEY ("invited_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_invites" ADD CONSTRAINT "event_invites_invited_by_id_fkey" FOREIGN KEY ("invited_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lists" ADD CONSTRAINT "lists_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_lists" ADD CONSTRAINT "game_lists_list_id_fkey" FOREIGN KEY ("list_id") REFERENCES "lists"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_lists" ADD CONSTRAINT "game_lists_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mechanic_relationships" ADD CONSTRAINT "mechanic_relationships_primary_mechanic_id_fkey" FOREIGN KEY ("primary_mechanic_id") REFERENCES "mechanics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mechanic_relationships" ADD CONSTRAINT "mechanic_relationships_related_mechanic_id_fkey" FOREIGN KEY ("related_mechanic_id") REFERENCES "mechanics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mechanic_relationships" ADD CONSTRAINT "mechanic_relationships_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_mechanics" ADD CONSTRAINT "game_mechanics_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_mechanics" ADD CONSTRAINT "game_mechanics_mechanic_id_fkey" FOREIGN KEY ("mechanic_id") REFERENCES "mechanics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session_media" ADD CONSTRAINT "session_media_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session_media" ADD CONSTRAINT "session_media_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "permission_policies" ADD CONSTRAINT "permission_policies_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_policy_assignments" ADD CONSTRAINT "role_policy_assignments_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_policy_assignments" ADD CONSTRAINT "role_policy_assignments_policy_id_fkey" FOREIGN KEY ("policy_id") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_policy_assignments" ADD CONSTRAINT "user_policy_assignments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_policy_assignments" ADD CONSTRAINT "user_policy_assignments_policy_id_fkey" FOREIGN KEY ("policy_id") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_policy_assignments" ADD CONSTRAINT "group_policy_assignments_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "permission_groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "group_policy_assignments" ADD CONSTRAINT "group_policy_assignments_policy_id_fkey" FOREIGN KEY ("policy_id") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resource_policy_assignments" ADD CONSTRAINT "resource_policy_assignments_policy_id_fkey" FOREIGN KEY ("policy_id") REFERENCES "permission_policies"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "resource_policy_assignments" ADD CONSTRAINT "resource_policy_assignments_applies_to_id_fkey" FOREIGN KEY ("applies_to_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publishers" ADD CONSTRAINT "publishers_parent_company_id_fkey" FOREIGN KEY ("parent_company_id") REFERENCES "publishers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_publishers" ADD CONSTRAINT "game_publishers_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_publishers" ADD CONSTRAINT "game_publishers_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "publishers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_campaign_id_fkey" FOREIGN KEY ("campaign_id") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variants" ADD CONSTRAINT "rule_variants_previous_version_id_fkey" FOREIGN KEY ("previous_version_id") REFERENCES "rule_variants"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usages" ADD CONSTRAINT "rule_variant_usages_rule_variant_id_fkey" FOREIGN KEY ("rule_variant_id") REFERENCES "rule_variants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usages" ADD CONSTRAINT "rule_variant_usages_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "game_play_sessions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_versions" ADD CONSTRAINT "rule_variant_usage_versions_rule_variant_usage_id_fkey" FOREIGN KEY ("rule_variant_usage_id") REFERENCES "rule_variant_usages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_versions" ADD CONSTRAINT "rule_variant_usage_versions_game_version_id_fkey" FOREIGN KEY ("game_version_id") REFERENCES "game_versions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_expansions" ADD CONSTRAINT "rule_variant_usage_expansions_rule_variant_usage_id_fkey" FOREIGN KEY ("rule_variant_usage_id") REFERENCES "rule_variant_usages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rule_variant_usage_expansions" ADD CONSTRAINT "rule_variant_usage_expansions_game_expansion_id_fkey" FOREIGN KEY ("game_expansion_id") REFERENCES "game_expansions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_tags" ADD CONSTRAINT "game_tags_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_tags" ADD CONSTRAINT "game_tags_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tags"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_tags" ADD CONSTRAINT "game_tags_added_by_id_fkey" FOREIGN KEY ("added_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tokens" ADD CONSTRAINT "tokens_authentication_id_fkey" FOREIGN KEY ("authentication_id") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_preferences" ADD CONSTRAINT "user_preferences_language_id_fkey" FOREIGN KEY ("language_id") REFERENCES "languages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permissions" ADD CONSTRAINT "user_permissions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_permissions" ADD CONSTRAINT "user_permissions_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_login_histories" ADD CONSTRAINT "user_login_histories_authentication_id_fkey" FOREIGN KEY ("authentication_id") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_devices" ADD CONSTRAINT "user_devices_authentication_id_fkey" FOREIGN KEY ("authentication_id") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customizations" ADD CONSTRAINT "user_game_customizations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customizations" ADD CONSTRAINT "user_game_customizations_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customization_permissions" ADD CONSTRAINT "user_game_customization_permissions_customization_id_fkey" FOREIGN KEY ("customization_id") REFERENCES "user_game_customizations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customization_permissions" ADD CONSTRAINT "user_game_customization_permissions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_game_customization_permissions" ADD CONSTRAINT "user_game_customization_permissions_granted_by_id_fkey" FOREIGN KEY ("granted_by_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_achievements" ADD CONSTRAINT "user_achievements_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_achievements" ADD CONSTRAINT "user_achievements_achievement_id_fkey" FOREIGN KEY ("achievement_id") REFERENCES "achievements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
