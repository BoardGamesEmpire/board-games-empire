import { Envirator } from '@status/envirator';

export const env = new Envirator({
  camelcase: true,
  productionDefaults: true,
});
