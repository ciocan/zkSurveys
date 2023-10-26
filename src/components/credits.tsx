'use client';
import { useEffect } from 'react';
import { useWallet } from '@demox-labs/aleo-wallet-adapter-react';

const program = 'credits.aleo';

export function Credits() {
  const { wallet, publicKey, requestRecordPlaintexts, requestTransactionHistory } = useWallet();
  // console.log(wallet, publicKey);

  useEffect(() => {
    if (!publicKey || !requestRecordPlaintexts || !requestTransactionHistory) return;

    const getCredits = async () => {
      try {
        const records = await requestRecordPlaintexts(program);
        console.log('Records: ', records);
        const transactions = await requestTransactionHistory(program);
        console.log('Transaction history: ', transactions);
      } catch (error) {
        console.error('ERROR: ', error);
      }
    };

    getCredits();
  }, [publicKey, requestRecordPlaintexts, requestTransactionHistory]);

  if (!wallet || !publicKey) {
    return null;
  }

  return <span className="text-sm">0 Credits</span>;
}
