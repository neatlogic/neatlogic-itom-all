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
docker run -it --name neatlogicdb  -p 3306:3306  --net neatlogic --network-alias neatlogicdb -d neatlogic/neatlogicdb:1.0.0
sleep 30 

echo "部署neatlogic-collectdb服务...."
docker run -it --name neatlogic-collectdb -p 27017:27017 --net neatlogic --network-alias neatlogic-collectdb  -d neatlogic/neatlogic-collectdb:1.0.0
sleep 10 

echo "部署neatlogic-app...."
docker run -it --name neatlogic-app -p 8282:8282 --net neatlogic --network-alias neatlogic-app  -d neatlogic/neatlogic:3.0.0
sleep 10 

echo "部署neatlogic-runner...."
docker run -it --name neatlogic-runner -p 8084:8084 -p 8888:8888 --net neatlogic --network-alias neatlogic-runner  -d neatlogic/neatlogic-runner:3.0.0
sleep 20 

echo "部署neatlogic-web...."
docker run -it --name neatlogic-web -p 8090:8090 --net neatlogic --network-alias neatlogic-web  -d neatlogic/neatlogic-web:3.0.0

echo "检查服务..."
docker ps