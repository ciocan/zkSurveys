"use client";
import { surveys } from '@/db/schema';
import { db } from '@/utils/db';
import Link from 'next/link';

import { Button } from '@/components/ui/button';
import { X } from 'lucide-react';
import { useEffect, useState } from 'react';

export const revalidate = 0;

// async function getSurveys() {
//   const result = await db.select().from(surveys).all();
//   return result;
// }

export default function Home() {
  const [list, setList] = useState([]);

  const getList = async () => {
    fetch('/api').then((res) => res.json()).then((res) => {
      setList(res)
    })
  }

  function deleteSurvey(id: number) {
    fetch('/api', {
      method: 'DELETE',
      body: JSON.stringify({ id }),
    })
      .then((res) => {
        getList()
      })
  }

  useEffect(() => {
    getList()
  }, []);

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
              <Button variant="outline" size="icon" type="button" onClick={() => deleteSurvey(id)}>
                <X className="h-4 w-4" />
              </Button>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
