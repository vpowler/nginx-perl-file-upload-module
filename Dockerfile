FROM nginx:1.23.3-alpine-perl

RUN apk add perl-http-body
RUN mkdir /etc/nginx/perl

COPY nginx.conf /etc/nginx/nginx.conf
COPY UploadModule.pm /etc/nginx/perl/UploadModule.pm

RUN nginx -t

