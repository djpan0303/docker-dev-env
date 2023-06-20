set -x
TAG=$(date +%Y%m%d)
CONTAINER_ID="ssclient"

BUILD_ARGS=$*

docker build $BUILD_ARGS -t djpan/${CONTAINER_ID}:${TAG} .
echo ${TAG} > ${CONTAINER_ID}.tag

echo "remove old images"
docker image ls | grep ${CONTAINER_ID} | grep -v ${TAG} | awk '{print $3}' | uniq | xargs -r docker image rm -f
