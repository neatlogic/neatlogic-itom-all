FROM centos:7.9.2009

MAINTAINER neatlogic organization
LABEL version="NeatLogic Databases 1.0.0" \
  description="NeatLogic ITOM 3.0.0"

ENV PATH=/app/serverware/mysql/bin/:$PATH \
  LANG=en_US.utf8 \
  LC_ALL=en_US.utf8

# 使用自定义 repo
COPY Centos-7.repo /etc/yum.repos.d/CentOS-7.repo

# 创建用户组和用户 + 安装依赖 + 清理缓存 + 设置时区
RUN groupadd apps && useradd -g apps app \
  && yum install -y -q libaio numactl nc \
  && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && yum clean all && rm -rf /var/cache/yum

# 创建目录
RUN mkdir -p /app/tmp \
  /app/logs/{serveradmin,snapshoter,neatlogicdb} \
  /app/databases

# 拷贝数据库文件、应用程序和初始化脚本
COPY neatlogicdb /app/databases/neatlogicdb/
COPY serverware /app/serverware/
COPY initsql /app/tmp/
COPY entrypoint.sh /

WORKDIR /app
#USER app

EXPOSE 3306

CMD sh /entrypoint.sh; bash
#ENTRYPOINT ["sh", "/entrypoint.sh"]