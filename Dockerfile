FROM nginx:1.23.3-alpine-perl

RUN apk add perl-http-body
RUN mkdir /etc/nginx/perl

ENV UPLOAD_DIR="/tmp/uploads"
RUN mkdir -p $UPLOAD_DIR

COPY nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/UPLOAD_DIR/$UPLOAD_DIR/g" /etc/nginx/nginx.conf

COPY UploadModule.pm /etc/nginx/perl/UploadModule.pm

RUN nginx -t
