# -----------------------------
# Base Image
# -----------------------------
FROM node:20-alpine AS base

WORKDIR /app

# Install dependencies required for native npm packages
RUN apk add --no-cache \
    python3 \
    make \
    g++

# -----------------------------
# Dependencies
# -----------------------------
FROM base AS deps

COPY package*.json ./

RUN npm ci

# -----------------------------
# Build
# -----------------------------
FROM deps AS build

COPY . .

# Build TypeScript project
RUN npm run build

# -----------------------------
# Production Image
# -----------------------------
FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

# Create non-root user
RUN addgroup -S sunrise && adduser -S sunrise -G sunrise

# Copy package files
COPY --from=deps /app/package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy built application
COPY --from=build /app ./

# Ensure writable directories exist
RUN mkdir -p data database temp && \
    chown -R sunrise:sunrise /app

USER sunrise

EXPOSE 8080

CMD ["node", "index.js"]
