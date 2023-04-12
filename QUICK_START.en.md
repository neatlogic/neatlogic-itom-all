# Project Deployment Tutorial
## Docker environment inspection
Check the Docker version (return version information indicating that the Docker is installed)
```
docker --version
docker-compose --version
```
>Note: Please ensure that the Docker is installed before proceeding with the next steps
## Installation
Download the [docker-compose.yml](docker-compose.yml) configuration file, which is the core of Docker Compose and is used to define services, networks, and data volumes.
If no modifications are made, execute the startup command directly
```
Docker composite -f docker composite.yml up -d # -f for executing the specified yml, -d for executing in the background and returning
```
The container service will be installed by default:
|Container Service Name | Default Host Port | Starting Container Service Dependency | Access Address | Container Service Start Stop Command | Description|
| ---- | ---- | ---- | ---- | ---- | ---- |
|neatlogic-db | 3306 | - | - | Start:/app/databases/neatlogicdb/scripts/neatlogicdb start<br>Stop:/app/databases/neatlogicdb/scripts/neatlogicdb stop | MySQL database|
|neatlogic-collectdb | 27017 | - | - | Start:/app/databases/collectdb/bin/mongod -- config/app/databases/collectdb/conf/mongodb.conf<br>Stop:<br>mongo 127.0.0.1:27017/admin uadmin - p u1OPgeInMhxsNKnl<EOF<br>db. shutdownServer()< br>exit;< EOF | mongodb, if using cmdb for automatic collection, automation, inspection, and publishing, this service is required|
|neatlogic-runner | 8084, 8888 | - | - | Start: deployadmin - s autoexec-runner - a startall<br>Stop: deployadmin - s autoexec-runner - a stopall | Executor, if using publish, patrol, automation, or agent, this service is required|
|neatlogic-app | 8282 | neatlogic-db<br>neatlogic-collectdb<br>neatlogic-runner<br>neatlogic-nacos | - | Start: deployadmin - s neatlogic - a startall<br>Stop: deployadmin - s neatlogic - a stopall | Backend service|
|netlogic-web | 8090, 8080, 9099 | netlogic app | HostIP:8090/TenantName #Front End Page<br>HostIP:9099 #Tenant Management Page Login Account: admin Password: 123456 | Start:/app/systems/nginx/sbin/nginx<br>Restart:/app/systems/nginx/sbin/nginx - s reload<br>Stop: kill xx | Front End Service|
|neatlogic-nacos | 8848 | neatlogic-db | Start:/app/systems/nacos/bin/startup.sh - m standalone nacos | Backend service config|
## Verification
Because the startup of the Docker container service is asynchronous, the completion of the startup command mentioned above does not mean that the service has started normally<br>
We still need to wait a few minutes before accessing the front-end service: http://HostIP:9099/ If a login page appears, congratulations on the successful deployment of the service<br>
If the prompt indicates that the tenant does not exist, you need to check the logs, which may indicate that the service is still waiting to start
```
docker-compose -f docker-compose.yml logs -f neatlogic-app
```
If there is an error in the log, please contact us [Neatlogic in Slack](https://join.slack.com/t/slack-lyi2045/shared_invite/zt-1sok6dlv5-WzpKDpnXQLXc92taC1qMFA)
## Modify the configuration Docker Compose.yml as needed
### Common scenarios that require modification:
**1. Data persistence**
Persistence is not configured by default. If necessary, please refer to the following configuration modifications:
neatlogic-db 
```
volumes:
- /app/logs/neatlogicdb/:/app/logs/neatlogicdb/
- type: volume
source: db_data
target:/app/databases/natlogicDb/# Host path
```
neatlogic-collectdb
```
volumes:
- /app/logs/collectdb/:/app/logs/collectdb/
- type: volume
source: collectdb_data
Target:/app/databases/collectdb/# Host path
```
neatlogic-runner
```
volumes:
- /app/logs/neatlogic-runner/:/app/logs/autoexec-runner/
- type: volume
source: autoexec_data
target:/app/autoexec/data/# Host path
```
**2. Host Port Conflict**
Simply modify the ports field. For example, if there is a conflict with the 8080 port on the neatlogic-web, you need to change the host port on the left to a non occupied port. If I want to change it to 8081:
```
ports:
- "8090:8090"
- "8081:8080"
- "9099:9099"
```
**3. Do not use the built-in container service**
If a container service is not needed, simply delete the corresponding container service configuration and modify the environment attribute of the dependent container service<br>
If there is no need for neatlogic-db, as neatlogic-db is dependent on neatlogic-app and neatlogic-nacos, both neatlogic-app and neatlogic-nacos need to modify the MYSQL of the environment_SERVICE_HOST、MYSQL_SERVICE_PORT、MYSQL_SERVICE_USER、MYSQL_SERVICE_PASSWORD, such as:<br>
Customized use of external mysqldb 192.168.1.33:3306, account/password: app/123456
```
environment:
#MySQL configuration for connections
MYSQL_SERVICE_HOST: "192.168.1.33"
MYSQL_SERVICE_PORT: 3306
...
MYSQL_SERVICE_USER: app
MYSQL_SERVICE_PASSWORD: "123456"
```
# Common COMMAND
## Start
Create a container based on yml and start all container services
```
Docker composite -f docker composite. yml up -d # -f for executing the specified yml, -d for executing in the background and returning
```
If you only need to process a certain container service, simply add the container service name after the command, such as:
```
Docker composite -f docker composite. yml up -d neatlogic-app # Recreate and start the neatlogic-app service separately
```
## View logs
View logs of all container services
```
docker-compose -f docker-compose.yml logs
```
If you only need to view the logs of a certain container service, simply add the container service name after the command, such as:
```
docker-compose -f docker-compose.yml logs neatlogic-app
```
### Real time viewing of logs
```
docker-compose -f docker-compose.yml logs -f
```
## View containers that have successfully started
```
docker-compose -f docker-compose.yml ps
```
## Start stop container
### Open container
```
docker-compose -f docker-compose.yml start
```
### Stop container
```
docker-compose -f docker-compose.yml stop 
```
If you only need to start a certain container, simply add the container service name after the command, such as:
```
docker-compose -f docker-compose.yml start neatlogic-app
```
## Entering container service
>Non essential users do not need to enter the container service, such as the neatlogic-app container service:
```
docker-compose -f docker-compose.yml exec neatlogic-app sh
```
## Stop and remove containers, networks, mirrors, and volumes
```
docker-compose -f docker-compose.yml down 
```