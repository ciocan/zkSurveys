import { surveys } from '@/db/schema';
import { db } from '@/utils/db';
import { eq } from 'drizzle-orm';

import { Slider } from '@/components/ui/slider';
import { Button } from '@/components/ui/button';

async function getSurvey(id: number) {
  const result = await db.select().from(surveys).where(eq(surveys.id, id));
  return result;
}

export default async function Survey({ params }: { params: { id: string } }) {
  const id = parseInt(params.id);
  const [survey] = await getSurvey(id);
  if (!survey) throw new Error('Survey not found.');

  const questions = survey.questions.split(',');

  return (
    <div className="flex flex-col">
      <h1 className="font-bold text-center">{survey.name}</h1>
      <ul className="py-6 space-y-8">
        {questions.map((q, idx) => (
          <li key={idx} className='space-y-2'>
            <h2>{q}</h2>
            <Slider defaultValue={[3]} min={1} max={5} step={1} />
          </li>
        ))}
      </ul>
      <Button className="mt-6">Submit</Button>
    </div>
  );
}
