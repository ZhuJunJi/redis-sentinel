#!/bin/sh

sed -i "s/\$SLAVE_REQUIREPASS/$SLAVE_REQUIREPASS/g" /etc/redis/redis.conf
sed -i "s/\$SLAVE_MASTER_AUTH/$SLAVE_MASTER_AUTH/g" /etc/redis/redis.conf

exec docker-entrypoint.sh redis-server /etc/redis/redis.conf
