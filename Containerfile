# Stage 1: BUILD
FROM node:alpine AS build

# Zet de working directory op /app
WORKDIR /app

# Kopieert de package.json en package.lock.json
COPY package*.json ./

# installeert alle packages idempotent
RUN npm ci

# kopieer alle bestanden van ons project naar de $WORKDIR directory
COPY . .

# Run het commando om de productie build te draaien
RUN npm run build

# Stage 2 Runtime stage
FROM node:alpine

WORKDIR /app

# Kopieer alle bestanden uit de dist build over naar /app/dist
COPY --from=build /app/dist/runTracker/browser ./dist

# Expose poort 4200
EXPOSE 4200

# start commando
CMD ["npx", "serve", "dist", "-p", "4200"]
