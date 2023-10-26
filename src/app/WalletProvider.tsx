'use client';
import React, { useMemo } from 'react';
import { WalletProvider as LeoWalletProvider } from '@demox-labs/aleo-wallet-adapter-react';
import { WalletModalProvider } from '@demox-labs/aleo-wallet-adapter-reactui';
import { LeoWalletAdapter } from '@demox-labs/aleo-wallet-adapter-leo';
import { DecryptPermission, WalletAdapterNetwork } from '@demox-labs/aleo-wallet-adapter-base';

require('@demox-labs/aleo-wallet-adapter-reactui/styles.css');

export const WalletProvider = ({ children }: { children: React.ReactNode }) => {
  const wallets = useMemo(
    () => [
      new LeoWalletAdapter({
        appName: 'zkSurveys',
      }),
    ],
    [],
  );

  return (
    <LeoWalletProvider
      wallets={wallets}
      decryptPermission={DecryptPermission.OnChainHistory}
      network={WalletAdapterNetwork.Testnet}
      autoConnect
      localStorageKey="zkSurveys"
    >
      <WalletModalProvider>{children}</WalletModalProvider>
    </LeoWalletProvider>
  );
};
