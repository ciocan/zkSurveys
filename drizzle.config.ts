import { type Config } from 'drizzle-kit';

import { DATABASE_AUTH_TOKEN, DATABASE_URL } from './src/utils/env';

export default {
  out: './src/db/migrations',
  schema: './src/db/schema.ts',
  breakpoints: true,
  driver: 'turso',
  dbCredentials: {
    url: DATABASE_URL,
    authToken: DATABASE_AUTH_TOKEN,
  },
} satisfies Config;
