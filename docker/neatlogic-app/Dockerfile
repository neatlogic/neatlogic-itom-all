# syntax=harbor.neatlogic.com:8033/library/docker/dockerfile:1.4

ARG BASE_IMAGE=harbor.neatlogic.com:8033/library/neatlogic/neatlogic-os:jdk17-tomcat9
FROM ${BASE_IMAGE}

LABEL maintainer="neatlogic organization" \
  version="NeatLogic 4.0.0" \
  description="NeatLogic ITOM 4.0.0" 

ENV NEATLOGIC_HOME=/app \
  PATH=/app/serveradmin/bin:$PATH 

RUN set -eux && \
  mkdir -p /app/tmp \
  /app/logs/{serveradmin,snapshoter,neatlogic} \
  /app/servers 

# 应用文件
COPY neatlogic   /app/systems/neatlogic/
COPY serveradmin /app/serveradmin/
COPY serveradmin/bin/autocomplete_deployadmin.sh /etc/profile.d/
COPY .bash_profile /home/app/
COPY entrypoint.sh /

WORKDIR $NEATLOGIC_HOME

EXPOSE 8282

ENTRYPOINT ["/entrypoint.sh"]