set -e
CONTAINER_ID="ubuntu-dev"
container_name=$(docker ps -aq --filter name=${CONTAINER_ID})
if [ ! -z $container_name ];then
    docker stop $container_name
    docker rm $container_name
fi

TAG=$(cat ${CONTAINER_ID}.tag)
docker run -dt  --name ${CONTAINER_ID} --mount type=bind,source=/home/djpan/share,target=/home/djpan/share djpan/${CONTAINER_ID}:${TAG}
docker ps -a | grep "${CONTAINER_ID}"

opt=$1
if [ "${opt}" = "-l" ];then
    docker exec -it ${CONTAINER_ID} bash
fi


