# syntax=harbor.neatlogic.com:8033/library/docker/dockerfile:1.4

ARG BASE_IMAGE=harbor.neatlogic.com:8033/library/neatlogic/neatlogic-os:nginx
FROM ${BASE_IMAGE}

LABEL maintainer="neatlogic organization" \
  version="NeatLogic 4.0.0" \
  description="NeatLogic ITOM 4.0.0" 

ENV NEATLOGIC_HOME=/app \
  PATH=/app/systems/nginx/sbin:$PATH 

RUN set -eux && \
  mkdir -p /app/logs/{serveradmin,snapshoter,nginx} && \
  mkdir -p /app/systems/nginx/conf.d 

# 拷贝应用
COPY nginx/conf/nginx.conf /app/systems/nginx/conf/nginx.conf
COPY nginx/conf.d/ /app/systems/nginx/conf.d/

COPY neatlogic-web /app/systems/neatlogic-web/
COPY entrypoint.sh /

WORKDIR $NEATLOGIC_HOME

EXPOSE 8080 8090 9099

ENTRYPOINT ["/entrypoint.sh"]