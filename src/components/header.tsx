'use client';
import { WalletMultiButton } from '@demox-labs/aleo-wallet-adapter-reactui';

import { Credits } from './credits';

export function Header() {
  return (
    <nav className="flex items-center justify-between w-full p-4">
      <h1 className="text-xl">zkSurveys</h1>
      <span className="flex items-center gap-2">
        <Credits />
        <WalletMultiButton className="bg-[#154bf9]" />
      </span>
    </nav>
  );
}
