'use client';
import { useState } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import * as z from 'zod';
import { X } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Form, FormControl, FormDescription, FormField, FormItem, FormMessage } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { toast } from '@/components/ui/use-toast';

const FormSchema = z.object({
  title: z.string().min(10, {
    message: 'Survey title must be at least 10 characters long.',
  }),
  questions: z.array(
    z.string().min(10, {
      message: 'Survey question must be at least 10 characters long.',
    }),
  ),
});

export function CreateForm() {
  const [totalQuestions, incrementQuestions] = useState(3);
  const form = useForm<z.infer<typeof FormSchema>>({
    resolver: zodResolver(FormSchema),
    defaultValues: {
      title: '',
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
    console.log(data);
    toast({
      title: 'You submitted the following values:',
      description: (
        <pre className="mt-2 w-[300px] rounded-md bg-slate-950 p-4">
          <code className="text-white">{JSON.stringify(data, null, 2)}</code>
        </pre>
      ),
    });
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6 sm:w-[360px] w-full">
        <FormField
          control={form.control}
          name="title"
          render={({ field }) => (
            <FormItem>
              <FormControl>
                <Input placeholder="Survey title" {...field} />
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
