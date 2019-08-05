FROM node AS build
WORKDIR /app/satellite
COPY package*.json .
RUN npm install
COPY . .