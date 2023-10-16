中文 / [English](QUICK_START.en.md)
# 项目部署教程

## Docker环境检查

检查docker版本(返回版本信息，说明docker已安装)
```
docker --version
docker-compose --version
```
> 注意:请确保docker已安装,才能进行后续步骤
## 安装
先下载 [docker-compose.yml](docker-compose.yml),该配置文件是docker compose的核心，用于定义服务、网络和数据卷。
> 注意:如果需要用到 [neatlogic-runner](../../../neatlogic-runner/blob/develop3.0.0/README.md) ,还需要修改[docker-compose.yml](docker-compose.yml)文件中NEATLOGIC_RUNNER_HOST环境变量,设置为runner容器所在的宿主机ip

如果不做修改,直接执行启动命令
```
  docker-compose -f docker-compose.yml up -d  #-f 表示执行指定yml, -d 表示后台执行并返回
```
默认会安装一下容器服务:
|  容器服务名  |  默认宿主机端口  | 启动容器服务依赖 | 访问地址 |容器内服务启停命令 |   描述 |
| ----  | ----  | ----  | ---- | ---- | ---- |
|  neatlogic-db  |  3306  | - | - |  启： /app/databases/neatlogicdb/scripts/neatlogicdb start<br>停： /app/databases/neatlogicdb/scripts/neatlogicdb stop  |mysql数据库|
|  neatlogic-collectdb |  27017  | - | - |   启：/app/databases/collectdb/bin/mongod --config /app/databases/collectdb/conf/mongodb.conf<br>停：<br>mongo 127.0.0.1:27017/admin -uadmin -p u1OPgeInMhxsNkNl << EOF<br>db.shutdownServer();<br>exit;<br>EOF  |mongodb,如果使用cmdb自动采集、自动化、巡检、发布则需要该服务 |
|  neatlogic-runner  |  8084、8888 | - | - | 启：java -jar -Xbootclasspath/a:/app/config/ -Dspring.config.location=/app/config/application.properties /app/neatlogic-runner.jar<br>停：kill 掉对应的neatlogic-runner 进程 |执行器,如果使用发布、巡检、自动化、tagent则需要该服务 |
|  neatlogic-app  |  8282  | neatlogic-db <br> neatlogic-collectdb <br>neatlogic-runner<br>neatlogic-nacos| - | 启：sh /app/apache-tomcat-9.0.73/bin/startup.sh<br>停：kill 掉对应的tomcat实例进程 | 后端服务|
|  neatlogic-web  |  8090  | neatlogic-app | 宿主机IP:8090  |启：/app/nginx/sbin/nginx<br>重启：/app/nginx/sbin/nginx -s reload <br>停：kill xx | 前端服务|
|  neatlogic-nacos | 8848 | neatlogic-db | 宿主机IP:8848/nacos |启: deployadmin -s nacos -a startall <br>停： deployadmin -s nacos -a stopall| 后端服务 config ,账号/密码 nacos/nacos|

## 验证
因为docker容器服务启动是异步的,所以以上提到的启动命令执行完也不代表服务都正常启动完了.<br>
仍需要等待几分钟时间后访问前端服务:http://宿主机ip:8090/ 如果出现登录页面,恭喜你服务部署成功.登录账号:admin 密码:neatlogic@901<br>
如果提示租户不存在,则需要查看下日志,可能是服务还在等待启动中
```
docker-compose -f docker-compose.yml logs -f neatlogic-web
```
如果日志出现neatlogic-web service start.那就需要进入neatlogic-app容器，查看错误日志/app/logs/neatlogic/error.log 和启动日志/app/apache-tomcat-9.0.73/logs/catalina.out 
如果日志中出现error,则将最后的截图（最好是整个日志文件）联系我们:
- **企业微信** <br>
<p align="left"><img src="https://gitee.com/neat-logic/neatlogic-itom-all/raw/develop3.0.0/README_IMAGES/contact_me.png" width="150" /></p>
<p><b>原交流群用户已满，正在处理中，如需交流请加入以下临时交流群。</b></p>
<p align="left"><img src="https://gitee.com/neat-logic/neatlogic-itom-all/raw/develop3.0.0/README_IMAGES/wechat.jpg" width="200" /></p>


## 按需修改配置 docker-compose.yml
### 一般常见需要修改的场景:
**1、数据持久化**
默认是没有配置持久化的,持久化配置国庆后更新...

**2、宿主机端口冲突**

修改 ports 字段即可,例如neatlogic-web的8090端口冲突,则需要将左侧的宿主机端口改成非占用端口即可,如我要改成8081:
```
  ports:
    - "8090:8081"
```

**3、不使用自带的容器服务**

如无需某容器服务则只需要删除对应容器服务配置,且修改对应被依赖的容器服务的environment属性<br>
如无需neatlogic-db,因neatlogic-db被neatlogic-app和neatlogic-nacos依赖,所以neatlogic-app和neatlogic-nacos都需要修改environment的MYSQL_SERVICE_HOST、MYSQL_SERVICE_PORT、MYSQL_SERVICE_USER、MYSQL_SERVICE_PASSWORD,如:<br>
自定义使用外部mysqldb 192.168.1.33:3306,帐号/密码:app/123456
```
  environment:
    #连接的mysql配置
    MYSQL_SERVICE_HOST: "192.168.1.33"
    MYSQL_SERVICE_PORT: 3306
    ...
    MYSQL_SERVICE_USER: app
    MYSQL_SERVICE_PASSWORD: "123456"
```
# 常用COMMAND
## 启动
根据yml创建容器并启动所有容器服务
```
  docker-compose -f docker-compose.yml up -d  #-f 表示执行指定yml, -d 表示后台执行并返回
```
如果只需要处理某个容器服务,只需要在命令后补充容器服务名即可,如:
```
  docker-compose -f docker-compose.yml up -d neatlogic-app #单独重新创建并启动neatlogic-app服务
```

## 查看日志
查看所有容器服务的日志
```
  docker-compose -f docker-compose.yml logs
```
如果只需要查看某个容器服务的日志,只需要在命令后补充容器服务名即可,如:
```
  docker-compose -f docker-compose.yml logs neatlogic-app
```
### 实时查看日志
```
  docker-compose -f docker-compose.yml logs -f
```

## 查看启动成功的容器
```
  docker-compose -f docker-compose.yml ps
```

## 启停容器
### 启容器
```
  docker-compose -f docker-compose.yml start
```
### 停容器
```
  docker-compose -f docker-compose.yml stop 
```
如果只需要启某个容器,只需要在命令后补充容器服务名即可,如:
```
  docker-compose -f docker-compose.yml start neatlogic-app
```

## 进入容器服务
>非必要用户无需进入容器服务,如进去neatlogic-app容器服务:
```
  docker-compose -f docker-compose.yml exec neatlogic-app sh
```
## 停止并移除容器，网络，镜像和卷
```
  docker-compose -f docker-compose.yml down 
```

## 批量拉取镜像
```
  docker-compose -f docker-compose.yml pull
```

## demo样例数据参考
由于考虑到环境的干净,镜像只保留了核心数据.如果仍需要更多的样例数据作为参考,可执行一下步骤
  1. 请先创建了3个空库neatlogic、neatlogic_demo和neatlogic_demo_data,字符集采用utf8mb4，排序规则采用utf8mb4_general_ci，由于neatlogic需要动态创建、删除表和视图，请授予数据库连接用户适当的权限，如下图。
   ![](README_IMAGES/BUILD/database.png)
  2. 导入样例数据:[neatlogic-database/mysql](../../../neatlogic-database/blob/develop3.0.0/mysql) 将三个sql文件按名字分别导入到三个库。
  3. 修改neatlogic库的datasource表，找到tenant_uuid=demo的那行数据，核对username、password、host和port是否正确配置