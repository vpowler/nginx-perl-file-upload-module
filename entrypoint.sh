#!/bin/sh
set -e

sed -i "s/UPLOAD_DIR/$UPLOAD_DIR/g" /etc/nginx/nginx.conf

mkdir -p $UPLOAD_DIR
chown nginx $UPLOAD_DIR

exec "$@"
