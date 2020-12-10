# Base for image
FROM node:14-alpine as base

WORKDIR /app


# Dependancies for build
FROM base as dependencies

COPY package*.json ./

RUN npm install && npm cache clean --force


# Build layer
FROM dependencies as build

WORKDIR /app

COPY . /app

RUN npm run prebuild && npm run build


# Release layer build on the top on build layer
FROM node:14-alpine as release

WORKDIR /app

COPY --from=dependencies /app/package.json ./

RUN npm install --only=production && npm cache clean --force

COPY --from=build /app/dist ./dist

EXPOSE 4000
CMD [ "npm", "run", "start:prod" ]
