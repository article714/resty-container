#!/bin/bash

#set -x

apt-get update

# Generate French locales
localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8

export LANG=en_US.utf8

# Install basic needed packages
LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends wget gnupg ca-certificates runit rsyslog logrotate

# Install Resty from pre-built packages

wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -

codename=$(grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release)
echo "deb http://openresty.org/package/debian $codename openresty" | tee /etc/apt/sources.list.d/openresty.list

apt-get update
apt-get upgrade -yq

# Install Openresty and Lua 5.3
apt-get -y install openresty openresty-resty lua5.3 unzip 


# Install development tools
apt-get -y install build-essential libreadline-dev liblua5.3-dev

# Install Luarocks
cd /tmp
wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz
tar zxpf luarocks-3.3.1.tar.gz
cd luarocks-3.3.1
./configure --with-lua-include=/usr/include
make install

# Temporary solution for some files
opm install zmartzone/lua-resty-openidc

# Install Lua dependencies for openidc & jwt
/usr/local/bin/luarocks install lua-resty-http
/usr/local/bin/luarocks install lua-resty-session
/usr/local/bin/luarocks install lua-resty-jwt
/usr/local/bin/luarocks install lua-resty-openidc

# NGINX user
addgroup nginx
adduser --system --home /var/www --quiet nginx
adduser nginx syslog

chown -R nginx /container/config/resty
chown -R nginx /usr/local/openresty/nginx
chown -R nginx:nginx /var/cache/nginx

#--
# Cleaning

apt-get purge -yq gcc  build-essential libreadline-dev liblua5.3-dev
apt-get -yq clean
apt-get -yq autoremove
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
