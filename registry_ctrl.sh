#!/bin/bash
set -e
# set -x

#####################process arg####################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 -r image_id:tag -l image_id"
   echo "-r remove image"
   echo "-l list image tag list"
   exit 1 # Exit script after printing help
}

while getopts "r:l:" opt
do
   case "$opt" in
      r ) opt_remove_image="$OPTARG" ;;
      l ) opt_list_image="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done


# https://gist.github.com/jaytaylor/86d5efaddda926a25fa68c263830dac1
REPO_REGISTRY=registry.alittlepig.cc:5000
# Print helpFunction in case parameters are empty
if [ ! -z "$opt_remove_image" ];then
    image_id=$(echo $opt_remove_image | cut -d ':' -f 1)
    tag_id=$(echo $opt_remove_image | cut -d ':' -f 2)
    curl -v -sSL -X DELETE "http://${REPO_REGISTRY}/v2/${image_id}/manifests/$(
        curl -sSL -I \
            -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
            "http://${REPO_REGISTRY}/v2/${image_id}/manifests/${tag_id}" \
        | awk '$1 == "Docker-Content-Digest:" { print $2 }' \
        | tr -d $'\r' \
    )"
fi

if [ ! -z "$opt_list_image" ];then
    echo "list $opt_list_image tag list"
    curl -sSL "http://registry.alittlepig.cc:5000/v2/ssclient/tags/list" | jq
fi