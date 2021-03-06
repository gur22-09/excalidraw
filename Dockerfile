FROM node:14-alpine AS build

WORKDIR /opt/node_app

COPY package.json package-lock.json ./
RUN npm i --no-optional

ARG REACT_APP_INCLUDE_GTAG=false
ARG NODE_ENV=production

COPY . .
RUN npm run build:app:docker

FROM nginx:1.17-alpine

COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
