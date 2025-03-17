import process from 'node:process';

export const environment = {
  production: true,
  version: `v${process.env.npm_package_version}`,
};
