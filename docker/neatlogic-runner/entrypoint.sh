#!/bin/bash

SECOND=2 
wait_for() {
    while ! nc -z $1 $2 ; do
        echo Waiting $1:$2 service start...;
        sleep $SECOND;
    done
}

NEATLOGIC_SERVICE_NAME=${NEATLOGIC_SERVICE_NAME}
if [[ ! -n "$NEATLOGIC_SERVICE_NAME" ]];then 
    NEATLOGIC_SERVICE_NAME="neatlogic-app"
fi 

NEATLOGIC_SERVICE_PORT=${NEATLOGIC_SERVICE_PORT}
if [[ ! -n "$NEATLOGIC_SERVICE_PORT" ]];then 
    NEATLOGIC_SERVICE_PORT=8282
fi 

#等待APP容器启动
wait_for $NEATLOGIC_SERVICE_NAME $NEATLOGIC_SERVICE_PORT
echo "$NEATLOGIC_SERVICE_NAME:$NEATLOGIC_SERVICE_PORT service is started..."

if [[ -f "/app/systems/autoexec.tar.gz" ]];then 
    tar -zxvf /app/systems/autoexec.tar.gz -C /app/systems/
    rm -f /app/systems/autoexec.tar.gz
fi 

if [[ -f "/app/systems/autoexec/plib-aarch64.tar.gz" ]];then 
    rm -rf /app/systems/autoexec/plib/*
    tar -zxvf /app/systems/autoexec/plib-aarch64.tar.gz -C /app/systems/autoexec/
    rm -f /app/systems/autoexec/plib-aarch64.tar.gz
fi 

if [[ -f "/app/systems/autoexec/plib-x86_64.tar.gz" ]];then 
    tar -zxvf /app/systems/autoexec/plib-x86_64.tar.gz -C /app/systems/autoexec/
    rm -f /app/systems/autoexec/plib-x86_64.tar.gz
fi 

echo "update config.ini"
CONFIG_FILE=/app/systems/autoexec/conf/config.ini
sed -i "s/^server.baseurl\s*=.*/server.baseurl=http:\/\/$NEATLOGIC_SERVICE_NAME:$NEATLOGIC_SERVICE_PORT/" $CONFIG_FILE

chown -R app:apps /app
#挂载卷权限
chmod -R 777 /app/logs/neatlogic-runner
chmod -R 777 /app/autoexec/data/

echo "start runner"
#启动服务
/app/serveradmin/bin/deployadmin -s neatlogic-runner -a startall 

echo "设置自动化基础环境变量..."
#设置python
sh /app/autoexec/bin/setup.sh
sh /app/autoexec/bin/setenv.sh

echo "set global.index-url install.trusted-host"
#国内镜像
pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple/
pip3 config set install.trusted-host mirrors.aliyun.com

#安装依赖
if [[ -d "/tmp/dependents" ]]; then 
    echo "install dependents..."
    rm -rf /app/autoexec/plib/*
    pip3 install --no-index --find-links=file:/tmp/dependents/  -r /tmp/dependents/requirement.txt -t /app/autoexec/plib/
    rm -rf /tmp/dependents
    chown -R app:apps /app/autoexec/plib/
fi 

echo "导入字典..."
#导入字典
/app/autoexec/i18n/cmdbcollect/dicttool --tenant demo
#导入特征库
/app/autoexec/discovery/dislibtool --tenant demo

#基础OS依赖
yum install -y gcc gcc-c++ perl-ExtUtils* perl-Term* perl-libwww-perl perl-ExtUtils-MakeMaker openssl openssl-devel ipmitool net-snmp net-snmp-utils readline readline-devel compat-libtermcap

yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-11.noarch.rpm
yum install -y mysql
yum install -y git 
#安装第三方依赖
sh autoexec/plugins/local/media/setup.sh

echo "neatlogic-runner service start."

exec bash