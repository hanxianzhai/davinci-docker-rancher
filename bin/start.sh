#!/bin/bash

:<<!
if [ ! -d "/opt/davinci" ]; then
    cp -a /usr/src/davinci /opt/
fi
if [ -z "$(ls -A "/opt/davinci/")" ]; then
    cp -a /usr/src/davinci/* /opt/davinci/
fi

if [ "`ls -A $DIRECTORY`" = "" ]; then
    rm -rf /opt/davinci/*
    cp -a /usr/src/davinci/* /opt/davinci/
fi
!
if [ ! -d "/initdb" ]; then
    mkdir -p /initdb
elif [ ! -f "/initdb/davinci.sql" ]; then
    cat /usr/src/davinci/bin/davinci.sql > /initdb/davinci.sql
    sed -i '1i\SET GLOBAL log_bin_trust_function_creators = 1;' /initdb/davinci.sql
fi
if [ ! -d "/opt/davinci" ]; then
    cp -a /usr/src/davinci /opt/
else 
    rm -rf /opt/davinci/*
    cp -a /usr/src/davinci/* /opt/davinci/
fi

wget -P /usr/src/davinci/config/ https://raw.githubusercontent.com/hanxianzhai/davinci-docker-rancher/master/datasource_driver.yml

set -e
host="$1"
shift
cmd="$@"


until [ $(curl -I -m 10 -o /dev/null -s -w %{size_download} $host) -gt 0 ]; do
  >&2 echo "database is unavailable - sleeping"
  sleep 1
done

source $cmd