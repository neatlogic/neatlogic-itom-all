# 项目部署教程

## Docker环境安装

首先判断待安装服务器是否已安装docker，若已安装则忽略当前步骤；若未安装docker继续执行下方操作。
通过以下命令可以检查docker是否已安装

```
docker --version #查看docker版本，返回版本信息，说明docker已安装
docker-compose --version
```

在服务器新建install-docker.sh文件，复制下面的脚本内容，然后执行。
相关命令

```
cd /tmp #切换到tmp目录
vi  install-docker.sh #创建文件，在文档编辑模式下，复制粘贴下面脚本内容，敲ESC退出编辑，输入:wq!并敲回车保存文件
chmod +x install-docker.sh  #添加文件执行权限
sh install-docker.sh  #执行脚本，安装docker
```

脚本内容
```
#!/bin/bash

# 卸载旧版本
echo ""
echo ""
echo "#########################################################"
echo "# 卸载旧版本 -- 开始                                    #"
echo "#########################################################"
yum -y remove docker docker-common docker-selinux docker-engine
echo "#########################################################"
echo "# 卸载旧版本 -- 结束                                    #"
echo "#########################################################"

# 安装需要的依赖软件包
echo ""
echo ""
echo "#########################################################"
echo "# 安装需要的软件包 -- 开始                              #"
echo "#########################################################"
yum install -y yum-utils device-mapper-persistent-data lvm2
echo "#########################################################"
echo "# 安装需要的软件包 -- 结束                              #"
echo "#########################################################"

# 设置 yum 源，清华镜像仓库，速度很快
echo ""
echo ""
echo "#########################################################"
echo "# 设置 yum 源 -- 开始                                   #"
echo "#########################################################"
#安装wget，如果已安装则会跳过
yum -y install wget
#根据你的发行版下载repo文件:
wget -O /etc/yum.repos.d/docker-ce.repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#把软件仓库地址替换为 TUNA:
#sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
echo "#########################################################"
echo "# 设置 yum 源 -- 结束                                   #"
echo "#########################################################"

# 安装 docker-ce
echo ""
echo ""
echo "#########################################################"
echo "# 安装 docker-ce -- 开始                                #"
echo "#########################################################"
    
yum -y install docker-ce
echo "#########################################################"
echo "# 安装 docker-ce -- 结束                                #"
echo "#########################################################"

# 启动并加入开机启动
echo ""
echo ""
echo "#########################################################"
echo "# 启动并加入开机启动 -- 开始                            #"
echo "#########################################################"
systemctl start docker
systemctl enable docker
echo "#########################################################"
echo "# 启动并加入开机启动 -- 结束                            #"
echo "#########################################################"

# 验证安装是否成功
echo ""
echo ""
echo "#########################################################"
echo "# 验证安装是否成功 -- 开始                              #"
echo "#########################################################"
docker version
echo "#########################################################"
echo "# 验证安装是否成功 -- 结束                              #"
echo "#########################################################"

# 安装docker-compose
echo ""
echo ""
echo "#########################################################"
echo "# 安装docker-compose -- 开始                            #"
echo "#########################################################"
# 从国内镜像 get.daocloud.io 快速下载
curl -L https://get.daocloud.io/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "#########################################################"
echo "# 安装docker-compose -- 结束                            #"
echo "#########################################################"

# 验证安装是否成功
echo ""
echo ""
echo "#########################################################"
echo "# 验证安装是否成功 -- 开始                              #"
echo "#########################################################"
docker-compose --version
echo "#########################################################"
echo "# 验证安装是否成功 -- 结束                              #"
echo "#########################################################"

# 添加 docker 国内镜像站点并重启docker
echo ""
echo ""
echo "#########################################################"
echo "# 添加 docker 国内镜像站点并重启docker -- 开始          #"
echo "#########################################################"
if [[ ! -d "/etc/docker" ]];then 
	mkdir -p /etc/docker
fi
EXISTS_MIRRORS=`grep registry-mirrors /etc/docker/daemon.json`
if [[ ! -n "$EXISTS_MIRRORS" ]]; then 
	echo '{ "registry-mirrors": [ "https://registry.docker-cn.com" ] }' >> /etc/docker/daemon.json
fi 
systemctl restart docker
echo "#########################################################"
echo "# 添加 docker 国内镜像站点并重启docker -- 结束          #"
echo "#########################################################"

echo ""
echo ""
echo "install Success!"
echo ""
echo ""
```

## 在目标机器部署服务

在服务器新建neatlogic_setup.sh文件，复制下面的脚本内容，然后执行。

```
cd /tmp #切换到tmp目录
vi  neatlogic_setup.sh #创建文件，在文档编辑模式下，复制粘贴下面脚本内容，敲ESC退出编辑，输入:wq!并敲回车保存文件
chmod +x neatlogic_setup.sh  #添加文件执行权限
sh neatlogic_setup.sh  #执行脚本，部署服务
```

脚本内容
```
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
```

## 服务一键卸载

在服务器添加neatlogic_clear.sh文件，复制下面的脚本内容，然后执行。

```
cd /tmp #切换到tmp目录
vi  neatlogic_clear.sh #创建文件，在文档编辑模式下，复制粘贴下面脚本内容，敲ESC退出编辑，输入:wq!并敲回车保存文件
chmod +x neatlogic_clear.sh  #添加文件执行权限
sh neatlogic_clear.sh  #执行脚本，卸载服务
```

脚本内容
```
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
```

## 常见问题

1. 拉取镜像时docker未启动<br>
出现报错信息```Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?```
说明docker未启动，启动docker后再重新执行部署文件即可。
2. 重新拉取镜像前未卸载服务，导致服务、容器被占用<br>
出现报错信息```Error response from daemon: network with name neatlogic already exists```，说明服务neatlogic已在运行，需停止服务。<br>
出现报错信息```docker: Error response from daemon: Conflict, The container name "/neatlogic-xxx" is already in use by container "xxxxxxxx". You have to remove (or rename) that container to be able to reuse that name.```，说明存在与/neatlogic-xxx同名的容器，需停止容器并删除容器和相关镜像。
3. 服务端口被占用<br>
执行下面命令可以查看端口占用情况<br>
```
netstat -anp |grep XX  #XX是端口号
```
如图，如果有LISTEN那一行，就表示端口被占用。此处注意，图中显示的LISTENING并不表示端口被占用，不要和LISTEN混淆哦，查看具体端口时候，必须要看到tcp、端口号、LISTEN那一行，才表示端口被占用了<br>
![端口占用示例图](images/port.png)<br>
端口被占用时，可以先查询该端口指定程序的进程号，然后使用命令关闭使用该端口号运行的程序
```
ps -ef |grep XX  #查询该端口指定程序的进程号命令，XX是端口号
kill -9 XX  #关闭进程，XX是进程号
```

## 相关操作命令

**1、部署，docker run -it --name 容器名称  -p 操作系统端口:容器端口 --net 网络名称 -d  镜像:版本**<br>
```
docker run -it --name neatlogic -p 8282:8282 --net neatlogic  -d neatlogic/neatlogic:3.0.0
```

**2、进入容器内部，docker exec -it  [容器名称|容器ID]  /bin/sh**<br>
```
docker exec -it neatlogic /bin/sh
```

**3、查看容器日志，docker logs [容器名称|容器ID]**<br>
```
docker logs neatlogic
```

**4、容器启停，docker  start/stop  [容器名称|容器ID]**<br>
```
docker start/stop  neatlogic
```

**5、删除容器，docker rm  [容器名称|容器ID]**<br>
```
docker rm neatlogic
```

**6、删除镜像，docker rm  [镜像ID|镜像名称：版本]**<br>
```
docker rmi -f  neatlogic/neatlogic:3.0.0
```

**7、容器网络：**<br>
```
docker network ls   #查看所有
docker network create  xxxx   #创建网络，默认是桥接**
```

<u>端口备注说明：mysql（3306）、MongoDB（27017）、nginx（80）、neatlogic（8282）</u>




