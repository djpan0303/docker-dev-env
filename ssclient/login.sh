IMAGE_ID="ssclient"
USER="root"
if [ "$1" = "-u" ];then
    USER=$2
fi

docker exec -it -u ${USER} ${IMAGE_ID} bash