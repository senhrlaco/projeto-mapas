FROM node:20-alpine

# dependencias nativas do bcrypt
RUN apk add --no-cache python3 make g++

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY prisma ./prisma
COPY src ./src
COPY tsconfig.json ./

# gera o cliente prisma
RUN npx prisma generate

COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

EXPOSE 3333

ENTRYPOINT ["./entrypoint.sh"]
