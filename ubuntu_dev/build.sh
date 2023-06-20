TAG=$(date +%Y%m%d)
CONTAINER_ID="ubuntu-dev"
docker build -t djpan/${CONTAINER_ID}:${TAG} .
echo ${TAG} > ${CONTAINER_ID}.tag
