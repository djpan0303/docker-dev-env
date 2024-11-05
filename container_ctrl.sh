#!/bin/bash
set -e
# set -x

source $(dirname $0)/config.sh

function stop() {
    image_id=$1
    check_param_empty $image_id "image_id"
    echo "stop container $image_id"
    docker rm -f $image_id
}

function start() {
    image_id=$1
    check_param_empty $image_id "image_id"
    stop $image_id

    tag_file=$(dirname $0)/$image_id/$TAG_ID_FILE
    tag_id=$(cat $tag_file)
    image_tag=$image_id:$tag_id
    docker pull "$REPO_REGISTRY/$image_tag"
    docker tag "$REPO_REGISTRY/$image_tag" $image_tag
    if [ $image_id = "ubuntu_dev" ];then
      docker run -dt --restart=always --name $image_id $image_tag
    fi

    if [ $image_id = "ssclient" ];then
      # place your config file under /data/conf
      sudo mkdir -p $CONFIG_DIR
      echo "start new container..."
      docker run -dt --restart=always \
          -p 127.0.0.1:8118:8118 \
          --name $image_id \
          -v $CONFIG_DIR:$CONFIG_DIR\
          $image_tag

      
      docker ps -a --no-trunc | grep "$image_id"

      # validate
      echo "where am i?waiting for $image_id bring up"
      sleep 5
      curl --proxy "http://127.0.0.1:8118" cip.cc
    fi
}

function login() {
    image_id=$1
    USER="root"
    check_param_empty $image_id "image_id"  
    docker exec -it -u ${USER} $image_id /bin/bash
}

function test() {
  curl --proxy "http://127.0.0.1:8118" cip.cc
}

while [ "$#" -gt 0 ]
do
  case "$1" in
    --start | --restart)
      stop $2
      start $2
      exit 0
      ;;
    --login)
      login $2
      exit 0
      ;;
    --stop)
      stop $2
      exit 0
      ;;
    --test)
      test $2
      exit 0
      ;;
  esac
  shift
done
