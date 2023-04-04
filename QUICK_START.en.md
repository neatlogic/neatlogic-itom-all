# Project Deployment Tutorial
## Docker environment inspection
Check the Docker version (return version information indicating that the Docker is installed)
```
docker --version
docker-compose --version
```
>Note: Please ensure that the Docker is installed before proceeding with the next steps
## Installation
```
curl  https://gitee.com/neat-logic/neatlogic-itom-all/raw/develop3.0.0/neatlogic_install.sh |bash
```
To address possible operating system level port conflicts, a custom container needs to be exposed to the operating system port:
|Parameter Name | Default Port | Description|
|---|---|---|
|DbPort | 3306 | Neatlogic MySQL port|
|CollectdbPort | 27017 | nextlogic mongodb port|
|RunnerPort | 8084 | Runner service port|
|RunnerHeartbeatPort | 8888 | Processor Heartbeat Port|
|WebPort | 8090 | Front end page service port|
|MasterWebPort | 9099 | Tenant Management Page Service Port|
|MobileWebPort | 8091 | Mobile front-end page service port|
|AppPort | 8282 | Backend service port|

For example, it is necessary to replace the MobileWebPort with 8092:
```
curl  https://gitee.com/neat-logic/neatlogic-itom-all/raw/develop3.0.0/neatlogic_install.sh |bash -s -- --mobileWebPort 8092
```
## Uninstall
```
curl  https://gitee.com/neat-logic/neatlogic-itom-all/raw/develop3.0.0/neatlogic_clear.sh |bash
```
## Mirror Container Service Description
|Start sequence | Container service name | Expose to operating system level ports | Container service start stop command|
|  ----  | ----  | ----  | ----  |
|1 | nearlogicDB | Port 3306 | Start:/app/databases/nearlogicDB/scripts/nearlogicDB start<br>Stop:/app/databases/nearlogicDB/scripts/nearlogicDB stop|
|1 | nextlogic collectdb | 27017 port | Start:/app/databases/collectdb/bin/mongod -- config/app/databases/collectdb/conf/mongodb. conf<br>Stop:<br>mongo 127.0.0.1:27017/admin uadmin - p u1OPgeInMhxsNKnl<EOF<br>db. shutdownServer()< br>exit;< br>EOF  |
|2 | nextlogic runner | 8084, 8888 ports | Start: deployadmin - s autoexec runner - a startall<br>Stop: deployadmin - s autoexec runner - a stopall|
|2 | neologic app | Port 8282 | Start: deployadmin - s neologic - a startall<br>Stop: deployadmin - s neologic - a stopall|
|3 | neologic web | Port 8090 | Start:/app/systems/nginx/sbin/nginx<br>Restart:/app/systems/nginx/sbin/nginx - s reload<br>Stop: kill xx|
>Explanation: Starting sequence: The smaller the number, the higher the priority of starting and stopping 1>2>3
## Frequently Asked Questions
1. Docker did not start when pulling the image<br>
Error Message ` ` Cannot connect to the Docker daemon at unix:///var/run/docker.sock.  Is the docker daemon running?```< br>
The Docker has not been started. Start the Docker and then re execute the deployment file.
2. Failure to uninstall the service before re pulling the image results in the service and container being occupied<br>
An error message 'Error response from daemon: network with name nearlogic already exists' appears, indicating that the service nearlogic is already running and needs to be stopped< br>
An error message appears, 'Docker: Error response from daemon: Conflict, The container name'/netlogic xxx 'is already in use by container' xxxxxxxx ' You have to remove (or rename) that container to be able to reuse that name.```， It indicates that there is a container with the same name as/readlogic xxx, and it is necessary to stop the container and delete the container and related images.
3. The service port is occupied<br>
Execute the following command to view the port usage status<br>
```
Netstat - np | grep XX #XX is the port number
```
As shown in the figure, if there is a LISTEN line, it indicates that the port is occupied. Please note that the LISTENING shown in the figure does not indicate that the port is occupied. Do not confuse it with LISTEN. When viewing the specific port, you must see the lines TCP, port number, and LISTEN to indicate that the port is occupied.<br>
! [Port Occupation Example Figure] (QUICK_START-IMAGES/images_port. png)<br>
When a port is occupied, you can first query the process number of the specified program on that port, and then use the command to close the program running with that port number
```
Ps - ef | grep XX #Command to query the process number of the specified program on this port, where XX is the port number
Kill -9 XX #Close the process, where XX is the process number
```
4. After the Docker restarts, the process in the container hangs

## Explanation of common operating commands

**1. Deployment, Docker run - it -- name Container name - p Operating system port: Container port -- net Network name - d Image: Version**<br>

```
docker run -it --name neatlogic -p 8282:8282 --net neatlogic  -d neatlogic/neatlogic:3.0.0
```
**2. Entering the container, dock exec it [container name | container ID]/bin/sh**<br>
```
docker exec -it neatlogic /bin/sh
```
**3. View container logs, Docker logs [container name | container ID]**<br>
```
docker logs neatlogic
```
**4. Container start/stop, Docker start/stop [Container name | Container ID]**<br>
```
docker start/stop  neatlogic-web
```
**5. Delete container, Docker rm [container name | container ID]**<br>
```
docker rm neatlogic
```
**6. Delete image, Docker rm [Image ID | Image Name: Version]**<br>
```
docker rmi -f  neatlogic/neatlogic:3.0.0
```
**7. Container network:**<br>
```
Docker network ls #View all
Docker network create xxxx #Create a network, default to bridging**
```
**8. View running containers:**<br>
```
Docker ps #View all running containers
```
**9. Add file execution permissions:**<br>
```
Chmod+x XXX.sh #Add Execution Permissions
```
**10. Execute script:**<br>
```
Sh XXX.sh #Execute script for XXX.sh file
```