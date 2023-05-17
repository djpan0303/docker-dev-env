container_name=$(docker ps -aq --filter name=ubuntu)
if [ ! -z $container_name ];then
    docker stop $container_name
    docker rm $container_name
fi

docker run -dt  --name ubuntu --mount type=bind,source=/home/djpan/share,target=/home/djpan/share djpan/ubuntu


