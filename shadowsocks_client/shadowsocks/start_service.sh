#!/bin/bash
SS_TYPE=$1
LOG_DIR=/tmp/ssclient/run.log
# mkdir -p /tmp/ssclient
touch $LOG_DIR

if [ "$SS_PASSWORD" = "" ];then
    echo "no password in env.please specify env SS_PASSWORD" >> $LOG_DIR
    exit 1
fi


echo "type:$SS_TYPE" >> $LOG_DIR
systemctl restart privoxy
if [ $? != 0 ];then
    echo "start privoxy fail"
    exit 1
fi

sed -i "s/\"password\": \"\",/\"password\": \"$SS_PASSWORD\",/g" /data/conf/${SS_TYPE}.json

ps aux | grep python |grep shadowsocksR | awk '{print $2}' | xargs -r kill -9
python2.7 /data/$SS_TYPE/shadowsocks/local.py -c /data/conf/${SS_TYPE}.json 2>$LOG_DIR

tail