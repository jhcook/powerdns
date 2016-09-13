#!/bin/bash

# Author: Justin Cook <jhcook@gmail.com>

isMASTER=`grep master /etc/pdns/pdns.conf | awk -F= '{print$2}'`

if [ "$isMASTER" = "yes" ]
then
  if [ ! -f "/etc/pdns/zones/pdns.sqlite3" ]
  then
    sqlite3 /etc/pdns/zones/pdns.sqlite3 < \
    /usr/share/doc/pdns-backend-sqlite-4.0.1/schema.sqlite3.sql
  fi
fi

exec pdns_server --daemon=no
