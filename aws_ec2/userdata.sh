#!/bin/bash

sudo apt update && apt upgrade -y

sudo apt install python3

sudo apt install ntpdate
sudo apt install -y ntp
/etc/init.d/ntp stop
ntpdate pool.ntp.org
/etc/init.d/ntp start

sudo apt install openvpn easy-rsa