import { CreateForm } from '@/components/create-form';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function Create() {
  return (
    <div className="flex flex-col gap-4 text-center items-center flex-1 w-full">
      <h1>Create a Survey</h1>
      <CreateForm />
    </div>
  );
}
