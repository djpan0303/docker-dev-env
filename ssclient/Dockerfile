FROM ubuntu:22.04

RUN mkdir -p /data/log

RUN apt update && apt install curl -y \
            && apt install vim -y \
            && apt install systemctl -y \
            && apt install python2.7 -y \
            && apt install privoxy -y \
    && apt -y install curl \
    && apt -y install net-tools \
            && echo "forward-socks5t   /               127.0.0.1:1080 ." >> /etc/privoxy/config \
            && sed -i "s/listen-address  127.0.0.1:8118/listen-address  0.0.0.0:8118/g" /etc/privoxy/config

COPY ss_package /data/ss_package

# RUN apt install -y procps && \
#     sysctl -w net.ipv6.conf.all.disable_ipv6=0 \
#     && sysctl -w net.ipv6.conf.default.disable_ipv6=0 \
#     && sysctl -w net.ipv6.conf.lo.disable_ipv6=0 \
#     sysctl -p



ENTRYPOINT [ "/data/ss_package/start_service.sh" ]
CMD [ "shadowsocksR" ]