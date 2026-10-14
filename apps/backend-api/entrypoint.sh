#!/bin/sh
set -e

# aplica o schema no banco antes de subir
npx prisma db push --accept-data-loss

# cria o usuario admin se nao existir
npx ts-node prisma/seed.ts

npm run dev
