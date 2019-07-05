### docker-compose 构建redis sentinel redis_master、redis_slave_1、redis_slave_2、redis_sentinel_1、redis_sentinel_2、redis_sentinel_3

docker-compose.yml 

```
master:
  image: docker.io/redis
  container_name: redis_master
  ports:
    - 6379:6379

slave1:
  image: docker.io/redis
  container_name: redis_slave_1
  command: redis-server --port 6380:6379 --slaveof redis-master 6379
  ports:
    - 6380:6379
  links:
    - master:redis-master

slave2:
  image: docker.io/redis
  container_name: redis_slave_2
  command: redis-server --port 6381:6379 --slaveof redis-master 6379
  ports:
    - 6381:6379
  links:
    - master:redis-master

sentinel1:
  image: redis_sentinel
  container_name: redis_sentinel_1
  ports:
    - 26379:26379
  command: redis-sentinel --port 26379:26379
  environment:
    - SENTINEL_DOWN_AFTER=5000
    - SENTINEL_FAILOVER=5000
  links:
    - master:redis-master
    - slave1
    - slave2

sentinel2:
  image: redis_sentinel
  container_name: redis_sentinel_2
  ports:
    - 26380:26379
  command: redis-sentinel --port 26380:26379
  environment:
    - SENTINEL_DOWN_AFTER=5000
    - SENTINEL_FAILOVER=5000
  links:
    - master:redis-master
    - slave1
    - slave2

sentinel3:
  image: redis_sentinel
  container_name: redis_sentinel_3
  ports:
    - 26381:26379
  command: redis-sentinel --port 26381:26379
  environment:
    - SENTINEL_DOWN_AFTER=5000
    - SENTINEL_FAILOVER=5000
  links:
    - master:redis-master
    - slave1
    - slave2
```

#### sentinel目录下执行 docker build -t redis_sentinel . 构建 redis_sentinel 镜像

```
docker build -t redis_sentinel .
```

#### docker-compose.yml 目录下执行 docker-compose up -d 后台启动容器

```
docker-compose up -d
```

#### 执行test.sh 查看结果是否搭建成功

```
Redis master: 172.17.0.2
Redis Slave: 172.17.0.3
------------------------------------------------
Initial status of sentinel
------------------------------------------------
# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=172.17.0.2:6379,slaves=2,sentinels=3
Current master is
172.17.0.2
6379
------------------------------------------------
Stop redis master
redis_master
Wait for 10 seconds
Current infomation of sentinel
# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=172.17.0.4:6381,slaves=2,sentinels=3
Current master is
172.17.0.4
6381
------------------------------------------------
```

