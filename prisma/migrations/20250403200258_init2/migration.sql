/*
  Warnings:

  - You are about to drop the column `userId` on the `oidc_auth_sessions` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tokens` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `user_devices` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `user_external_identities` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `user_login_histories` table. All the data in the column will be lost.
  - You are about to drop the column `accountLocked` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `accountLockedUntil` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `authStrategy` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `emailVerificationToken` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `emailVerificationTokenExpires` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `emailVerified` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `failedLoginAttempts` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `isExternalUser` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `lastFailedLogin` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `lastLogin` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `lastPasswordChange` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `passwordResetToken` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `passwordResetTokenExpires` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `recoveryCodesHash` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `twoFactorEnabled` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `twoFactorSecret` on the `users` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[authenticationId,deviceIdentifier]` on the table `user_devices` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `authenticationId` to the `tokens` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `tokens` table without a default value. This is not possible if the table is not empty.
  - Added the required column `authenticationId` to the `user_devices` table without a default value. This is not possible if the table is not empty.
  - Added the required column `authenticationId` to the `user_external_identities` table without a default value. This is not possible if the table is not empty.
  - Added the required column `authenticationId` to the `user_login_histories` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "token_types" AS ENUM ('Access', 'Refresh', 'EmailVerification', 'PasswordReset');

-- DropForeignKey
ALTER TABLE "oidc_auth_sessions" DROP CONSTRAINT "oidc_auth_sessions_userId_fkey";

-- DropForeignKey
ALTER TABLE "tokens" DROP CONSTRAINT "tokens_userId_fkey";

-- DropForeignKey
ALTER TABLE "user_devices" DROP CONSTRAINT "user_devices_userId_fkey";

-- DropForeignKey
ALTER TABLE "user_external_identities" DROP CONSTRAINT "user_external_identities_userId_fkey";

-- DropForeignKey
ALTER TABLE "user_login_histories" DROP CONSTRAINT "user_login_histories_userId_fkey";

-- DropIndex
DROP INDEX "user_devices_userId_deviceIdentifier_key";

-- DropIndex
DROP INDEX "users_email_key";

-- AlterTable
ALTER TABLE "oidc_auth_sessions" DROP COLUMN "userId",
ADD COLUMN     "authenticationId" TEXT;

-- AlterTable
ALTER TABLE "system_settings" ADD COLUMN     "allowUsernameChange" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "tokens" DROP COLUMN "userId",
ADD COLUMN     "authenticationId" TEXT NOT NULL,
ADD COLUMN     "isRevoked" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "isUsed" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "revokedAt" TIMESTAMP(3),
ADD COLUMN     "type" "token_types" NOT NULL,
ADD COLUMN     "usedAt" TIMESTAMP(3),
ALTER COLUMN "token" SET DATA TYPE VARCHAR(512);

-- AlterTable
ALTER TABLE "user_devices" DROP COLUMN "userId",
ADD COLUMN     "authenticationId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "user_external_identities" DROP COLUMN "userId",
ADD COLUMN     "authenticationId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "user_login_histories" DROP COLUMN "userId",
ADD COLUMN     "authenticationId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "users" DROP COLUMN "accountLocked",
DROP COLUMN "accountLockedUntil",
DROP COLUMN "authStrategy",
DROP COLUMN "email",
DROP COLUMN "emailVerificationToken",
DROP COLUMN "emailVerificationTokenExpires",
DROP COLUMN "emailVerified",
DROP COLUMN "failedLoginAttempts",
DROP COLUMN "isExternalUser",
DROP COLUMN "lastFailedLogin",
DROP COLUMN "lastLogin",
DROP COLUMN "lastPasswordChange",
DROP COLUMN "password",
DROP COLUMN "passwordResetToken",
DROP COLUMN "passwordResetTokenExpires",
DROP COLUMN "recoveryCodesHash",
DROP COLUMN "twoFactorEnabled",
DROP COLUMN "twoFactorSecret";

-- CreateTable
CREATE TABLE "user_authentications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "authStrategy" "auth_strategies" NOT NULL DEFAULT 'Local',
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "lastPasswordChange" TIMESTAMP(3),
    "accountLocked" BOOLEAN NOT NULL DEFAULT false,
    "accountLockedUntil" TIMESTAMP(3),
    "failedLoginAttempts" INTEGER NOT NULL DEFAULT 0,
    "lastFailedLogin" TIMESTAMP(3),
    "lastLogin" TIMESTAMP(3),
    "twoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
    "twoFactorSecret" TEXT,
    "recoveryCodesHash" TEXT,
    "isExternalUser" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_authentications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" TEXT NOT NULL,
    "authenticationId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "lastActive" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isValid" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_authentications_userId_key" ON "user_authentications"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "user_authentications_email_key" ON "user_authentications"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_token_key" ON "user_sessions"("token");

-- CreateIndex
CREATE INDEX "user_sessions_token_idx" ON "user_sessions"("token");

-- CreateIndex
CREATE INDEX "user_sessions_authenticationId_isValid_idx" ON "user_sessions"("authenticationId", "isValid");

-- CreateIndex
CREATE UNIQUE INDEX "user_devices_authenticationId_deviceIdentifier_key" ON "user_devices"("authenticationId", "deviceIdentifier");

-- AddForeignKey
ALTER TABLE "user_external_identities" ADD CONSTRAINT "user_external_identities_authenticationId_fkey" FOREIGN KEY ("authenticationId") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "oidc_auth_sessions" ADD CONSTRAINT "oidc_auth_sessions_authenticationId_fkey" FOREIGN KEY ("authenticationId") REFERENCES "user_authentications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tokens" ADD CONSTRAINT "tokens_authenticationId_fkey" FOREIGN KEY ("authenticationId") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_authentications" ADD CONSTRAINT "user_authentications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_login_histories" ADD CONSTRAINT "user_login_histories_authenticationId_fkey" FOREIGN KEY ("authenticationId") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_devices" ADD CONSTRAINT "user_devices_authenticationId_fkey" FOREIGN KEY ("authenticationId") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_authenticationId_fkey" FOREIGN KEY ("authenticationId") REFERENCES "user_authentications"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
