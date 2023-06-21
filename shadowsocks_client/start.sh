#!/bin/bash
set -e
# set -x

#####################process arg####################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 -l [yes|no] -p Password"
   echo -e "\t-l do olog in"
   echo -e "\t-p ssclient password"
   exit 1 # Exit script after printing help
}

while getopts "l:p:" opt
do
   case "$opt" in
      l ) opt_login="$OPTARG" ;;
      p ) opt_passwd="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$opt_passwd" ];then
   echo "[FATAL] ssclient password must provided";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "do log in:$opt_login"
echo "ssclient password:$opt_passwd"
#####################################################################################
CONTAINER_ID="ssclient"

LOG_DIR=/tmp/${CONTAINER_ID}
echo "create log dir:$LOG_DIR"
mkdir -p $LOG_DIR

echo "stop exisiting container..."
container_name=$(docker ps -aq --filter name=${CONTAINER_ID})
if [ ! -z $container_name ];then
    docker stop $container_name
    docker rm $container_name
fi


function bring_up_container() {
    echo "start new container..."
    TAG=$(cat ${CONTAINER_ID}.tag)
    docker run -dt \
        -p 127.0.0.1:8118:8118 \
        --name ${CONTAINER_ID} \
        -e SS_PASSWORD=$opt_passwd \
        -v $LOG_DIR:$LOG_DIR \
        djpan/${CONTAINER_ID}:${TAG}
    
    docker ps -a --no-trunc | grep "${CONTAINER_ID}"
}


##################################setup system proxy#############################################
USER_CONFIG_FILE=~/.bashrc
bashrc_setup=$(grep http_proxy ${USER_CONFIG_FILE} | head -n 1)
if [ "$bashrc_setup" = "" ];then
    cat ${USER_CONFIG_FILE} > /tmp/bashrc.tmp
    echo "export http_proxy=http://127.0.0.1:8118" >> /tmp/bashrc.tmp
    echo "export https_proxy=http://127.0.0.1:8118" >> /tmp/bashrc.tmp
    mv /tmp/bashrc.tmp ${USER_CONFIG_FILE}
    source ${USER_CONFIG_FILE}
fi
#####################################################################################################


#################################setup docker proxy###############################################

DOCKER_CONFIG_FILE=/etc/systemd/system/docker.service.d/http-proxy.conf

if [ ! -e $DOCKER_CONFIG_FILE ];then
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo touch $DOCKER_CONFIG_FILE && sudo chmod 777 $DOCKER_CONFIG_FILE
    echo "
[Service]
Environment=\"HTTP_PROXY=http://127.0.0.1:8118\"
Environment=\"HTTPS_PROXY=http://127.0.0.1:8118\"" > $DOCKER_CONFIG_FILE
sudo systemctl daemon-reload
sudo systemctl restart docker
else
    docker_setup=$(grep HTTP_PROXY ${DOCKER_CONFIG_FILE} | head -n 1)
    if [ "${docker_setup}" = "" ];then
    echo "
[Service]
Environment=\"HTTP_PROXY=http://127.0.0.1:8118\"
Environment=\"HTTPS_PROXY=http://127.0.0.1:8118\"" >> $DOCKER_CONFIG_FILE
sudo systemctl daemon-reload
sudo systemctl restart docker
    fi
fi
##################################################################################################

echo "check if container running well..."
container_running=$(docker ps -aq --filter name=${CONTAINER_ID})
if [ -z "${container_running}" ];then
    bring_up_container
fi

################################verify###########################################################
echo "where am i?waiting container bring up"
sleep 10
curl cip.cc
#################################################################################################

echo "log in ? ${opt_login}"
if [ "${opt_login}" = "yes" ];then
    docker exec -it ${CONTAINER_ID} bash
fi


