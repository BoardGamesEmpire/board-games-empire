-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'GUEST', 'SiteAdmin', 'SiteOwner', 'USER');

-- CreateTable
CREATE TABLE "AuthDevice" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "credentialId" BYTEA NOT NULL,
    "credentialPublicKey" BYTEA NOT NULL,
    "counter" INTEGER NOT NULL,
    "uuid" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "AuthDevice_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Language" (
    "abbreviation" VARCHAR(2) NOT NULL,
    "code" VARCHAR(3) NOT NULL,
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Language_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Token" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "uuid" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Token_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "User" (
    "avatar" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" TEXT NOT NULL,
    "firstName" TEXT,
    "uuid" TEXT NOT NULL,
    "languageId" TEXT,
    "lastName" TEXT,
    "password" TEXT,
    "role" "Role" NOT NULL DEFAULT 'USER',
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "username" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Household" (
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "uuid" TEXT NOT NULL,
    "image" TEXT,
    "languageId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Household_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "HouseholdMember" (
    "uuid" TEXT NOT NULL,
    "householdId" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "HouseholdMember_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GameType" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "GameType_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Category" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GameCategory" (
    "uuid" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,

    CONSTRAINT "GameCategory_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Mechanic" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Mechanic_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GameMechanic" (
    "uuid" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "mechanicId" TEXT NOT NULL,

    CONSTRAINT "GameMechanic_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Family" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Family_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GameFamily" (
    "uuid" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "familyId" TEXT NOT NULL,

    CONSTRAINT "GameFamily_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Designer" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Designer_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GameDesigner" (
    "uuid" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "designerId" TEXT NOT NULL,

    CONSTRAINT "GameDesigner_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Artist" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Artist_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GameArtist" (
    "uuid" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "artistId" TEXT NOT NULL,

    CONSTRAINT "GameArtist_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Publisher" (
    "uuid" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Publisher_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "GamePublisher" (
    "uuid" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "gameId" TEXT NOT NULL,
    "publisherId" TEXT NOT NULL,

    CONSTRAINT "GamePublisher_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Game" (
    "uuid" TEXT NOT NULL,
    "typeId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
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
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Game_pkey" PRIMARY KEY ("uuid")
);

-- CreateIndex
CREATE UNIQUE INDEX "Language_abbreviation_key" ON "Language"("abbreviation");

-- CreateIndex
CREATE UNIQUE INDEX "Language_code_key" ON "Language"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Language_name_key" ON "Language"("name");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Household_name_key" ON "Household"("name");

-- CreateIndex
CREATE UNIQUE INDEX "HouseholdMember_householdId_userId_key" ON "HouseholdMember"("householdId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "GameType_name_key" ON "GameType"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Category_name_key" ON "Category"("name");

-- CreateIndex
CREATE UNIQUE INDEX "GameCategory_gameId_categoryId_key" ON "GameCategory"("gameId", "categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "Mechanic_name_key" ON "Mechanic"("name");

-- CreateIndex
CREATE UNIQUE INDEX "GameMechanic_gameId_mechanicId_key" ON "GameMechanic"("gameId", "mechanicId");

-- CreateIndex
CREATE UNIQUE INDEX "Family_name_key" ON "Family"("name");

-- CreateIndex
CREATE UNIQUE INDEX "GameFamily_gameId_familyId_key" ON "GameFamily"("gameId", "familyId");

-- CreateIndex
CREATE UNIQUE INDEX "Designer_name_key" ON "Designer"("name");

-- CreateIndex
CREATE UNIQUE INDEX "GameDesigner_gameId_designerId_key" ON "GameDesigner"("gameId", "designerId");

-- CreateIndex
CREATE UNIQUE INDEX "Artist_name_key" ON "Artist"("name");

-- CreateIndex
CREATE UNIQUE INDEX "GameArtist_gameId_artistId_key" ON "GameArtist"("gameId", "artistId");

-- CreateIndex
CREATE UNIQUE INDEX "Publisher_name_key" ON "Publisher"("name");

-- CreateIndex
CREATE UNIQUE INDEX "GamePublisher_gameId_publisherId_key" ON "GamePublisher"("gameId", "publisherId");

-- AddForeignKey
ALTER TABLE "AuthDevice" ADD CONSTRAINT "AuthDevice_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Token" ADD CONSTRAINT "Token_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_languageId_fkey" FOREIGN KEY ("languageId") REFERENCES "Language"("uuid") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Household" ADD CONSTRAINT "Household_languageId_fkey" FOREIGN KEY ("languageId") REFERENCES "Language"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Household" ADD CONSTRAINT "Household_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HouseholdMember" ADD CONSTRAINT "HouseholdMember_householdId_fkey" FOREIGN KEY ("householdId") REFERENCES "Household"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HouseholdMember" ADD CONSTRAINT "HouseholdMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameCategory" ADD CONSTRAINT "GameCategory_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameCategory" ADD CONSTRAINT "GameCategory_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameMechanic" ADD CONSTRAINT "GameMechanic_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameMechanic" ADD CONSTRAINT "GameMechanic_mechanicId_fkey" FOREIGN KEY ("mechanicId") REFERENCES "Mechanic"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameFamily" ADD CONSTRAINT "GameFamily_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameFamily" ADD CONSTRAINT "GameFamily_familyId_fkey" FOREIGN KEY ("familyId") REFERENCES "Family"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameDesigner" ADD CONSTRAINT "GameDesigner_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameDesigner" ADD CONSTRAINT "GameDesigner_designerId_fkey" FOREIGN KEY ("designerId") REFERENCES "Designer"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameArtist" ADD CONSTRAINT "GameArtist_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GameArtist" ADD CONSTRAINT "GameArtist_artistId_fkey" FOREIGN KEY ("artistId") REFERENCES "Artist"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GamePublisher" ADD CONSTRAINT "GamePublisher_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "Game"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GamePublisher" ADD CONSTRAINT "GamePublisher_publisherId_fkey" FOREIGN KEY ("publisherId") REFERENCES "Publisher"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Game" ADD CONSTRAINT "Game_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "GameType"("uuid") ON DELETE RESTRICT ON UPDATE CASCADE;
