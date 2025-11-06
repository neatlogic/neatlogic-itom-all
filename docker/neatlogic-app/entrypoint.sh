#!/bin/bash
#set -x
#******************************************************************************
# @file    : entrypoint.sh
# @author  : neatlogic
# @brief   : entry point for manage service start order
#******************************************************************************

SECOND=2 
MYSQL_SERVICE_HOST=${MYSQL_SERVICE_HOST}
if [[ ! -n "$MYSQL_SERVICE_HOST" ]];then
    MYSQL_SERVICE_HOST="neatlogic-db"
fi

MYSQL_SERVICE_PORT=${MYSQL_SERVICE_PORT}
if [[ ! -n "$MYSQL_SERVICE_PORT" ]];then
    MYSQL_SERVICE_PORT=3306
fi

MYSQL_SERVICE_USER=${MYSQL_SERVICE_USER}
if [[ ! -n "$MYSQL_SERVICE_USER" ]];then 
    MYSQL_SERVICE_USER="root"
fi 

MYSQL_SERVICE_PASSWORD=${MYSQL_SERVICE_PASSWORD}
if [[ ! -n "$MYSQL_SERVICE_PASSWORD" ]];then 
    MYSQL_SERVICE_PASSWORD='neatlogic@901'
fi 

TENANT_NAME=${TENANT_NAME}
if [[ ! -n "$TENANT_NAME" ]];then 
    TENANT_NAME='demo'
fi 

# 校验DB数据库情况
if [[ "$MYSQL_SERVICE_HOST" == 'neatlogic-db' ]];then
    #等待DB容器启动
    while ! nc -z $MYSQL_SERVICE_HOST $MYSQL_SERVICE_PORT ; do 
        echo Waiting $MYSQL_SERVICE_HOST service start...; 
        sleep $SECOND; 
    done
    
    # 检查DB数据库是否存在，存在则认为已初始化完成
    db_list=(
        "neatlogic"
        "neatlogic_$TENANT_NAME"
        "neatlogic_$TENANT_NAME""_data"
    );
 
    i=0  
    while [ $i -lt ${#db_list[@]} ]  
    do  
        SUM=0
        valid_db_name=${db_list[$i]}
        while [ $SUM -le 180 ]; do
            ret=`mysql  -h $MYSQL_SERVICE_HOST -P $MYSQL_SERVICE_PORT  -u$MYSQL_SERVICE_USER -p$MYSQL_SERVICE_PASSWORD -e "show DATABASES like '$valid_db_name'"` 
            if [[ $ret =~ $valid_db_name ]]; then 
                sleep $SECOND 
                echo "$valid_db_name databse data init success."
                break 
            else
                echo "Waiting for $valid_db_name databse data init..."
                sleep $SECOND 
                SUM=$[ SUM + SECOND ]
            fi 
        done 
        if [[ $SUM -ge 180 ]]; then
            echo "Waited for $valid_db_name databse data timeout!"
            break;
        fi
        let i++  
    done 
fi 

#修改配置文件
CONFIG_FILE=$NEATLOGIC_HOME/systems/neatlogic/config/config.properties
perl -i -pe "s/db.url\s*=\s*.*?:3306\//db.url = jdbc:mysql:\/\/$MYSQL_SERVICE_HOST:$MYSQL_SERVICE_PORT\//g" $CONFIG_FILE
sed -i "s/^db.username\s*=.*/db.username=$MYSQL_SERVICE_USER/" $CONFIG_FILE
sed -i "s/^db.password\s*=.*/db.password=$MYSQL_SERVICE_PASSWORD/" $CONFIG_FILE
sed -i "s/^db.host\s*=.*/db.host=$MYSQL_SERVICE_HOST/" $CONFIG_FILE
sed -i "s/^db.port\s*=.*/db.port=$MYSQL_SERVICE_PORT/" $CONFIG_FILE

if [[ -z "$NACOS_SERVICE_HOST" ]]; then
    sed -i -E 's/-Dnacos\.home=[^ ]* ?//g' "$NEATLOGIC_HOME/systems/neatlogic/sysconfig/serveradmin/neatlogic.env"
    sed -i -E 's/-Dnacos\.namespace=[^ ]* ?//g' "$NEATLOGIC_HOME/systems/neatlogic/sysconfig/serveradmin/neatlogic.env"
else
    sed -i -E "s|-Dnacos\.home=[^ ]*|-Dnacos.home=$NACOS_SERVICE_HOST|g" "$NEATLOGIC_HOME/systems/neatlogic/sysconfig/serveradmin/neatlogic.env"
fi

chown -R app:apps /app
chmod -R 777 /app/logs/neatlogic/

#启动服务
/app/serveradmin/bin/deployadmin -s neatlogic -a startall ;
echo "neatlogic-app service start."

exec bash