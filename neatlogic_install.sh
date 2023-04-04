#!/bin/bash

# 初始化变量
dbPort=3306
collectdbPort=27017
appPort=8282
runnerPort=8084
runnerHeartbeatPort=8888
webPort=8090
masterWebPort=9099

# 处理参数
parseOpts() {
    OPT_SPEC=":h-:"
    while getopts "$OPT_SPEC" optchar; do
        case "${optchar}" in
        -)
            case "${OPTARG}" in
                dbPort)
                dbPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
                collectdbPort)
                collectdbPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
                appPort)
                appPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
                runnerPort)
                runnerPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
                runnerHeartbeatPort)
                runnerHeartbeatPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
                webPort)
                webPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
                masterWebPort)
                masterWebPort="${!OPTIND}"
                OPTIND=$(($OPTIND + 1))
                ;;
            *)
                if [ "$OPTERR" = 1 ] && [ "${OPT_SPEC:0:1}" != ":" ]; then
                    echo "Unknown option --${OPTARG}" >&2
                fi
                ;;
            esac
            ;;
        h)
            exit 2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${OPT_SPEC:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
        esac
    done
}
parseOpts "$@"

echo "抽取镜像..."
echo "neatlogic/neatlogic-collectdb:1.0.0..."
docker pull neatlogic/neatlogic-collectdb:1.0.0

echo "neatlogic/neatlogicdb:1.0.0..."
docker pull neatlogic/neatlogicdb:1.0.0

echo "neatlogic/neatlogic-web:3.0.0..."
docker pull neatlogic/neatlogic-web:3.0.0

echo "neatlogic/neatlogic-runner:3.0.0..."
docker pull neatlogic/neatlogic-runner:3.0.0

echo "neatlogic/neatlogic:3.0.0..."
docker pull neatlogic/neatlogic:3.0.0

echo "部署容器..."
docker network create neatlogic


echo "部署neatlogicdb服务...."
docker run -it --name neatlogicdb  -p $dbPort:3306  --net neatlogic --network-alias neatlogicdb -d neatlogic/neatlogicdb:1.0.0
sleep 30 

echo "部署neatlogic-collectdb服务...."
docker run -it --name neatlogic-collectdb -p $collectdbPort:27017 --net neatlogic --network-alias neatlogic-collectdb  -d neatlogic/neatlogic-collectdb:1.0.0
sleep 10 

echo "部署neatlogic-app...."
docker run -it --name neatlogic-app -p $appPort:8282 --net neatlogic --network-alias neatlogic-app  -d neatlogic/neatlogic:3.0.0
sleep 10 

echo "部署neatlogic-runner...."
docker run -it --name neatlogic-runner -p $runnerPort:8084 -p $runnerHeartbeatPort:8888 --net neatlogic --network-alias neatlogic-runner  -d neatlogic/neatlogic-runner:3.0.0
sleep 20 

echo "部署neatlogic-web...."
docker run -it --name neatlogic-web -p $webPort:8090 -p $masterWebPort:9099 --net neatlogic --network-alias neatlogic-web  -d neatlogic/neatlogic-web:3.0.0

echo "检查服务..."
docker ps