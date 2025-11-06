# syntax=harbor.neatlogic.com:8033/library/docker/dockerfile:1.4

ARG BASE_IMAGE=harbor.neatlogic.com:8033/library/centos:centos8.4.2105
FROM ${BASE_IMAGE}

LABEL maintainer="neatlogic organization" \
  version="NeatLogic 3.0.0" \
  description="NeatLogic ITOM 3.0.0" 

ENV NEATLOGIC_HOME=/app \
  PATH=/app/autoexec/bin:/app/serverware/jdk/bin:$PATH \
  LANG=en_US.utf8 \
  LC_ALL=en_US.utf8

RUN rm -f /etc/yum.repos.d/*.repo
COPY Centos-8.repo /etc/yum.repos.d/CentOS-8.repo

RUN set -eux && \
  groupadd -r apps && useradd -r -g apps app && \
  yum install -y --setopt=tsflags=nodocs make gcc openssl openssl-devel bzip2-devel libffi-devel zlib-devel \
  glibc-langpack-en nc tar unzip zip \
  perl perl-Data-Dumper perl-TermReadKey perl-Net-SSLeay \
  libffi-devel net-snmp net-snmp-utils ipmitool nmap && \
  ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  mkdir -p /app/tmp \
  /app/logs/{serveradmin,snapshoter,autoexec-runner} \
  /app/servers && \
  ln -s /app/systems/autoexec /app/autoexec && \
  yum clean all && rm -rf /var/cache/yum

ARG JDK_VERSION=17.0.12
ARG JDK_BASE_URL=https://download.oracle.com/java/17/archive

RUN set -eux && \
  ARCH=$(uname -m) && \
  if [ "$ARCH" = "x86_64" ]; then \
  JDK_FILE="jdk-${JDK_VERSION}_linux-x64_bin.tar.gz"; \
  elif [ "$ARCH" = "aarch64" ]; then \
  JDK_FILE="jdk-${JDK_VERSION}_linux-aarch64_bin.tar.gz"; \
  else \
  echo "Unsupported arch: $ARCH" && exit 1; \
  fi && \
  echo "Downloading JDK: ${JDK_FILE}" && \
  curl -L -o /tmp/${JDK_FILE} ${JDK_BASE_URL}/${JDK_FILE} && \
  mkdir -p /app/serverware && \
  tar -xzf /tmp/${JDK_FILE} -C /app/serverware && \
  mv /app/serverware/jdk-${JDK_VERSION} /app/serverware/jdk && \
  rm -f /tmp/${JDK_FILE} 

ARG PYTHON_VERSION=3.7.9
RUN set -eux && \
  echo "Installing Python ${PYTHON_VERSION} ..." && \
  ARCH=$(uname -m) && \
  cd /tmp && \
  curl -L -o Python-${PYTHON_VERSION}.tgz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
  tar -xzf Python-${PYTHON_VERSION}.tgz && \
  cd Python-${PYTHON_VERSION} && \
  ./configure --prefix=/app/serveradmin/python --enable-optimizations && \
  make -j"$(nproc)" && \
  make install && \
  ln -sf /app/serveradmin/python/bin/python3 /usr/local/bin/python3 && \
  ln -sf /app/serveradmin/python/bin/pip3 /usr/local/bin/pip3 && \
  cd / && rm -rf /tmp/Python-${PYTHON_VERSION}* && \
  python3 --version && pip3 --version

# 拷贝应用
COPY neatlogic-runner /app/systems/neatlogic-runner/
COPY autoexec.tar.gz /app/systems/
COPY serveradmin /app/serveradmin/
COPY serveradmin/bin/autocomplete_deployadmin.sh /etc/profile.d/
COPY .bash_profile /home/app/
COPY entrypoint.sh /

WORKDIR $NEATLOGIC_HOME

EXPOSE 8084 8888

ENTRYPOINT ["/entrypoint.sh"]
