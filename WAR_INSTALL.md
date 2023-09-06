中文 / [English](CODE-BUILD.en.md)

# war打包教程

## 前提条件
先安装好jdk1.8、maven3.8+和git

# 1.拉取项目代码
```
git clone https://gitee.com/neat-logic/neatlogic-itom-all.git  --recurse-submodules
```
# 2.进入 neatlogic-itom-all 文件夹
```
cd neatlogic-itom-all
```
# 3.install neatlogic-parent父模块
```
cd neatlogic-parent
mvn install
```

# 4.install neatlogic-webroot 生成war包
```
cd ../neatlogic-webroot
mvn clean compile -U install -P develop
```


