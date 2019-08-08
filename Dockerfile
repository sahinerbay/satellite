FROM node:10-alpine AS build
WORKDIR /app/satellite
ENV PATH /app/satellite/node_modules/.bin:$PATH
ENV CI=true
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine AS dev 
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/satellite/build /usr/share/nginx/html
EXPOSE 80
CMD nginx -g 'daemon off;'

FROM hashicorp/terraform:light AS prod 
WORKDIR /home/satellite
COPY --from=build /app/satellite/build .
WORKDIR /home/satellite/tf 
COPY tf .