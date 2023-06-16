sudo mkdir -p /data/registry && sudo chown -R djpan:djpan /data/registry

docker run -d \
    -p 5000:5000 \
    -v /data/registry:/var/lib/registry \
    registry