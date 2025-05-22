/*
  Warnings:

  - You are about to drop the column `app_store_id` on the `game_implementations` table. All the data in the column will be lost.
  - You are about to drop the column `board_game_arena_id` on the `game_implementations` table. All the data in the column will be lost.
  - You are about to drop the column `google_play_id` on the `game_implementations` table. All the data in the column will be lost.
  - You are about to drop the column `steam_app_id` on the `game_implementations` table. All the data in the column will be lost.
  - You are about to drop the column `external_id` on the `games` table. All the data in the column will be lost.
  - You are about to drop the column `is_from_external` on the `games` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "chat_room_types" AS ENUM ('Public', 'Private', 'Direct', 'Household', 'Game', 'Event', 'System');

-- CreateEnum
CREATE TYPE "chat_room_roles" AS ENUM ('Owner', 'Admin', 'Moderator', 'Member', 'Guest');

-- CreateEnum
CREATE TYPE "AuthType" AS ENUM ('ApiKey', 'Basic', 'Certificate', 'HMAC', 'JWT', 'None', 'OAuth', 'PSK');

-- AlterTable
ALTER TABLE "game_implementations" DROP COLUMN "app_store_id",
DROP COLUMN "board_game_arena_id",
DROP COLUMN "google_play_id",
DROP COLUMN "steam_app_id",
ADD COLUMN     "external_source_identifier" TEXT,
ADD COLUMN     "game_gateway_id" TEXT,
ADD COLUMN     "store_identifiers" JSONB;

-- AlterTable
ALTER TABLE "games" DROP COLUMN "external_id",
DROP COLUMN "is_from_external";

-- CreateTable
CREATE TABLE "chat_rooms" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" "chat_room_types" NOT NULL DEFAULT 'Public',
    "household_id" TEXT,
    "game_id" TEXT,
    "event_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "chat_rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chat_room_members" (
    "id" TEXT NOT NULL,
    "room_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "role" "chat_room_roles" NOT NULL DEFAULT 'Member',
    "joined_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_read" TIMESTAMPTZ(3),
    "is_muted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "chat_room_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chat_messages" (
    "id" TEXT NOT NULL,
    "room_id" TEXT NOT NULL,
    "sender_id" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "is_system" BOOLEAN NOT NULL DEFAULT false,
    "is_edited" BOOLEAN NOT NULL DEFAULT false,
    "edited_at" TIMESTAMPTZ(3),
    "reply_to_id" TEXT,
    "metadata" JSONB,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chat_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chat_message_reactions" (
    "id" TEXT NOT NULL,
    "message_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "emoji" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chat_message_reactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_external_references" (
    "id" TEXT NOT NULL,
    "game_id" TEXT NOT NULL,
    "game_gateway_id" TEXT NOT NULL,
    "external_id" TEXT NOT NULL,
    "source_url" TEXT,
    "metadata" JSONB,
    "last_synced" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_external_references_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_gateways" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "message_context" TEXT,
    "icon_url" TEXT,
    "logo_url" TEXT,
    "website_url" TEXT,
    "base_url" TEXT,
    "api_documentation" TEXT,
    "api_version" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "auth_type" "AuthType" NOT NULL,
    "auth_parameters" JSONB,
    "usage_count" INTEGER NOT NULL DEFAULT 0,
    "last_used" TIMESTAMPTZ(3),
    "created_by_id" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "game_gateways_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "chat_rooms_household_id_key" ON "chat_rooms"("household_id");

-- CreateIndex
CREATE UNIQUE INDEX "chat_rooms_game_id_key" ON "chat_rooms"("game_id");

-- CreateIndex
CREATE UNIQUE INDEX "chat_rooms_event_id_key" ON "chat_rooms"("event_id");

-- CreateIndex
CREATE UNIQUE INDEX "chat_room_members_room_id_user_id_key" ON "chat_room_members"("room_id", "user_id");

-- CreateIndex
CREATE INDEX "chat_messages_room_id_created_at_idx" ON "chat_messages"("room_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "chat_message_reactions_message_id_user_id_emoji_key" ON "chat_message_reactions"("message_id", "user_id", "emoji");

-- CreateIndex
CREATE UNIQUE INDEX "game_external_references_game_id_game_gateway_id_key" ON "game_external_references"("game_id", "game_gateway_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_gateways_name_key" ON "game_gateways"("name");

-- AddForeignKey
ALTER TABLE "chat_rooms" ADD CONSTRAINT "chat_rooms_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "households"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_rooms" ADD CONSTRAINT "chat_rooms_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_rooms" ADD CONSTRAINT "chat_rooms_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "events"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_room_members" ADD CONSTRAINT "chat_room_members_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "chat_rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_room_members" ADD CONSTRAINT "chat_room_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_messages" ADD CONSTRAINT "chat_messages_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "chat_rooms"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_messages" ADD CONSTRAINT "chat_messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_messages" ADD CONSTRAINT "chat_messages_reply_to_id_fkey" FOREIGN KEY ("reply_to_id") REFERENCES "chat_messages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_message_reactions" ADD CONSTRAINT "chat_message_reactions_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "chat_messages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chat_message_reactions" ADD CONSTRAINT "chat_message_reactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_external_references" ADD CONSTRAINT "game_external_references_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_external_references" ADD CONSTRAINT "game_external_references_game_gateway_id_fkey" FOREIGN KEY ("game_gateway_id") REFERENCES "game_gateways"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_gateways" ADD CONSTRAINT "game_gateways_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_implementations" ADD CONSTRAINT "game_implementations_game_gateway_id_fkey" FOREIGN KEY ("game_gateway_id") REFERENCES "game_gateways"("id") ON DELETE SET NULL ON UPDATE CASCADE;
