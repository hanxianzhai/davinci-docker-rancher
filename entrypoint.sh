#!/bin/bash

if [ ! -d "/opt/davinci" ]; then
    cp -a /usr/src/davinci /opt/
fi
if [ -z "$(ls -A "/opt/davinci/")" ]; then
    cp -a /usr/src/davinci/* /opt/davinci/
fi
if [ -d "/initdb" ]; then
    mkdir -p /initdb
fi
if [ ! -f "/initdb/davinci.sql" ]; then
    cat /usr/src/davinci/bin/davinci.sql > /initdb/davinci.sql
    sed -i '1i\SET GLOBAL log_bin_trust_function_creators = 1;' /initdb/davinci.sql
fi

set -e
host="$1"
shift
cmd="$@"


until [ $(curl -I -m 10 -o /dev/null -s -w %{size_download} $host) -gt 0 ]; do
  >&2 echo "database is unavailable - sleeping"
  sleep 1
done

source $cmd