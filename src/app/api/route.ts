import { surveys } from '@/db/schema';
import { db } from '@/utils/db';

export async function POST(request: Request) {
  const data = await request.json();

  const survey = await db.insert(surveys).values(data).returning();

  if (!survey) {
    return Response.json({ error: 'Survey not created' }, { status: 500 });
  }

  return Response.json({ id: survey[0].id });
}
