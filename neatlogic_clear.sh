echo "清理neatlogic-web服务..."
docker stop  neatlogic-web
docker rm neatlogic-web
docker rmi -f neatlogic/neatlogic-web:3.0.0

echo "清理neatlogic-runner服务..."
docker stop  neatlogic-runner
docker rm neatlogic-runner
docker rmi -f neatlogic/neatlogic-runner:3.0.0

echo "清理neatlogic服务..."
docker stop  neatlogic
docker rm neatlogic
docker rmi -f neatlogic/neatlogic:3.0.0

echo "清理neatlogic-collectdb服务..."
docker stop  neatlogic-collectdb
docker rm neatlogic-collectdb
docker rmi -f neatlogic/neatlogic-collectdb:1.0.0

echo "清理neatlogic-web服务..."
docker stop  neatlogicdb
docker rm neatlogicdb
docker rmi -f neatlogic/neatlogicdb:1.0.0