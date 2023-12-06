中文 / [English](LOCAL_INSTALL.en.md)

# 本地部署教程

## 详细步骤（使用root用户执行）
下载一键部署安装包（目前仅开放支持x86架构的系统，建议在centos7环境下安装）
[点击下载](https://pan.baidu.com/s/1WsTvyIKjK-Bfd3kQzQfnZA?pwd=ccct)
```
	1.拷贝安装包到目标机器的“/”根目录（如果条件不满足，在/目录加软连接对应目录，如： ln -s /home/app/app  /app）
	2.解压安装包
		tar -xvf neatlogic_all_install_community_x86_64.tar.gz
	3.进入install目录执行setup.sh脚本
		cd /app/install && sh setup.sh
```

## 服务详细
|  服务名  |  端口  | 访问地址 | 服务启停命令 | 部署路径(更新版本) | 描述 |
| ----  | ----  | ----  | ---- | ---- | ---- | 
| neatlogic | 8282 | - | deployadmin -s neatlogic -a startall/stopall/restartall | /app/systems/neatlogic/apps/neatlogic.war |tomcat后端服务 ,通过http://虚拟机ip:8282/neatlogic/tenant/check/demo验证服务是否正常 |
| neatlogic-web | 8090 | http://虚拟机ip:8090/demo | service nginx start/stop/restart | /app/systems/neatlogic-web/dist | 前端服务 |
| neatlogic-runner | 8084、tagent心跳端口：8888 | - | deployadmin -s neatlogic-runner -a startall/stopall/restartall | /app/systems/neatlogic/apps/ |执行器runner后端服务，通过http://虚拟机ip:8084/autoexecrunner/anonymous/api/rest/server/health/check/demo验证服务是否正常|
| nginx | - | - | service nginx start/stop/restart | /app/systems/nginx/ | - |
| neatlogicdb | 3306 | - | service neatlogicdb start/stop/restart | /app/databases/neatlogicdb | mysql8数据库 |
| collectdb | 27017 | - | service collectdb start/stop/restart | /app/databases/collectdb | mongodb数据库 |
| neatlogic-autoexec-backend | - | - | - | /app/systems/autoexec/ | - |