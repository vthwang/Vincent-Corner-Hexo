FROM --platform=linux/amd64 nginx:1.23-alpine
COPY ./public /usr/share/nginx/html
