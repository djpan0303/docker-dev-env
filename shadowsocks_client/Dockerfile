FROM ubuntu:22.04

RUN apt update && apt install curl -y \
            && apt install vim -y \
            && apt install systemctl -y \
            && apt install python2.7 -y \
            && apt install privoxy -y \
            && echo "forward-socks5t   /               127.0.0.1:1080 ." >> /etc/privoxy/config \
            && sed -i "s/listen-address  127.0.0.1:8118/listen-address  0.0.0.0:8118/g" /etc/privoxy/config


RUN mkdir -p /data/conf && mkdir -p /data/bin/

COPY shadowsocks/shadowsocksR.zip shadowsocks/shadowsocksR.json shadowsocks/shadowsocks.zip shadowsocks/shadowsocks.json /data/
RUN cd /data/ && apt update && apt install zip -y\
    && mv shadowsocksR.json conf && unzip shadowsocksR.zip && rm -f shadowsocksR.zip\
    && mv shadowsocks.json conf && unzip shadowsocks.zip && rm -f shadowsocks.zip

COPY shadowsocks/start_service.sh /data/bin/

# ENV SS_TYPE=shadowsocksR
# CMD ["sh","-c","systemctl restart privoxy;python2.7", "/data/${SS_TYPE}/shadowsocks/local.py -c /data/conf/${SS_TYPE}.json"]
ENTRYPOINT [ "/data/bin/start_service.sh" ]
CMD [ "shadowsocksR" ]