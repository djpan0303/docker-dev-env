REPO_REGISTRY=registry.tinybear.cc:5000
CONFIG_DIR="/data/conf"
TAG_ID_FILE="tag_id.txt"
REPO_DIR=$HOME/registry

function check_param_empty() {
    param_value=$1
    param_name=$2
    if [ -z "$param_value" ];then
        echo "$param_name is empty"
        exit 1
    fi
}
