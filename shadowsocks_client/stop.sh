set -e
set -x
CONTAINER_ID="ssclient"
container_name=$(docker ps -aq --filter name=${CONTAINER_ID})
if [ ! -z $container_name ];then
    docker stop $container_name && docker rm $container_name
fi

DOCKER_CONFIG_FILE=/etc/systemd/system/docker.service.d/http-proxy.conf
if [ -e $DOCKER_CONFIG_FILE ];then
    sudo sed -i '/HTTP_PROXY=http/d' $DOCKER_CONFIG_FILE
    sudo sed -i '/HTTPS_PROXY=http/d' $DOCKER_CONFIG_FILE
    sudo sed -i '/\[Service\]/d' $DOCKER_CONFIG_FILE
    sudo systemctl daemon-reload
    sudo systemctl restart docker
fi

USER_CONFIG_FILE=~/.bashrc
if [ -e $USER_CONFIG_FILE ];then
    sed -i '/export http_proxy=/d' $USER_CONFIG_FILE
    sed -i '/export https_proxy=/d' $USER_CONFIG_FILE
    source ${USER_CONFIG_FILE}
fi


