#!/bin/bash
set -e
#set -x

#####################process arg####################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 [-l yes|no] [-s yes|no] [-d yes|no]"
   echo -e "\t-l do olog in.defaut:no"
   echo -e "\t-d set up proxy env for local host.defaut:no"
   echo -e "\t-d debug mode.defaut:no"
   exit 1 # Exit script after printing help
}

while getopts "l:s:d:" opt
do
   case "$opt" in
      l ) opt_login="$OPTARG" ;;
      s ) opt_setup_env="$OPTARG" ;;
      d ) opt_debug_mode="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

read -p "Please input password:" opt_passwd

# Print helpFunction in case parameters are empty
if [ -z "$opt_passwd" ];then
   echo "[FATAL] ssclient password must provided";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "do log in:$opt_login"
echo "ssclient password:$opt_passwd"
echo "set up proxy env for local host:$opt_setup_env"
echo "debug mode:$opt_debug_mode"
#####################################################################################
IMAGE_ID="ssclient"

LOG_DIR=/tmp/${IMAGE_ID}
echo "create log dir:$LOG_DIR"
mkdir -p $LOG_DIR

docker pull registry.alittlepig.cc:5000/${IMAGE_ID}

echo "stop exisiting container..."
container_name=$(docker ps -aq --filter name=${IMAGE_ID})
if [ ! -z $container_name ];then
    docker stop $container_name
    docker rm $container_name
fi


TAG=$(cat ${IMAGE_ID}.tag)


function bring_up_container() {
    echo "start new container..."
    
    docker run -dt --restart=always \
        -p 127.0.0.1:8118:8118 \
        --name ${IMAGE_ID} \
        -e SS_PASSWORD=$opt_passwd \
        ${IMAGE_ID}:${TAG}
    
    docker ps -a --no-trunc | grep "${IMAGE_ID}"
}

bring_up_container

if [ "$opt_setup_env" = "yes" ];then
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
fi
# echo "check if container running well..."
# container_running=$(docker ps -aq --filter name=${IMAGE_ID})
# if [ -z "${container_running}" ];then
#     bring_up_container
#     source ${USER_CONFIG_FILE}
# fi

################################verify###########################################################
echo "where am i?waiting for ${IMAGE_ID} bring up"
sleep 10
curl --proxy "http://127.0.0.1:8118" cip.cc
#################################################################################################

echo "log in ? ${opt_login}"
if [ "${opt_login}" = "yes" ];then
    docker exec -it ${IMAGE_ID} bash
fi


