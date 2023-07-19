#!/bin/bash
set -e
# set -x

#####################process arg####################################################
helpFunction()
{
   echo ""
   echo "Usage: $0 -r image_id"
   echo -e "\t-r remove image"
   exit 1 # Exit script after printing help
}

while getopts "r:" opt
do
   case "$opt" in
      r ) opt_remove_image="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# https://gist.github.com/jaytaylor/86d5efaddda926a25fa68c263830dac1
REPO_REGISTRY=registry.alittlepig.cc:5000
# Print helpFunction in case parameters are empty
if [ ! -z "$opt_remove_image" ];then
    curl -v -sSL -X DELETE "http://${REPO_REGISTRY}/v2/${opt_remove_image}/manifests/$(
        curl -sSL -I \
            -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
            "http://${REPO_REGISTRY}/v2/${opt_remove_image}/manifests/$(
                curl -sSL "http://${REPO_REGISTRY}/v2/${opt_remove_image}/tags/list" | jq -r '.tags[0]'
            )" \
        | awk '$1 == "Docker-Content-Digest:" { print $2 }' \
        | tr -d $'\r' \
    )"
else 