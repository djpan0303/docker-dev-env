# Registry

开始前务必保证两件事：
+ 设置好域名解析，将registry.tinybear.cc解析到registry server所在的服务器IP
+ 不论是推送构建好的镜像还是拉取镜像，需要设置号/etc/docker/daemon.json,在其中加入如下配置：
```
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"],
  "insecure-registries": ["registry.tinybear.cc:5000"]
}
```

deploy and start registry server
```
registry_ctrl --start_server
```
stop registry server
```
registry_ctrl --stop_server
```

# Image
build image without removing old image of current date
```
image_ctrl.sh --build ssclient
```

build image and remove old image of current date
```
image_ctrl.sh --cbuild ssclient
```

push image to registry server
```
image_ctrl.sh --push ssclient
```

# Container
start local container
```
container_ctrl.sh --start ssclient
```

stop local container
```
container_ctrl.sh --stop ssclient
```

log in local container
```
container_ctrl.sh --login ssclient
```