import fs from 'node:fs';
import * as path from 'node:path';
import process from 'node:process';

const tmpDir = path.join(process.cwd(), 'tmp');
const prismaDir = path.resolve('prisma');
const schemaDir = path.join(prismaDir, 'schema');
const outputDir = path.join(tmpDir, 'schema');
const outputFile = path.join(outputDir, 'schema.prisma');

async function main() {
  await fs.promises.mkdir(outputDir, { recursive: true });

  if (fs.existsSync(prismaDir)) {
    await fs.promises.rm(prismaDir, { recursive: true, force: true });
  }

  const dirContents = await fs.promises.readdir(schemaDir);
  const schemaFiles = dirContents.filter((file) => file.endsWith('.prisma'));
  const prismaMain = schemaFiles.find((file) => file === 'schema.prisma');

  const writeStream = fs.createWriteStream(outputFile, { flags: 'a' });

  if (prismaMain) {
    const mainFilePath = path.join(schemaDir, prismaMain);
    const mainFileStream = fs.createReadStream(mainFilePath);
    mainFileStream.pipe(writeStream, { end: false });
    await new Promise((resolve) => {
      mainFileStream.on('end', resolve);
    });
  }

  for (const file of schemaFiles) {
    if (file === 'schema.prisma') {
      continue;
    }

    writeStream.write('\n\n');

    const filePath = path.join(schemaDir, file);
    const fileStream = fs.createReadStream(filePath);
    fileStream.pipe(writeStream, { end: false });
    await new Promise((resolve) => {
      fileStream.on('end', resolve);
    });
  }

  writeStream.end();

  console.log('Schema files merged successfully!');
}

main()
  .then(() => {
    console.log('All files processed successfully.');
    console.log('Merged schema written to:', outputFile);
  })
  .catch((error) => {
    console.error('Error processing files:', error);
  });
