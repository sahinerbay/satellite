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

FROM alpine:3.7 AS prod
RUN apk add --update \
    wget unzip && \
    wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip && \
    unzip ./terraform_0.12.2_linux_amd64.zip -d /usr/local/bin/ 
ENV AWSCLI_VERSION "1.16.116"
RUN apk add python \
    python-dev \
    py-pip \
    build-base \
    curl \
    && pip install --upgrade pip \
    && pip install awscli==$AWSCLI_VERSION --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/* 
ENV PATH="/root/.local/bin:${PATH}"
ENTRYPOINT ["/bin/sh", "-c"]