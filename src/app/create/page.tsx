import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function Create() {
  return (
    <div className="flex flex-col gap-4 text-center items-center flex-1 w-full">
      <h1>Create a Survey</h1>
      <form className="flex flex-col gap-4 sm:w-[360px] w-full">
        <Input placeholder="Survey title"></Input>
        <Button>Create</Button>
      </form>
    </div>
  );
}
