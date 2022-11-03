FROM --platform=linux/amd64 node:16.18-alpine AS assets-build

RUN npm install hexo-cli -g

WORKDIR /var/www/html
COPY . /var/www/html/

RUN npm ci
RUN hexo generate

FROM --platform=linux/amd64 nginx:1.23-alpine
COPY --from=assets-build /var/www/html/public /usr/share/nginx/html
