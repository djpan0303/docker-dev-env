
TAG=$(date +%Y%m%d)
IMAGE_ID="ssclient"
REPO_REGISTRY=registry.alittlepig.cc:5000

set -x

opt_remove_old_image="no"
opt_upload_current_image="no"
opt_use_cache="yes"

#####################process arg####################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 [-r yes|no] [-u yes|no] [-c yes|no]"
   echo -e "\t-r remove old image.defaut:no"
   echo -e "\t-c use cache.defaut:yes"
   echo -e "\t-d upload current image to regsitry server.defaut:no"
   exit 1 # Exit script after printing help
}

while getopts "r:u:c:" opt
do
   case "$opt" in
      r ) opt_remove_old_image="$OPTARG" ;;
      u ) opt_upload_current_image="$OPTARG" ;;
      c ) opt_use_cache="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ "$opt_use_cache" = "no" ];then
   BUILD_ARG="--no-cache"
fi

set -x
if [ "$opt_remove_old_image" = "yes" ];then
    echo "remove old images"
    docker stop ${IMAGE_ID}
    docker image ls | grep ${IMAGE_ID} | grep -v ${TAG} | awk '{print $3}' | uniq | xargs -r docker image rm -f   
fi

docker build $BUILD_ARG -t ${IMAGE_ID}:${TAG} .
echo ${TAG} > ${IMAGE_ID}.tag

if [ $? -ne 0 ];then
   echo "build image fail"
fi

if [ "$opt_upload_current_image" = "yes" ];then
    docker tag ${IMAGE_ID}:${TAG} ${REPO_REGISTRY}/${IMAGE_ID}:${TAG}
    docker push ${REPO_REGISTRY}/${IMAGE_ID}:${TAG}
    docker tag ${IMAGE_ID}:${TAG} ${REPO_REGISTRY}/${IMAGE_ID}:latest
    docker push ${REPO_REGISTRY}/${IMAGE_ID}:latest
fi