# Project deployment tutorial

## Docker environment installation

First determine whether the server to be installed has docker installed, if it has been installed, ignore the current step; if docker is not installed, continue to perform the following operations.
You can check whether docker is installed by the following command

```
docker --version #View docker version, return version information, indicating that docker has been installed
docker-compose --version
```

Create a new install-docker.sh file on the server, copy the content of the script below, and execute it.
Related commands

```
cd /tmp #Switch to the tmp directory
vi install-docker.sh #Create a file, in the document editing mode, copy and paste the following script content, press ESC to exit editing, enter: wq! and press Enter to save the file
chmod +x install-docker.sh #Add file execution permission
sh install-docker.sh #execute script, install docker
```

script content
```
#!/bin/bash

# Uninstall the old version
echo ""
echo ""
echo "################################################# #########"
echo "# Uninstall old version -- start #"
echo "################################################# #########"
yum -y remove docker docker-common docker-selinux docker-engine
echo "################################################# #########"
echo "# Uninstall old version -- end #"
echo "################################################# #########"

# Install required dependencies
echo ""
echo ""
echo "################################################# #########"
echo "# Install required packages -- start #"
echo "################################################# #########"
yum install -y yum-utils device-mapper-persistent-data lvm2
echo "################################################# #########"
echo "# Install required packages -- end #"
echo "################################################# #########"

# Set yum source, Tsinghua mirror warehouse, very fast
echo ""
echo ""
echo "################################################# #########"
echo "# set yum sources -- start #"
echo "################################################# #########"
#Install wget, skip if already installed
yum -y install wget
#Download the repo file according to your distribution:
wget -O /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#Replace the software warehouse address with TUNA:
#sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
echo "################################################# #########"
echo "# set yum sources -- end #"
echo "################################################# #########"

# install docker-ce
echo ""
echo ""
echo "################################################# #########"
echo "# install docker-ce -- start #"
echo "################################################# #########"
    
yum -y install docker-ce
echo "################################################# #########"
echo "# install docker-ce -- end #"
echo "################################################# #########"

# Start and add boot start
echo ""
echo ""
echo "################################################# #########"
echo "# start and join boot start -- start #"
echo "################################################# #########"
systemctl start docker
systemctl enable docker
echo "################################################# #########"
echo "# start and join boot start -- end #"
echo "################################################# #########"

# Verify that the installation was successful
echo ""
echo ""
echo "################################################# #########"
echo "# Verify the installation was successful -- start #"
echo "################################################# #########"
docker version
echo "################################################# #########"
echo "# Verify the installation was successful -- end #"
echo "################################################# #########"

# install docker-compose
echo ""
echo ""
echo "################################################# #########"
echo "# install docker-compose -- start #"
echo "################################################# #########"
# Fast download from the domestic mirror get.daocloud.io
curl -L https://get.daocloud.io/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker- compose
chmod +x /usr/local/bin/docker-compose
echo "################################################# #########"
echo "# Install docker-compose -- end #"
echo "################################################# #########"

# Verify that the installation was successful
echo ""
echo ""
echo "################################################# #########"
echo "# Verify the installation was successful -- start #"
echo "################################################# #########"
docker-compose --version
echo "################################################# #########"
echo "# Verify the installation was successful -- end #"
echo "################################################# #########"

# Add docker domestic mirror site and restart docker
echo ""
echo ""
echo "################################################# #########"
echo "# Add docker domestic mirror site and restart docker -- start #"
echo "################################################# #########"
if [[ ! -d "/etc/docker" ]];then
mkdir -p /etc/docker
the fi
EXISTS_MIRRORS=`grep registry-mirrors /etc/docker/daemon.json`
if [[ ! -n "$EXISTS_MIRRORS" ]]; then
echo '{ "registry-mirrors": [ "https://registry.docker-cn.com" ] }' >> /etc/docker/daemon.json
the fi
systemctl restart docker
echo "################################################# #########"
echo "# add docker Domestic mirror site and restart docker -- end #"
echo "################################################# #########"

echo ""
echo ""
echo "install Success!"
echo ""
echo ""
```

## Deploy the service on the target machine

Create a new neatlogic_setup.sh file on the server, copy the content of the script below, and execute it.

```
cd /tmp #Switch to the tmp directory
vi neatlogic_setup.sh #Create a file, in the document editing mode, copy and paste the following script content, press ESC to exit editing, enter: wq! and press Enter to save the file
chmod +x neatlogic_setup.sh #Add file execution permission
sh neatlogic_setup.sh #execute script, deploy service
```

script content
```
echo "Extract image..."
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

echo "Deploying container..."
docker network create neatlogic


echo "Deploy neatlogicdb service...."
docker run -it --name neatlogicdb -p 3306:3306 --net neatlogic --network-alias neatlogicdb -d neatlogic/neatlogicdb:1.0.0
sleep 30

echo "Deploy neatlogic-collectdb service...."
docker run -it --name neatlogic-collectdb -p 27017:27017 --net neatlogic --network-alias neatlogic-collectdb -d neatlogic/neatlogic-collectdb:1.0.0
sleep 10

echo "Deploying neatlogic-app...."
docker run -it --name neatlogic-app -p 8282:8282 --net neatlogic --network-alias neatlogic-app -d neatlogic/neatlogic:3.0.0
sleep 10

echo "Deploying neatlogic-runner...."
docker run -it --name neatlogic-runner -p 8084:8084 -p 8888:8888 --net neatlogic --network-alias neatlogic-runner -d neatlogic/neatlogic-runner:3.0.0
sleep 20

echo "Deploying neatlogic-web...."
docker run -it --name neatlogic-web -p 8090:8090 --net neatlogic --network-alias neatlogic-web -d neatlogic/neatlogic-web:3.0.0

echo "Checking services..."
docker ps
```

## Uninstall the service with one click

Add the neatlogic_clear.sh file to the server, copy the content of the script below, and execute it.

```
cd /tmp #Switch to the tmp directory
vi neatlogic_clear.sh #Create a file, in the document editing mode, copy and paste the following script content, press ESC to exit editing, enter: wq! and press Enter to save the file
chmod +x neatlogic_clear.sh #Add file execution permission
sh neatlogic_clear.sh #Execute the script to uninstall the service
```

script content
```
echo "Clean up neatlogic-web service..."
docker stop neatlogic-web
docker rm neatlogic-web
docker rmi -f neatlogic/neatlogic-web:3.0.0

echo "Clean up neatlogic-runner service..."
docker stop neatlogic-runner
docker rm neatlogic-runner
docker rmi -f neatlogic/neatlogic-runner:3.0.0

echo "Clean up neatlogic service..."
docker stop neatlogic
docker rm neatlogic
docker rmi -f neatlogic/neatlogic:3.0.0

echo "Clean up neatlogic-collectdb service..."
docker stop neatlogic-collectdb
docker rm neatlogic-collectdb
docker rmi -f neatlogic/neatlogic-collectdb:1.0.0

echo "Clean up neatlogic-web service..."
docker stop neatlogicdb
docker rm neatlogicdb
docker rmi -f neatlogic/neatlogicdb:1.0.0
```

## common problem

1. Docker did not start when pulling the image<br>
An error message appears ```Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?```
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
![Example image of port occupancy](images/port.png)<br>
When the port is occupied, you can first query the process number of the program specified by the port, and then use the command to close the program running with the port number
```
ps -ef |grep XX #Query the process number command of the port specified program, XX is the port number
kill -9 XX #close the process, XX is the process number
```

## Related operation commands

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
docker start/stop neatlogic
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

<u>Port remarks: mysql (3306), MongoDB (27017), nginx (80), neatlogic (8282)</u>