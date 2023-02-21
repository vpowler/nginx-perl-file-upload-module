FROM nginx:1.23.3-alpine-perl

RUN apk add perl-http-body
RUN mkdir /etc/nginx/perl

ENV UPLOAD_DIR="/tmp/uploads"

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY UploadModule.pm /etc/nginx/perl/UploadModule.pm

RUN nginx -t

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
