import { sqliteTable, text, blob, integer, uniqueIndex } from 'drizzle-orm/sqlite-core';

export type Questions = string;

export const surveys = sqliteTable(
  'surveys',
  {
    id: integer('id').primaryKey({ autoIncrement: true }),
    name: text('name').notNull(),
    questions: blob('questions').$type<Questions>().notNull(),
    owner: text('owner').notNull(),
  },
  (surveys) => ({
    nameIdx: uniqueIndex('nameIdx').on(surveys.name, surveys.owner),
  }),
);

export type Surveys = typeof surveys.$inferSelect;
