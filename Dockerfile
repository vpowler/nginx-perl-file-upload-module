FROM nginx:1.23.3-alpine-perl

RUN nginx -t

RUN apk add perl-http-body

RUN mkdir /etc/nginx/perl

COPY UploadModule.pm /etc/nginx/perl/UploadModule.pm
COPY uploads.conf /etc/nginx/conf.d/uploads.conf
