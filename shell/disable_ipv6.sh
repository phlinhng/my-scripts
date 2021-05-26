#!/bin/bash

# usgae: bash disable_ipv6.sh eth0

main_interface=%1

sysctl -w "net.ipv6.conf.${main_interface}.disable_ipv6=1" # change enp0s1f6 to your main interface i.e. eth0
echo "net.ipv6.conf.${main_interface}.disable_ipv6=1" | tee -a /etc/sysctl.conf # save sysctl conf
echo "precedence ::ffff:0:0/96  100" | tee -a /etc/gai.conf # disable ipv6 dns record

exit
