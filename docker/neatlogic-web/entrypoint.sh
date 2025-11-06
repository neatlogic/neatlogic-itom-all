#!/bin/bash

SECOND=2 

wait_for_service() {
    URL="http://$1:$2/neatlogic/tenant/check/demo"
    while true; do
        response=$(curl -s -k "$URL")
        if echo "$response" | grep -q '"Status":"OK"'; then
            echo "$1:$2 service is ok."
            break
        fi
        echo "Check $URL response ... not ready"
        sleep $SECOND
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

wait_for_service $NEATLOGIC_SERVICE_NAME $NEATLOGIC_SERVICE_PORT

if [ ! -L "/app/systems/nginx/logs" ]; then
    cd /app/systems/nginx/
    rm -rf logs 
    ln -s ../../logs/nginx/ logs
fi

chown -R app:apps /app
chmod -R 777 /app/logs/nginx/

CONF_FILE=/app/systems/nginx/conf/nginx.conf
sed -i '/^\s*user\s\+app\s*;$/d' $CONF_FILE

WEB_CONF_FILE=/app/systems/nginx/conf.d/neatlogic-web.conf
sed -i "s#set \$appaddr neatlogic-app:8282;#set \$appaddr ${NEATLOGIC_SERVICE_NAME}:${NEATLOGIC_SERVICE_PORT};#g"  $WEB_CONF_FILE
sed -i "s#set \$appaddr 127.0.0.1:8282;#set \$appaddr ${NEATLOGIC_SERVICE_NAME}:${NEATLOGIC_SERVICE_PORT};#g"  $WEB_CONF_FILE

/app/systems/nginx/sbin/nginx -c $CONF_FILE
echo "neatlogic-web service start."

exec bash