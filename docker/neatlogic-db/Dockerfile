FROM mysql:8.0.43

LABEL maintainer="neatlogic organization" \
  version="NeatLogic Databases 1.0.0" \
  description="NeatLogic ITOM 3.0.0"

ARG MYSQL_ROOT_PASSWORD
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-neatlogic@901}

ENV NEATLOGIC_RUNNER_HOST=neatlogic-runner \
  LANG=en_US.utf8 \
  LC_ALL=en_US.utf8

# 初始化 SQL/脚本目录
COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d/

EXPOSE 3306
