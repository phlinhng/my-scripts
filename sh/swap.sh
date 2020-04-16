#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "must be root user"
    exit 2
fi

# allocate space
fallocate -l 1G /swapfile

# set permission
chmod 600 /swapfile

# make swap
mkswap /swapfile

# enable swap
swapon /swapfile

# make swap permanent
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

# set swap percentage
sysctl vm.swappiness=10
echo "vm.swappiness=10" >> /etc/sysctl.conf

free -h

exit 0