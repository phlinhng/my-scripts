#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "must be root user"
    exit 2
fi

apt-get install curl -y

# install docker
curl -sSL https://get.docker.com/ | sh

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

exit 0