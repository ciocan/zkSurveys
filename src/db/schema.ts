import { sqliteTable, text, integer, uniqueIndex } from 'drizzle-orm/sqlite-core';

export type Questions = string[];

export const surveys = sqliteTable(
  'surveys',
  {
    id: integer('id').primaryKey({ autoIncrement: true }),
    name: text('name').notNull(),
    questions: text('questions').$type<Questions>().notNull(),
    owner: text('owner').notNull(),
  },
  (surveys) => ({
    nameIdx: uniqueIndex('nameIdx').on(surveys.name),
  }),
);

export type Surveys = typeof surveys.$inferSelect;
