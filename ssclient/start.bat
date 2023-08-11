$IMAGE_ID="ssclient"
docker pull registry.alittlepig.cc:5000/$IMAGE_ID
docker tag registry.alittlepig.cc:5000/$IMAGE_ID $IMAGE_ID:latest

Write-Host "stop exisiting container..."

docker stop $IMAGE_ID

$opt_passwd= Read-Host -Prompt "please enter password:"

docker run -dt --rm --restart=always -p 127.0.0.1:8118:8118 --name $IMAGE_ID -e SS_PASSWORD=$opt_passwd $IMAGE_ID:latest shadowsocks



