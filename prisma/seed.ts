import console from 'node:console';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // Do seed stuffs here

  await prisma.language.upsert({
    create: {
      name: 'English',
      abbreviation: 'en',
      code: 'eng',
    },
    update: {},
    where: {
      code: 'eng',
    },
  });
}

main()
  .then(() => console.log('Seeding complete'))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
