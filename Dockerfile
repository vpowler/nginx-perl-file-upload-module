FROM nginx:1.23.3-alpine-perl

RUN apk add perl-http-body
RUN mkdir /etc/nginx/perl

COPY uploads.conf /etc/nginx/conf.d/uploads.conf
COPY UploadModule.pm /etc/nginx/perl/UploadModule.pm

RUN nginx -t

