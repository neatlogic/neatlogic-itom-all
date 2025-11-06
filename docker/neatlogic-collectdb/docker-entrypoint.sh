#!/bin/bash
set -e

NEED_INITDB=1
# /data/db数据持久化目录
if [[ -f "/data/db/.init" ]]; then
  NEED_INITDB=0
fi 

if [[ $NEED_INITDB == 1 ]]; then
  mkdir -p /data/configdb/mongodb/
  touch /data/configdb/mongodb/mongod.log
  nohup mongod --replSet autoexec-rs --bind_ip_all  --logpath /data/configdb/mongodb/mongod.log &

  until mongosh --eval "db.adminCommand('ping')" &>/dev/null; do
      echo "Waiting for MongoDB to start..."
      sleep 2
  done

  #if ! mongosh --eval "rs.status()" &>/dev/null; then
  #    echo "Initializing replica set..."
  #    echo "Running docker-entrypoint-initdb.d/$f..."
  #    mongosh docker-entrypoint-initdb.d/00_initiate.js
  #fi

  INITDB_D=/docker-entrypoint-initdb.d
  for f in $INITDB_D/*.js; do
      [ -e "$f" ] || continue
      echo "Running $f..."
      ret=`mongosh "$f"`
      if [ $? -ne 0 ]; then
        echo 'Failed to execute init file:' $ret
      fi
  done
  echo '1' > /data/db/.init

  mongod --shutdown --dbpath /data/db
fi

cp -f /data/configdb/mongodb.conf.rs /data/configdb/mongodb.conf

exec $@
