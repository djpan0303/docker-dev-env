# Docker Setup

开始前务必保证两件事：
+ 设置好域名解析，将registry.tinybear.cc解析到registry server所在的服务器IP
+ 不论是推送构建好的镜像还是拉取镜像，需要设置号/etc/docker/daemon.json,在其中加入如下配置：
```
{
  "registry-mirrors": ["https://docker.mirrors.ustc.edu.cn"],
  "insecure-registries": ["registry.tinybear.cc:5000"]
}
```

搭建registry时docker pull拉取官方镜像可能会拉取失败，需要设置docker代理。
sudo mkdir -p /etc/systemd/system/docker.service.d
vim /etc/systemd/system/docker.service.d/http-proxy.conf
添加如下内容：
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:8118"
Environment="HTTPS_PROXY=http://127.0.0.1:8118"
Environment="NO_PROXY=localhost,127.0.0.1"

然后执行如下命令：
sudo systemctl daemon-reload
sudo systemctl restart docker

用如下命令检查代理是否设置正确：
sudo systemctl show --property=Environment docker

[如何优雅的给 Docker 配置网络代理](https://www.cnblogs.com/Chary/p/18096678)

# Registry Server

deploy and start registry server
```
registry_ctrl --start_server
```
启动服务器后，浏览器上打开tinybear.cc:8080可以看到当前仓库中的镜像。

stop registry server
```
registry_ctrl --stop_server
```


# Image
新增image，需要在container_ctrl.sh的start函数匹配对应的docker启动
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