'use client';
import Link from 'next/link';
import { WalletMultiButton } from '@demox-labs/aleo-wallet-adapter-reactui';

import { Credits } from './credits';

export function Header() {
  return (
    <nav className="flex items-center justify-between w-full p-4">
      <span className="flex sm:flex-row flex-col sm:items-center items-start sm:gap-8 gap-4">
        <h1 className="text-xl">
          <Link href="/">zkSurveys</Link>
        </h1>
        <Link href="/create">Create</Link>
      </span>
      <span className="flex items-center gap-2">
        {/* <Credits /> */}
        <WalletMultiButton className="bg-[#154bf9]" />
      </span>
    </nav>
  );
}
