![NeaLogic](https://github.com/neatlogic/.github/blob/main/images/logo.png?raw=true)

<p align="left">
     <a href="https://opensource.org/licenses/Apache-2.0" alt="License">
         <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
</p>

[中文](README.md) / English

## About
NeatLogic is a progressive ITOM platform dedicated to providing ITOM solutions for users of different types and sizes. In addition to the open source version, we also provide secondary development, consulting and other services for enterprise customers. For inquiries, please contact chenqw@neatlogic.com
![index](README_IMAGES/index.png)

NeatLogic natively supports multi-tenancy (middleware sharing, database sub-tenant mode), modular expansion, already includes key core functions such as process engine, form engine, report engine, large screen, dashboard, etc., functions sensitive to data scale, such as CMDB Fully considered in the design, taking into account the performance requirements of reports and daily use. When only basic functions are used, only Tomcat, Nginx, and Mysql8+ are required, and some advanced functions, such as automatic collection, require MongoDb. \
NeatLogic provides docker image deployment mode and installation package deployment mode. It comes with all databases and middleware. All key services are encapsulated with start and stop commands. Middleware, software packages and configuration files are separated to facilitate users' daily maintenance.

## Runtime
Operating system: Linux, java version: 8+, process memory: 4G or more, 8G is recommended, file storage supports local storage, NAS or MiniIo by default, and can connect to third-party object storage services. Back-end middleware: Tomcat9.X+, front-end middleware: Nginx, database: Mysql8+, Mongodb4+.

## Project Structure
NeatLogic manages code in a modular fashion.
* neatlogic-itom-all is convenient for users to obtain all codes at one time.
* neatlogic-parent is used to manage global pom files and manage all public third-party package references.
* neatlogic-webroot is used to generate war packages and manage submodule references. The pom file can be modified as needed to load different submodules to generate the final war package.
* neatlogic-framework is the basic module, all submodules need to refer to neatlogic-framework, and all submodules of neatlogic-framework beans can be woven into.
* neatlogic-tenant is the bean of the api part of the basic function, and other sub-modules are not visible.
* neatlogic-web is the front-end code.
* neatlogic-master is the backend code of the tenant management module, which is used to manage the tenant information of neatlogic.
* neatlogic-master-web is the front-end code of the tenant management module, which needs to be deployed separately from neatlogic-web during deployment.
* Each of the remaining functional modules needs to be split into two code modules, namely neatlogic-xxx and neatlogic-xxx-base. Since maven does not support cross-references, neatlogic-xxx-base is mainly used to be referenced by other modules, mainly for pojo and some low-level interfaces. neatlogic-xxx needs to reference neatlogic-xxx-base, which mainly contains its own exclusive business beans.


## Module list
| module | dependencies | description |
| --- | --- | --- |
| neatlogic-framework | | - Scheduled jobs: You can customize scheduled jobs through plug-ins. <br>- Integrated management: centralized management of third-party interfaces, format conversion of input and output parameters, and audit function. <br>- Health check: with slow sql location, online threaddump and other capabilities, database defragmentation capabilities. <br>- Index management: full-text search index management. <br>- Subscription management: docking with the third-party MQ system, the system's own MQ is Active MQ. Subscription topics can be extended through plug-ins. <br>- Others: user management, authority management, operation record auditing, etc. |
| neatlogic-cmdb | neatlogic-framework | - Automatic collection: Based on Tagent, API, and public protocols, automatically collect assets and asset relationships. <br>- Model management: asset data model, data relationship definition, maintenance. <br>- Configuration item management: daily maintenance of asset data. <br>- Batch import: Asset data batch import configuration management platform. <br>- Transaction audit: asset data changes, with the process engine and ITSM module can pre-approval process, after the approval is completed, the changes will take effect; all change records in the asset life cycle can be queried. <br>- Custom view: Create a custom virtual view by connecting multiple models to meet observation data in different dimensions. <br>- Permission group: flexible data permission strategy, users or roles, organizations can be selected, filter rules can be set for the specified model, and viewing and editing permissions can be configured. <br>- Resource Center: From the perspective of application and infrastructure, it provides the management page and consumption interface of IP assets, and also provides the account management function of IP assets. | section |
| neatlogic-itsm | neatlogic-framework |The unified reporting platform for operation and maintenance events is a process management platform for daily affairs such as service requests, events, problems, changes, knowledge bases, contracts, suppliers, etc.<br> - Custom Process: For different usage scenarios, customize the reporting process suitable for the current usage scenario. <br>- Custom form: Customize form components, layouts, and data sources for different usage scenarios. <br>- Service catalog management: plan user reporting channels, channel permissions, and channel association processes. <br>- SLA policy: service timeliness commitment, SLA policy can be flexibly configured according to combined condition information such as priority, reporting person, and form value. <br>- Work Order Center: Set user personalized filters and create personal directories. <br>- Assignment strategy: can be assigned to individuals, roles, and groups; assign strategies can be configured based on reported data, and work orders can be automatically assigned, such as assignment by application owner, assignment by workload, assignment by schedule. <br>- Knowledge base: automatically generate knowledge from work orders; knowledge templates; knowledge maintenance; set knowledge viewing and maintenance permissions through knowledge circle policies. | is |
| neatlogic-knowledge | neatlogic-framework | knowledge base module |
| neatlogic-event |neatlogic-framework, neatlogic-process |event management module, need to be used together with ITSM module |
| neatlogic-change | neatlogic-framework, neatlogic-process | change management module, need to be used together with ITSM module |
| neatlogic-autoexec | neatlogic-framework, neatlogic-cmdb |Automated and standardized daily operation and maintenance operation platform, which can be used for software installation, software start and stop, configuration backup, configuration check, configuration change, automatic collection, SQL execution, etc.<br> - Tool library: The platform comes with common tools that support software installation, software start and stop, configuration backup, configuration check, configuration change, automatic collection, SQL execution and other operations. <br>- Custom tool library: Create user-defined scripts to cover operation and maintenance scenarios other than the built-in tool library; support script approval and script version records. <br>- Arrangement management: custom tool arrangement, serial, parallel, conditional split, batch operation and other settings; arrangement approval, arrangement version control. <br>- Job process control: job start, pause, stop, rerun; real-time synchronization of script running logs; real-time synchronization of job scheduling logs. <br>- Global parameters/parameter files: commonly used parameters are pre-defined, and parameters can be imported with one click. <br>- Script/command delivery: self-contained agent; scripts and commands can also be delivered through public protocols. |
| neatlogic-deploy | neatlogic-framework, neatlogic-autoexec |Application automatic compilation, deployment, code merging<br>- Scenario coverage: start and stop, compile, deploy, rollback; support Docker. <br>- Application pipeline: custom pipeline; application, sub-application and environment support pipeline hierarchical inheritance. <br>- Pipeline scenario: Prune the complete pipeline and save it as multiple scenarios. An application only needs to configure one pipeline, and set the start, stop, restart, compile, compile&deploy, rollback and other scenarios. <br>- Configuration modification: support the overall replacement and partial replacement of configuration files in different environments. <br>- Product management: built-in product management library, support third-party product library such as nexus and so on. <br>- Version management: record version products, version releases in each environment, and version quality. <br>- Batch release: Pipeline arrangement, supports serial and parallel, can solve the problem of system release sequence dependency. <br>- Release process control: job start, pause, stop, rerun; real-time synchronization of script running logs; real-time synchronization of job scheduling logs. |
| neatlogic-dashboard | neatlogic-framework | Custom Dashboard |
| neatlogic-report | neatlogic-framework | custom report and large screen |
| neatlogic-pbc | neatlogic-framework、neatlogic-cmdb | Financial basic data reporting platform of the People's Bank of China (bank users just need it, other users can ignore it)|
| neatlogic-inspect | neatlogic-framework, neatlogic-autoexec | Daily inspection of operating systems, hardware servers, virtualization, middleware, databases, network devices, containers, storage devices and other infrastructure, discover potential risks and alert<br> - Application inspection: Check the health of all components of an application. <br>- Asset inspection: From the perspective of infrastructure management, such as checking the health of all network devices. <br>- Configuration file comparison: check configuration files of applications, servers, and services, and record configuration file change records. <br>- Custom Thresholds: Configure asset health indicator thresholds. <br>- Patrol inspection report: The inspection results are in the form of reports, archived and saved or exported for viewing. <br>- Latest Issues: In the full infrastructure, the collection of assets that currently have health issues and the report on the specific issues of each asset. |

## Quick start
* online demo
preparing……

* docker deployment
[Click to view docker deployment manual](QUICK_START.en.md)

## Contact us
   <img src="README_IMAGES/qq.jpeg" width="300" /></a>