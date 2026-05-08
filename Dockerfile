FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache python3 make g++ xz

COPY package*.json ./

RUN npm ci

COPY . .

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

CMD ["npm", "start"]
