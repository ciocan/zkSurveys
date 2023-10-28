import type { Metadata } from 'next';
import { Inter } from 'next/font/google';

import './globals.css';
import { WalletProvider } from './WalletProvider';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'zkSurveys',
  description: 'Anonymous Surveys built for Aleo',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <WalletProvider>{children}</WalletProvider>
      </body>
    </html>
  );
}
