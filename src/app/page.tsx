import { surveys } from '@/db/schema';
import { db } from '@/utils/db';
import Link from 'next/link';

export const revalidate = 0;

async function getSurveys() {
  const result = await db.select().from(surveys).all();
  return result;
}

export default async function Home() {
  const list = await getSurveys();
  // TODO: filter by publicKey of connected wallet
  return (
    <div className="">
      <h1 className="text-center font-bold">Surveys</h1>
      <ul className="py-6 space-y-1">
        {list.map(({ id, name }) => {
          return (
            <li key={id} className="">
              <Link href={`/survey/${id}`} className="hover:underline">
                {name}
              </Link>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
