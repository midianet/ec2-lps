docker run --privileged --name docker-dind  \
    -v ./daemon.json:/etc/docker/daemon.json \
    -e DOCKER_TLS_CERTDIR="" \
    -it docker:stable-dind
