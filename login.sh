CONTAINER_ID="ubuntu-dev"
USER="djpan"
if [ "$1" = "-u" ];then
    USER=$2
fi

docker exec -it -u ${USER} ${CONTAINER_ID} bash
