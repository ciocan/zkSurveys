# Aleo zkSurveys

## Getting Started

Copy ```.env.example``` into ```.env``` and fill in the values.
We use sqllite on [Turso](https://turso.tech/) to save the offchain data so no need to setup a database.

Install dependencies:

```bash
pnpm install
```

Run the database migrations:

```bash
pnpm db:generate
pnpm db:migrate
```

Run the development servers:

```bash
pnpm dev # to run the next app
#
pnpm db:studio # to run the drizzle studio
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

Open [http://localhost:4983](http://localhost:4983) with your browser to see the db studio.
