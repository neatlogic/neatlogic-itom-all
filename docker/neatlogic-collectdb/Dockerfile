FROM mongodb/mongodb-community-server:7.0.24-rc0-ubuntu2204

LABEL maintainer="neatlogic"
LABEL version="NeatLogic Databases 1.0.0" \
  description="NeatLogic ITOM 3.0.0"

ENV MONGO_INITDB_ROOT_USERNAME=admin
ENV MONGO_INITDB_ROOT_PASSWORD=u1OPgeInMhxsNkNl

# 初始化脚本目录
COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
COPY mongodb.conf /data/configdb/mongodb.conf
COPY mongodb.conf.rs /data/configdb/mongodb.conf.rs
COPY keyfile /data/configdb/keyfile
COPY docker-entrypoint.sh /docker-entrypoint.sh
USER root
#添加域名解析,否则neatlogic-collectdb无法解析
#COPY hosts /etc/hosts 
RUN chmod 600 /data/configdb/keyfile \
  && chown mongodb:mongodb  /data/configdb/keyfile \
  && mkdir -p /data/db \
  && chown -R mongodb:mongodb /data/db /docker-entrypoint-initdb.d \
  && chmod +x /docker-entrypoint.sh \
  && chown mongodb:mongodb /docker-entrypoint.sh
USER mongodb
EXPOSE 27017

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mongod", "--config", "/data/configdb/mongodb.conf"]
