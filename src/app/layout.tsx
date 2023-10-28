import type { Metadata } from 'next';
import { Inter } from 'next/font/google';

import './globals.css';
import { WalletProvider } from './WalletProvider';
import { Header } from '@/components';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'zkSurveys',
  description: 'Anonymous Surveys built for Aleo',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <WalletProvider>
          <Header />
          <main className="flex min-h-screen flex-col items-center py-10 px-4">{children}</main>
        </WalletProvider>
      </body>
    </html>
  );
}
