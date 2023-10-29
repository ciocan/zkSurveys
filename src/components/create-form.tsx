'use client';
import { useState } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { X } from 'lucide-react';
import { useWallet } from '@demox-labs/aleo-wallet-adapter-react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Form, FormControl, FormDescription, FormField, FormItem, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { toast } from '@/components/ui/use-toast';

const FormSchema = z.object({
  name: z.string().min(10, {
    message: 'Survey name must be at least 10 characters long.',
  }),
  questions: z.array(
    z.string().min(10, {
      message: 'Survey question must be at least 10 characters long.',
    }),
  ),
});

export function CreateForm() {
  const router = useRouter();
  const { publicKey } = useWallet();
  const [totalQuestions, incrementQuestions] = useState(3);

  const form = useForm<z.infer<typeof FormSchema>>({
    resolver: zodResolver(FormSchema),
    defaultValues: {
      name: '',
      questions: [''],
    },
  });

  function deleteQuestion() {
    if (totalQuestions <= 1) return;
    form.setValue('questions', form.getValues('questions').slice(0, -1));
    incrementQuestions((q) => q - 1);
  }

  function addQuestion() {
    form.setValue('questions', [...form.getValues('questions'), '']);
    incrementQuestions((q) => q + 1);
  }

  function onSubmit(data: z.infer<typeof FormSchema>) {
    if (!publicKey) {
      toast({
        title: 'You must connect your wallet to create a survey.',
        variant: 'destructive',
      });
      return;
    }

    fetch('/api', {
      method: 'POST',
      body: JSON.stringify({ ...data, owner: publicKey }),
    })
      .then((res) => res.json())
      .then((res) => {
        console.log(res);
        // TODO: run aleo contract to create survey
        toast({
          title: 'Your survey was created.',
        });
        router.push(`/surveys/${res.id}`);
      })
      .catch((err) => {
        console.error(err);
        toast({
          title: 'There was an error creating your survey.',
          description: err.message,
          variant: 'destructive',
        });
      });
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6 sm:w-[360px] w-full">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormControl>
                <Input placeholder="Survey name" {...field} />
              </FormControl>
              <FormMessage className="text-xs" />
            </FormItem>
          )}
        />
        <FormDescription>Create the survey questions:</FormDescription>
        {Array.from({ length: totalQuestions }).map((_, i) => (
          <div key={i} className="flex gap-2">
            <FormField
              control={form.control}
              name={`questions.${i}`}
              render={({ field }) => (
                <FormItem className="w-full">
                  <FormControl>
                    <Input placeholder={`Question ${i + 1}`} {...field} />
                  </FormControl>
                  <FormMessage className="text-xs" />
                </FormItem>
              )}
            />
            <Button variant="outline" size="icon" type="button" onClick={deleteQuestion}>
              <X className="h-4 w-4" />
            </Button>
          </div>
        ))}
        <Button type="button" variant="secondary" onClick={addQuestion}>
          +1 more question
        </Button>
        <Button className="w-full">Create</Button>
      </form>
    </Form>
  );
}
