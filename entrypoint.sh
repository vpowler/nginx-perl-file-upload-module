#!/bin/bash
set -e

#sed -i "s/UPLOAD_DIR/$UPLOAD_DIR/g" /etc/nginx/nginx.conf

echo $UPLOAD_DIR > /tmp/1

#mkdir -p $UPLOAD_DIR
#chown nginx $UPLOAD_DIR

exec "$@"
