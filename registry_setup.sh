REPO_DIR=/home/djpan/registry
mkdir -p $REPO_DIR

docker stop registry-srv
docker rm registry-srv
docker stop registry-web
docker rm registry-web

docker run -d --restart=always \
    --name=registry-srv\
    -p 5000:5000 \
    -e REGISTRY_STORAGE_DELETE_ENABLED=true\
    -v $REPO_DIR:/var/lib/registry \
    registry

# -e REGISTRY_READONLY=false\
docker run -dt --restart=always \
    --name registry-web \
    -p 8080:8080 \
    --link registry-srv\
    -e REGISTRY_URL=http://registry-srv:5000/v2 \
    -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web