FROM docker.io/redis

MAINTAINER Zhu Jun Ji <zhujunji90s@gmail.com>

EXPOSE 6379
ADD redis.conf /etc/redis/redis.conf
RUN chown redis:redis /etc/redis/redis.conf
ENV SLAVE_REQUIREPASS 123456
ENV SLAVE_MASTER_AUTH 123456
COPY slave-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/slave-entrypoint.sh
ENTRYPOINT ["slave-entrypoint.sh"]
