#!/bin/bash



wget -P /opt/davinci/config/ https://raw.githubusercontent.com/hanxianzhai/davinci-docker-rancher/master/datasource_driver.yml

if [ -d "/initdb" ]; then
    rm -rf /initdb/*
elif [ ! -d "/initdb" ]; then
    mkdir -p /initdb
fi

cd /opt/davinci/bin/
cat davinci.sql > /initdb/davinci.sql
sed -i '1i\SET GLOBAL log_bin_trust_function_creators = 1;' /initdb/davinci.sql

set -e

host="$1"
shift
cmd="$@"

until [ $(curl -I -m 10 -o /dev/null -s -w %{size_download} $host) -gt 0 ]; do
  >&2 echo "database is unavailable - sleeping"
  sleep 1
done

source $cmd