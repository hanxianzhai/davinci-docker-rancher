#!/bin/bash


directory_empty() {
    [ -z "$(ls -A "$1/")" ]
}


if [ ! -d "/opt/davinci" ]; then
    cp -a /usr/src/davinci /opt/
fi
if [ directory_empty "/opt/davinci" ]; then
    cp -a /usr/src/davinci/* /opt/davinci/
fi
if [ ! -f "/initdb/davinci.sql" ]; then
    cat /usr/src/davinci/bin/davinci.sql > /initdb/davinci.sql
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