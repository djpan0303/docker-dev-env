#v1.0
build.sh: build docker and push to registry

start.sh: 
* pull latest image from registry
* start docker.be noticed that, password must be provided by command arg '-p'. if there's an running container with name ssclient, then it will be shutdown forcefully before starting a new one.

stop.sh: stop container

TODO:
* setup authentication for regsitry
* improve config file usage