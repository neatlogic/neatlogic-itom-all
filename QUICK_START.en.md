# Project deployment tutorial

## Docker environment installation

check docker version

```
docker --version        #view docker version, return version information, indicating that docker has been installed
docker-compose --version
```

Add the file install-docker.sh in the /tmp directory, and then execute<br>
Download [install-docker.sh](install-docker.sh)


## Deploy the service on the target machine

Add the file neatlogic_setup.sh in the /tmp directory, and then execute<br>
Download [neatlogic_setup.sh](neatlogic_setup.sh)


## Uninstall the service with one click

Add the file neatlogic_clear.sh in the /tmp directory, and then execute<br>
Download [neatlogic_clear.sh](neatlogic_clear.sh)

## Mirror container service description
| Startup sequence | Container service name | Ports exposed to the operating system level | Service start and stop commands in the container |
| ---- | ---- | ---- | ---- |
| 1 | neatlogicdb | Port 3306 | Start: /app/databases/neatlogicdb/scripts/neatlogicdb start<br>Stop: /app/databases/neatlogicdb/scripts/neatlogicdb stop |
| 1 | neatlogic-collectdb | Port 27017 | Start: /app/databases/collectdb/bin/mongod --config /app/databases/collectdb/conf/mongodb.conf<br>Stop:<br>mongo 127.0.0.1: 27017/admin -uadmin -p u1OPgeInMhxsNkNl << EOF<br>db.shutdownServer();<br>exit;<br>EOF |
| 2 | neatlogic-runner | Port 8084, 8888 | Start: deployadmin -s autoexec-runner -a startall<br> Stop: deployadmin -s autoexec-runner -a stopall |
| 2 | neatlogic-web | Port 8090, 8080 | Start: deployadmin -s neatlogic -a startall<br> Stop: deployadmin -s neatlogic -a stopall |
| 3 | neatlogic-app | Port 8282 | Start: /app/systems/nginx/sbin/nginx<br>Restart: /app/systems/nginx/sbin/nginx -s reload <br>Stop: kill xx |

Note: Start sequence: The smaller the number, the higher the start and stop priority 1 > 2 >3

## common problem

1. Docker did not start when pulling the image<br>
Error message```Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?```<br>
It means that docker is not started, just start docker and execute the deployment file again.
2. The service was not uninstalled before re-pulling the image, resulting in the service and container being occupied<br>
An error message ```Error response from daemon: network with name neatlogic already exists``` appears, indicating that the service neatlogic is already running and needs to be stopped. <br>
An error message appears ```docker: Error response from daemon: Conflict, The container name "/neatlogic-xxx" is already in use by container "xxxxxxxx". You have to remove (or rename) that container to be able to reuse that name.```, indicating that there is a container with the same name as /neatlogic-xxx, you need to stop the container and delete the container and related images.
3. The service port is occupied<br>
Execute the following command to view the port occupancy<br>
```
netstat -anp |grep XX #XX is the port number
```
As shown in the figure, if there is a line of LISTEN, it means that the port is occupied. Note here that the LISTENING shown in the figure does not mean that the port is occupied. Do not confuse it with LISTEN. When viewing a specific port, you must see the line of tcp, port number, and LISTEN to indicate that the port is occupied<br>
![Example image of port occupancy](QUICK_START_IMAGES/images_port.png)<br>
When the port is occupied, you can first query the process number of the program specified by the port, and then use the command to close the program running with the port number
```
ps -ef |grep XX #Query the process number command of the port specified program, XX is the port number
kill -9 XX #close the process, XX is the process number
```
4. After docker restarts, the process in the container hangs

## Description of common operation commands

**1. Deployment, docker run -it --name container name -p operating system port: container port --net network name -d image: version**<br>
```
docker run -it --name neatlogic -p 8282:8282 --net neatlogic -d neatlogic/neatlogic:3.0.0
```

**2. Enter the container, docker exec -it [container name|container ID] /bin/sh**<br>
```
docker exec -it neatlogic /bin/sh
```

**3. View container logs, docker logs [container name|container ID]**<br>
```
docker logs neatlogic
```

**4. Start and stop the container, docker start/stop [container name|container ID]**<br>
```
docker start/stop neatlogic-web
```

**5. Delete the container, docker rm [container name|container ID]**<br>
```
docker rm neatlogic
```

**6. Delete the mirror, docker rm [mirror ID|mirror name: version]**<br>
```
docker rmi -f neatlogic/neatlogic:3.0.0
```

**7. Container network:**<br>
```
docker network ls #View all
docker network create xxxx #Create a network, the default is bridge**
```

**8. Check the running container:**<br>
```
docker ps #View all running containers
```

**9. Add file execution permission:**<br>
```
chmod +x XXX.sh #Add execution permission
```

**10. Execute script:**<br>
```
sh XXX.sh #Execute the script of XXX.sh file
```