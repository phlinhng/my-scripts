#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "must be root user"
    exit 2
fi

apt-get install curl -y

# install docker
curl -sSL https://get.docker.com/ | sh

# run mtg
docker run --name mtg --restart=always -p 443:3128 -d nineseconds/mtg:latest run eedd89dec049fd36851360d6cfd7bfda8c74766178342e73696e61696d672e636e

exit 0