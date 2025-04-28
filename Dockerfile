ARG NODE_TAG=22.15-alpine
ARG NGINX_TAG=1.28-alpine

FROM node:${NODE_TAG} AS restore
WORKDIR /app
COPY ["package.json", "."]
COPY ["package-lock.json", "."]
RUN npm ci

FROM node:${NODE_TAG} AS build
WORKDIR /app
COPY --from=restore /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM nginx:${NGINX_TAG} AS final
WORKDIR /usr/share/nginx/html
COPY --from=build /app/dist .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
