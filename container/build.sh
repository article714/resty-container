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

apt-get -y install --no-install-recommends openresty openresty-opm

# Install oidc support for Resty

opm install zmartzone/lua-resty-openidc

# Install development tools
apt-get -y install build-essential libreadline-dev

# Install Lua 5.3
apt-get -y install lua5.3

# Install Luarocks
apt-get -y install luarocks

# Install Lua dependencies
luarocks install lua-resty-http
luarocks install lua-resty-session
luarocks install lua-resty-jwt



# NGINX user
addgroup nginx
adduser --system --home /var/www --quiet nginx
adduser nginx syslog

chown -R nginx /container/config/resty
chown -R nginx /usr/local/openresty/nginx
chown -R nginx:nginx /var/cache/nginx

#--
# Cleaning

apt-get -yq clean
apt-get -yq autoremove
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/ci
rm -f tmp/*_dependencies.txt
