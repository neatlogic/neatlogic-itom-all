![NeaLogic](README_IMAGES/logo.png)

<p align="left">
    <a href="https://opensource.org/licenses/Apache-2.0" alt="License">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
<a target="_blank" href="https://join.slack.com/t/slack-lyi2045/shared_invite/zt-1sok6dlv5-WzpKDpnXQLXc92taC1qMFA">
<img src="https://img.shields.io/badge/Slack-Neatlogic-orange" /></a>
</p>

中文 / [English](README.en.md)

## 关于
NeatLogic是一套渐进式ITOM平台，致力为不同类型不同规模用户提供ITOM解决方案。除了开源版本，我们也为企业客户提供二次开发、咨询等服务，咨询请联系chenqw@neatlogic.com
![index](README_IMAGES/index.png)

NeatLogic原生支持多租户（中间件共享，数据库分租户模式），模块化扩展，已包含流程引擎、表单引擎、报表引擎、大屏、仪表板等关键核心功能，对数据规模敏感的功能，例如CMDB在设计上做了充分考虑，同时兼顾报表和日常使用的性能要求。仅使用基本功能情况下，仅需要Tomcat、Nginx和Mysql8+，部分高级功能，例如自动采集需要使用MongoDb。\
NeatLogic提供docker镜像部署模式和安装包部署模式，自带所有数据库和中间件，所有关键服务都封装了启停命令，中间件、软件包和配置文件都做了分离，方便用户日常维护。

## 运行环境
操作系统：Linux，java版本：8+，进程内存：4G以上，建议8G，文件存储默认支持本地存储、NAS或MinIo，可以对接第三方对象存储服务。后端中间件：Tomcat9.X+，前端中间件：Nginx，数据库：Mysql8+、Mongodb4+。

## 项目组织
NeatLogic采用模块化方式管理代码。
* neatlogic-itom-all方便用户一次性获取所有代码。
* neatlogic-parent用于管理全局pom文件，管理所有公共第三方包引用。
* neatlogic-webroot用于生成war包和管理子模块引用，可根据需要修改pom文件加载不同子模块生成最终的war包。
* neatlogic-framework是基础模块，所有子模块都需要引用neatlogic-framework，neatlogic-framework的bean所有子模块均可织入。
* neatlogic-tenant是基础功能的api部分bean，其他子模块不可见。
* neatlogic-web是前端代码。
* neatlogic-master是租户管理模块后端代码，用于管理neatlogic的租户信息。
* neatlogic-master-web是租户管理模块前端代码，部署时需要和neatlogic-web分开部署。
* 其余每个功能模块都需要分拆成两个代码模块，分别是neatlogic-xxx和neatlogic-xxx-base。由于maven不支持交叉引用，neatlogic-xxx-base主要用于被其他模块引用，主要放pojo和一些底层接口。neatlogic-xxx需要引用neatlogic-xxx-base，主要放自身独占的业务bean。


## 功能模块
| 模块 | 依赖 | 描述 | 
| --- | --- | --- | 
| neatlogic-framework | | - 定时作业：可通过插件方式自定义定时作业。<br>- 集成管理：第三方接口集中管理，可对输入输出参数进行格式转换，具备审计功能。<br>- 健康检查：具备慢sql定位，在线threaddump等能力，数据库碎片整理能力。<br>- 索引管理：全文检索索引管理。<br>- 订阅管理：与第三方MQ系统对接，系统自带MQ是Active MQ。可通过插件方式扩展订阅主题。<br>- 其他：用户管理、权限管理、操作记录审计等。 | 
| neatlogic-cmdb | neatlogic-framework | - 自动采集：基于Tagent、API、公有协议，自动采集资产、资产关系。<br>- 模型管理：资产数据模型、数据关系定义，维护。<br>- 配置项管理：资产数据日常维护。<br>- 批量导入：资产数据批量导入配置管理平台。<br>- 事务审计：资产数据变更，配合流程引擎和ITSM模块可前置审批过程，审批完成后变更生效；可查询资产生命周期所有变更记录。<br>- 自定义视图：通过连接多个模型创建自定义虚拟视图，满足不同维度观测数据。<br>- 权限团体：灵活的数据权限策略，可选择用户或角色、组织机构，对指定的模型，设置过滤规则，配置查看、编辑权限。<br>- 资源中心：以应用视角、基础架构视角，提供IP资产的管理页面、消费接口，另外提供IP资产的帐号管理功能。 | 部分 |
| neatlogic-itsm | neatlogic-framework |运维事件统一上报平台，是用于企业的服务请求、事件、问题、变更、知识库、合同、供应商等日常事务的流程管理平台<br> - 自定义流程：针对不同使用场景，自定义适合当前使用场景的上报处理流程。<br>- 自定义表单：针对不同使用场景，自定义表单的组件、布局、数据源。<br>- 服务目录管理：规划用户上报通道，通道权限，通道关联流程。<br>- SLA策略：服务时效承诺，可根据优先级、上报人、表单值等组合条件信息灵活配置SLA策略。<br>- 工单中心：设置用户个性化过滤器，创建个人目录。<br>- 分派策略：可指派至个人或角色、分组；可根据上报数据，配置分派策略，自动分派工单，如按应用归属人分派，按工作量分派，按排班表分派。<br>- 知识库：工单自动生成知识；知识模板；知识维护；通过知识圈策略设置知识查看、维护权限。 | 是 | 
| neatlogic-knowledge | neatlogic-framework | 知识库模块 | 
| neatlogic-event |neatlogic-framework、neatlogic-process |事件管理模块，需要和ITSM模块一起使用 | 
| neatlogic-change | neatlogic-framework、neatlogic-process | 变更管理模块，需要和ITSM模块一起使用 | 
| neatlogic-autoexec | neatlogic-framework、neatlogic-cmdb  |自动化、标准化的日常运维操作平台，可用于软件安装、软件启停、配置备份、配置检查、配置变更、自动采集、SQL执行等<br>- 工具库：平台自带常用工具，支持软件安装、软件启停、配置备份、配置检查、配置变更、自动采集、SQL执行等操作。<br>- 自定义工具库：创建用户自定义脚本，用于覆盖自带工具库以外运维场景；支持脚本审批、脚本版本记录。<br>- 编排管理：自定工具编排，串行、并行、条件分流、分批运行等设置；编排审批、编排版本控制。<br>- 作业过程控制：作业启动、暂停、中止、重跑；脚本运行日志实时同步；作业调度日志实时同步。<br>- 全局参数/参数文件：常用参数预定义，一键导入参数。<br>- 脚本/命令下发：自带agent；也可通过公有协议下发脚本、命令。 | 
| neatlogic-deploy | neatlogic-framework、neatlogic-autoexec  |应用自动编译、部署，代码归并<br>- 场景覆盖：启停、编译、部署、回退；支持Docker。<br>- 应用流水线：自定义流水线；应用、子应用、环境支持流水线层级继承。<br>- 流水线场景：将完整流水线剪枝，保存为多个场景，一个应用仅需配置一个流水线，并设置启、停、重启、编译、编译&部署、回退等场景。<br>- 配置修改：支持不同环境下的配置文件整体替换、部份替换。<br>- 制品管理：内置制品管理库，支持第三方制品库如nexus等。<br>- 版本管理：记录版本制品、版本在个环境的发布情况、版本质量。<br>- 批量发布：流水线编排，支持串行、并行，可解决系统发版顺序依赖问题。<br>- 发布过程控制：作业启动、暂停、中止、重跑；脚本运行日志实时同步；作业调度日志实时同步。 | 
| neatlogic-dashboard | neatlogic-framework | 自定义仪表板 | 
| neatlogic-report | neatlogic-framework  | 自定义报表和大屏| 
| neatlogic-pbc | neatlogic-framework、neatlogic-cmdb  | 人民银行金融基础数据上报平台（银行用户刚需，其他用户可以无视）| 
| neatlogic-inspect | neatlogic-framework、neatlogic-autoexec |对操作系统、硬件服务器、虚拟化、中间件、数据库、网络设备、容器、存储设备等基础设施的日常检查，发现潜在风险并告警<br> - 应用巡检：检查某个应用所有组件的健康性。<br>- 资产巡检：基础架构管理角度，如检查所有网络设备的健康性。<br>- 配置文件比对：对应用、服务器、服务的配置文件检查，记录配置文件变更记录。<br>- 自定义阈值：配置资产健康性指标阈值。<br>- 巡检报告：巡检结果以报告形式，归档保存或导出查看。<br>- 最新问题：全量基础设施中，当前存在健康性问题的资产集合以及各个资产具体问题的报告。 | 

## 快速开始
* 获取代码
  签出neatlogic-itom-all可以一次性获取所有模块代码，由于neatlogic-itom-all使用submodule引入模块，签出代码时需加上--recurse-submodules参数。\范例：
  ```
  git clone url --recurse-submodules
  ```

* 在线演示
准备中……

* docker部署
[点击查看docker部署手册](QUICK_START.md)


## 技术交流
  [Neatlogic in Slack](https://join.slack.com/t/slack-lyi2045/shared_invite/zt-1sok6dlv5-WzpKDpnXQLXc92taC1qMFA)



