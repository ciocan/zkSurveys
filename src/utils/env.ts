import * as dotenv from 'dotenv';
import { parseEnv } from 'znv';
import { z } from 'zod';

dotenv.config();

export const { DATABASE_URL, DATABASE_AUTH_TOKEN } = parseEnv(process.env, {
  DATABASE_URL: z.string().min(1),
  DATABASE_AUTH_TOKEN: z.string().min(1).optional(),
});
