#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  sudoCmd="sudo"
else
  sudoCmd=""
fi

# allocate space
${sudoCmd} fallocate -l 1G /swapfile

# set permission
${sudoCmd} chmod 600 /swapfile

# make swap
${sudoCmd} mkswap /swapfile

# enable swap
${sudoCmd} swapon /swapfile

# make swap permanent
printf "/swapfile swap swap defaults 0 0" | ${sudoCmd} tee -a /etc/fstab  >/dev/null

# set swap percentage
${sudoCmd} sysctl vm.swappiness=10
printf "vm.swappiness=10" | ${sudoCmd} tee -a /etc/sysctl.conf >/dev/null

free -h

exit 0