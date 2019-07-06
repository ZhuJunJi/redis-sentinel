# MASTER_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis_master)
MASTER_IP=`docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 SENTINEL get-master-addr-by-name mymaster | head -1`
SLAVE_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis_slave_1)
SENTINEL_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis_sentinel_1)
MASTER_CONTAINER_NAME=`docker network inspect bridge| grep -B 5 "$MASTER_IP/" | grep Name | awk -F"\"" '{print $4}'`

echo Redis master: $MASTER_IP $MASTER_CONTAINER_NAME
echo Redis Slave_1: $SLAVE_IP
echo Redis Slave_2: $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis_slave_2)
echo ------------------------------------------------
echo Initial status of sentinel
echo ------------------------------------------------
docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 info Sentinel
echo Current master is
docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 SENTINEL get-master-addr-by-name mymaster
echo ------------------------------------------------

echo Stop redis master $MASTER_IP $MASTER_CONTAINER_NAME
docker pause $MASTER_CONTAINER_NAME
echo Wait for 10 seconds
sleep 10
echo Current infomation of sentinel
docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 info Sentinel
echo Current master is
docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 SENTINEL get-master-addr-by-name mymaster


echo ------------------------------------------------
echo Restart Redis master $MASTER_IP $MASTER_CONTAINER_NAME
docker unpause $MASTER_CONTAINER_NAME
sleep 5
echo Current infomation of sentinel
docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 info Sentinel
echo Current master is
docker exec redis_sentinel_1 redis-cli -p 26379 -a 123456 SENTINEL get-master-addr-by-name mymaster
