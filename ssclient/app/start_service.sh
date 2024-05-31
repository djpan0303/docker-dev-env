#!/bin/bash
set -x
APP_TYPE=$1

systemctl start privoxy

cp /data/app/ssr_example.json /data/conf

python2.7 /data/app/$APP_TYPE/shadowsocks/local.py -c /data/conf/${APP_TYPE}.json >/dev/null 2>&1

tail