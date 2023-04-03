
#!/bin/bash

# 初始化变量
dbPort=3306
collectdbPort=27017
appPort=8282
runnerPort=8084
runnerHeartbeatPort=8888
webPort=8090

# 处理参数
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        --dbPort)
        dbPort="$2"
        shift
        shift
        ;;
        --ip)
        ip="$2"
        shift
        shift
        ;;
        *)
        shift
        ;;
    esac
done

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
docker run -it --name neatlogic-web -p $webPort:8090 --net neatlogic --network-alias neatlogic-web  -d neatlogic/neatlogic-web:3.0.0

echo "检查服务..."
docker ps