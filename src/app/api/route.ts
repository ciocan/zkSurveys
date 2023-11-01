import { surveys } from '@/db/schema';
import { db } from '@/utils/db';
import { eq } from 'drizzle-orm';

export async function POST(request: Request) {
  const data = await request.json();

  const survey = await db.insert(surveys).values(data).returning();

  if (!survey) {
    return Response.json({ error: 'Survey not created' }, { status: 500 });
  }

  return Response.json({ id: survey[0].id });
}

export async function GET(request: Request) {
  // const { id } = request.params;
  // const survey = await db.select(surveys).where({ id }).single();
  const result = await db.select().from(surveys).all();

  // if (!survey) {
  //   return Response.json({ error: 'Survey not found' }, { status: 404 });
  // }

  return Response.json(result);
}

export async function DELETE(request: Request) {
  const data = await request.json();
  const { id } = data;

  await db.delete(surveys).where(eq(surveys.id, id));
  
  return Response.json({ ok: true });
}