set -x
TAG=$(date +%Y%m%d)
IMAGE_ID="ssclient"
REPO_REGISTRY=registry.alittlepig.cc:5000

set -x

opt_remove_old_image="no"
opt_upload_current_image="no"

#####################process arg####################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 [-r yes|no] [-u yes|no]"
   echo -e "\t-r remove old image.defaut:no"
   echo -e "\t-d upload current image to regsitry server.defaut:no"
   exit 1 # Exit script after printing help
}

while getopts "r:u:" opt
do
   case "$opt" in
      r ) opt_remove_old_image="$OPTARG" ;;
      u ) opt_upload_current_image="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done


docker build -t ${IMAGE_ID}:${TAG} .
echo ${TAG} > ${IMAGE_ID}.tag


if [ "$opt_remove_old_image" = "yes" ];then
    echo "remove old images"
    docker image ls | grep ${IMAGE_ID} | grep -v ${TAG} | awk '{print $3}' | uniq | xargs -r docker image rm -f   
fi

if [ "$opt_upload_current_image" = "yes" ];then
    docker tag ${IMAGE_ID}:${TAG} ${REPO_REGISTRY}/${IMAGE_ID}:${TAG}
    docker push ${REPO_REGISTRY}/${IMAGE_ID}:${TAG}
    docker tag ${IMAGE_ID}:${TAG} ${REPO_REGISTRY}/${IMAGE_ID}:latest
    docker push ${REPO_REGISTRY}/${IMAGE_ID}:latest
fi