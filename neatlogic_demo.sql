/*
 Navicat Premium Data Transfer

 Source Server         : 
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : 
 Source Schema         : neatlogic_demo

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 25/05/2023 17:15:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for api
-- ----------------------------
DROP TABLE IF EXISTS `api`;
CREATE TABLE `api` (
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'token',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `module_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模块id',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名称',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '密码',
  `config` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'json格式',
  `is_active` tinyint DEFAULT NULL COMMENT '是否启用',
  `expire` timestamp(3) NULL DEFAULT NULL COMMENT '过期时间',
  `description` varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `authtype` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'auth认证',
  `type` enum('object','stream','binary') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'object' COMMENT '类型',
  `need_audit` tinyint(1) DEFAULT NULL COMMENT '是否记录日志',
  `qps` double DEFAULT '0' COMMENT '每秒访问几次，大于0生效',
  `timeout` int DEFAULT NULL COMMENT '请求时效',
  `create_time` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='接口表';

-- ----------------------------
-- Table structure for api_access_count
-- ----------------------------
DROP TABLE IF EXISTS `api_access_count`;
CREATE TABLE `api_access_count` (
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'token',
  `count` int DEFAULT NULL COMMENT '访问次数',
  PRIMARY KEY (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='接口访问次数表';

-- ----------------------------
-- Table structure for api_audit
-- ----------------------------
DROP TABLE IF EXISTS `api_audit`;
CREATE TABLE `api_audit` (
  `id` bigint NOT NULL COMMENT '记录id',
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接口token',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '访问用户uuid',
  `authtype` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '认证方式',
  `server_id` int NOT NULL COMMENT '请求处理服务器id',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请求ip',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `time_cost` bigint DEFAULT NULL COMMENT '处理请求耗时',
  `status` enum('succeed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `param_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数路径',
  `result_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结果路径',
  `error_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误路径',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_api_audit_start_time` (`start_time`) USING BTREE,
  KEY `idx_api_audit_token` (`token`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='接口记录表';

-- ----------------------------
-- Table structure for audit_config
-- ----------------------------
DROP TABLE IF EXISTS `audit_config`;
CREATE TABLE `audit_config` (
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审计类型',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '审计配置',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='控制所有审计的配置信息';

-- ----------------------------
-- Table structure for audit_file
-- ----------------------------
DROP TABLE IF EXISTS `audit_file`;
CREATE TABLE `audit_file` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件hash',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '日志文件路径',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='接口文件表';

-- ----------------------------
-- Table structure for autoexec_catalog
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_catalog`;
CREATE TABLE `autoexec_catalog` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `parent_id` bigint NOT NULL COMMENT '父id',
  `lft` int DEFAULT NULL COMMENT '左编码',
  `rht` int DEFAULT NULL COMMENT '右编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_lft_rht` (`lft`,`rht`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工具目录';

-- ----------------------------
-- Table structure for autoexec_combop
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_combop`;
CREATE TABLE `autoexec_combop` (
  `id` bigint NOT NULL COMMENT '如果从工具/脚本则直接生成combop则使用对应id，否则id自动生成',
  `uk` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `type_id` bigint NOT NULL COMMENT '类型id',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态 1：启用 0：禁用',
  `operation_type` enum('script','tool','combop') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工具/脚本/流水线',
  `notify_policy_id` bigint DEFAULT NULL COMMENT '通知策略id',
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '维护人',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建用户',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组合工具信息表';

-- ----------------------------
-- Table structure for autoexec_combop_authority
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_combop_authority`;
CREATE TABLE `autoexec_combop_authority` (
  `combop_id` bigint NOT NULL COMMENT '流水线id',
  `type` enum('common','role','user','team') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '对象类型',
  `uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '对象uuid',
  `action` enum('edit','execute','view') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权类型',
  PRIMARY KEY (`combop_id`,`uuid`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组合工具授权表';

-- ----------------------------
-- Table structure for autoexec_combop_group
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_combop_group`;
CREATE TABLE `autoexec_combop_group` (
  `id` bigint NOT NULL COMMENT 'id',
  `combop_id` bigint NOT NULL COMMENT '组合工具id',
  `sort` int DEFAULT NULL COMMENT '序号',
  `policy` enum('oneShot','grayScale') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'oneShot:并发 grayScale:按批次轮询组内phase',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组合工具组';

-- ----------------------------
-- Table structure for autoexec_combop_param
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_combop_param`;
CREATE TABLE `autoexec_combop_param` (
  `combop_id` bigint NOT NULL COMMENT '流水线id',
  `key` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中文名',
  `default_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '参数值',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `is_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否必填 1:必填 0:选填',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文本、密码、文件、日期、节点信息、全局变量、json对象',
  `sort` int NOT NULL COMMENT '排序',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  `editable` tinyint(1) DEFAULT NULL COMMENT '是否可编辑',
  PRIMARY KEY (`combop_id`,`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组合工具参数表';

-- ----------------------------
-- Table structure for autoexec_combop_param_matrix
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_combop_param_matrix`;
CREATE TABLE `autoexec_combop_param_matrix` (
  `combop_id` bigint NOT NULL COMMENT '流水线id',
  `key` varchar(70) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名',
  `matrix_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '矩阵uuid',
  PRIMARY KEY (`combop_id`,`key`) USING BTREE,
  KEY `idx_matrix_uuid` (`matrix_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组合工具参数引用矩阵关系表';

-- ----------------------------
-- Table structure for autoexec_combop_version
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_combop_version`;
CREATE TABLE `autoexec_combop_version` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `combop_id` bigint DEFAULT NULL COMMENT '组合工具ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT '0' COMMENT '状态',
  `version` int DEFAULT NULL COMMENT '版本号',
  `status` enum('draft','rejected','passed','submitted') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `reviewer` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核人',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for autoexec_customtemplate
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_customtemplate`;
CREATE TABLE `autoexec_customtemplate` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint DEFAULT NULL COMMENT '是否激活',
  `template` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'html模板',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置，json格式',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '首次创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '首次创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最近修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最近修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义模板';

-- ----------------------------
-- Table structure for autoexec_global_param
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_global_param`;
CREATE TABLE `autoexec_global_param` (
  `id` bigint NOT NULL COMMENT '主键id',
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '显示名',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `default_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '参数值',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '值类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布全局参数表';

-- ----------------------------
-- Table structure for autoexec_job
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job`;
CREATE TABLE `autoexec_job` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `status` enum('running','pausing','paused','completed','pending','aborting','aborted','succeed','failed','waitInput','ready','revoked','saved','checked') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作业状态',
  `plan_start_time` timestamp(3) NULL DEFAULT NULL COMMENT '计划开始时间',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `operation_id` bigint DEFAULT NULL COMMENT '脚本/工具/流水线id',
  `operation_type` enum('script','tool','combop','pipeline') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本/工具/流水线',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业来源',
  `round_count` smallint DEFAULT NULL COMMENT '分组数',
  `thread_count` smallint DEFAULT NULL COMMENT '执行线程数',
  `param_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '全局参数hash',
  `exec_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行用户/角色/组 uuid',
  `exec_user_type` enum('team','user','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行用户类型',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '流水线配置',
  `trigger_type` enum('auto','manual') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '触发方式(auto:自动触发;manual)',
  `lncd` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次节点变动时间',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置hash',
  `parent_id` bigint DEFAULT NULL COMMENT '父id，值为-1时，代表该数据是父作业',
  `reviewer` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核人',
  `review_status` enum('passed','failed','waiting') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审核状态',
  `review_time` timestamp(3) NULL DEFAULT NULL COMMENT '审核时间',
  `scenario_id` bigint DEFAULT NULL COMMENT '场景id',
  `runner_map_id` bigint DEFAULT NULL COMMENT 'runner执行类型phase的runnerId',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_typeid` (`operation_type`) USING BTREE,
  KEY `idx_source` (`source`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业表';

-- ----------------------------
-- Table structure for autoexec_job_content
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_content`;
CREATE TABLE `autoexec_job_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置hash',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业参数内容表';

-- ----------------------------
-- Table structure for autoexec_job_env
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_env`;
CREATE TABLE `autoexec_job_env` (
  `job_id` bigint NOT NULL COMMENT '作业id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境变量名',
  `value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '环境变量值',
  PRIMARY KEY (`job_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='作业环境变量表';

-- ----------------------------
-- Table structure for autoexec_job_group
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_group`;
CREATE TABLE `autoexec_job_group` (
  `id` bigint NOT NULL COMMENT 'id',
  `job_id` bigint NOT NULL COMMENT '作业id',
  `sort` int DEFAULT NULL COMMENT '序号',
  `policy` enum('oneShot','grayScale') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'oneShot:并发 grayScale:按批次轮询组内phase',
  `lncd` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次节点变动时间',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '组配置',
  `round_count` int DEFAULT NULL COMMENT '分批数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业组';

-- ----------------------------
-- Table structure for autoexec_job_invoke
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_invoke`;
CREATE TABLE `autoexec_job_invoke` (
  `job_id` bigint NOT NULL COMMENT '作业id',
  `invoke_id` bigint NOT NULL COMMENT '来源id',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源',
  `type` enum('auto','deploy') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源类型',
  `route_id` varchar(32) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置路由ID',
  PRIMARY KEY (`job_id`),
  KEY `idx_invoke_id` (`invoke_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业来源表';

-- ----------------------------
-- Table structure for autoexec_job_phase
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_phase`;
CREATE TABLE `autoexec_job_phase` (
  `id` bigint NOT NULL COMMENT 'id',
  `job_id` bigint NOT NULL COMMENT '作业id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧本名',
  `status` enum('pending','running','pausing','paused','completed','failed','waiting','aborted','aborting','waitInput','ignored') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作业剧本状态',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `exec_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行人',
  `exec_mode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行方式 target runner',
  `round_count` int DEFAULT NULL COMMENT '分批数',
  `sort` int NOT NULL COMMENT '阶段排序',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次更新时间',
  `lncd` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次节点变动时间',
  `node_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '节点来源',
  `user_name_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '用户来源',
  `protocol_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0' COMMENT '协议来源',
  `group_id` bigint DEFAULT NULL COMMENT '组id',
  `execute_policy` enum('first','middl','last') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行策略',
  `warn_count` int DEFAULT NULL COMMENT '警告数量',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '前端uuid',
  `is_pre_output_update_node` tinyint(1) DEFAULT NULL COMMENT '是否通过上游参数更新执行目标',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_jobid_name` (`job_id`,`name`) USING BTREE,
  KEY `idx_jobid_sort` (`job_id`,`sort`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE,
  KEY `idx_jobid_groupid` (`job_id`,`group_id`) USING BTREE,
  KEY `idx_node_from` (`node_from`) USING BTREE,
  KEY `idx_user_name_from` (`user_name_from`) USING BTREE,
  KEY `idx_protocol_from` (`protocol_from`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业阶段表';

-- ----------------------------
-- Table structure for autoexec_job_phase_node
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_phase_node`;
CREATE TABLE `autoexec_job_phase_node` (
  `id` bigint NOT NULL COMMENT 'id',
  `job_id` bigint DEFAULT NULL COMMENT '作业id',
  `job_phase_id` bigint DEFAULT NULL COMMENT '作业阶段id',
  `host` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主机ip',
  `port` int DEFAULT NULL COMMENT '服务端口号',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行目标账号',
  `resource_id` bigint DEFAULT NULL COMMENT '资源id',
  `protocol_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '协议',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '节点名（如：数据库名等）',
  `type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '节点类型',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `status` enum('succeed','pending','failed','ignored','running','aborted','aborting','waitInput','pausing','paused') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次更新时间',
  `is_delete` tinyint DEFAULT '0' COMMENT '是否已删除，目前用于重跑刷新节点',
  `warn_count` int DEFAULT NULL COMMENT '警告数量',
  `is_executed` tinyint(1) DEFAULT '0' COMMENT '是否执行过',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uni_id` (`id`) USING BTREE,
  KEY `idx_jobphaseid_status` (`job_phase_id`,`status`) USING BTREE,
  KEY `idx_jobid` (`job_id`) USING BTREE,
  KEY `idx_host_port` (`host`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE,
  KEY `idx_resource_id_job_phase_id` (`resource_id`,`job_phase_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业阶段节点表';

-- ----------------------------
-- Table structure for autoexec_job_phase_node_runner
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_phase_node_runner`;
CREATE TABLE `autoexec_job_phase_node_runner` (
  `job_id` bigint DEFAULT NULL COMMENT '作业id',
  `job_phase_id` bigint DEFAULT NULL COMMENT '作业剧本id',
  `node_id` bigint NOT NULL COMMENT '作业剧本节点id',
  `runner_map_id` bigint NOT NULL COMMENT '作业剧本节点runner 映射id',
  PRIMARY KEY (`node_id`,`runner_map_id`) USING BTREE,
  KEY `idx_phaseId` (`job_phase_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业阶段节点runner表';

-- ----------------------------
-- Table structure for autoexec_job_phase_operation
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_phase_operation`;
CREATE TABLE `autoexec_job_phase_operation` (
  `job_id` bigint NOT NULL COMMENT '作业id',
  `job_phase_id` bigint NOT NULL COMMENT '作业阶段id',
  `operation_id` bigint DEFAULT NULL COMMENT '作业/工具id',
  `id` bigint NOT NULL COMMENT '作业脚本/工具id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本/工具名',
  `letter` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本/工具名后缀',
  `type` enum('script','tool') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本/工具',
  `parser` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '解析器',
  `exec_mode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行方式',
  `fail_policy` enum('stop','goon') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '失败策略：ignore失败忽略   stop失败中止',
  `param_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数hash',
  `sort` int NOT NULL DEFAULT '0' COMMENT '排序',
  `version_id` bigint DEFAULT NULL COMMENT '脚本版本id',
  `profile_id` bigint DEFAULT NULL COMMENT '预设参数集id',
  `parent_operation_id` bigint DEFAULT NULL COMMENT '父工具id',
  `parent_operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '父工具类型,如if-block的if|else',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '前端工具uuid',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_jobid_operationId` (`job_id`,`operation_id`) USING BTREE,
  KEY `idx_phaseid_opid` (`job_phase_id`,`operation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业阶段操作表';

-- ----------------------------
-- Table structure for autoexec_job_phase_runner
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_phase_runner`;
CREATE TABLE `autoexec_job_phase_runner` (
  `job_id` bigint DEFAULT NULL COMMENT '作业id',
  `job_group_id` bigint DEFAULT NULL COMMENT '作业组id',
  `job_phase_id` bigint NOT NULL COMMENT '作业剧本id',
  `runner_map_id` bigint NOT NULL COMMENT '作业剧本runner 映射id',
  `status` enum('pending','completed','failed','paused','aborted','running','aborting','pausing','waitInput','ignored') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending' COMMENT '状态',
  `is_fire_next` tinyint(1) DEFAULT '0' COMMENT '是否激活firenext',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次更新时间',
  `warn_count` int DEFAULT NULL COMMENT '警告数量',
  PRIMARY KEY (`job_phase_id`,`runner_map_id`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE,
  KEY `idx_job_id` (`job_id`) USING BTREE,
  KEY `idx_runner_map_id` (`runner_map_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业阶段runner表';

-- ----------------------------
-- Table structure for autoexec_job_resource_inspect
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_resource_inspect`;
CREATE TABLE `autoexec_job_resource_inspect` (
  `resource_id` bigint NOT NULL COMMENT '资产id',
  `job_id` bigint DEFAULT NULL COMMENT '作业id',
  `phase_id` bigint DEFAULT NULL COMMENT '作业阶段id',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '巡检时间',
  PRIMARY KEY (`resource_id`) USING BTREE,
  KEY `index_jobid_phaseId` (`job_id`,`phase_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化作业资源巡检';

-- ----------------------------
-- Table structure for autoexec_job_sql_detail
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_job_sql_detail`;
CREATE TABLE `autoexec_job_sql_detail` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `status` enum('pending','running','aborting','aborted','succeed','failed','ignored','waitInput') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `sql_file` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sql文件名称',
  `md5` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sql文件md5',
  `job_id` bigint DEFAULT NULL COMMENT '作业 id',
  `runner_id` bigint DEFAULT NULL COMMENT 'runner id',
  `resource_id` bigint DEFAULT NULL COMMENT '资产 id',
  `node_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业节点名',
  `job_phase_id` bigint DEFAULT NULL COMMENT '作业剧本id',
  `job_phase_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业剧本名称',
  `is_delete` tinyint DEFAULT NULL COMMENT '是否已删除',
  `update_tag` bigint DEFAULT NULL COMMENT '修改时间',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `host` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip',
  `port` int DEFAULT NULL COMMENT '端口',
  `node_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '节点类型',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名',
  `sort` int DEFAULT NULL COMMENT '排序',
  `is_modified` int DEFAULT NULL COMMENT '是否改动',
  `warn_count` int DEFAULT NULL COMMENT '告警个数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_resource_id_job_id_job_phase_name_sql_file` (`resource_id`,`job_id`,`job_phase_name`,`sql_file`) USING BTREE,
  KEY `idx_job_id_job_phase_name` (`job_id`,`job_phase_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化sql详情表';

-- ----------------------------
-- Table structure for autoexec_operation_generate_combop
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_operation_generate_combop`;
CREATE TABLE `autoexec_operation_generate_combop` (
  `combop_id` bigint NOT NULL COMMENT '组合工具id',
  `operation_type` enum('script','tool') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工具或自定义工具',
  `operation_id` bigint DEFAULT NULL COMMENT '工具id或自定义工具id',
  PRIMARY KEY (`combop_id`) USING BTREE,
  KEY `idx_operation_id` (`operation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='组合工具关联表';

-- ----------------------------
-- Table structure for autoexec_profile
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_profile`;
CREATE TABLE `autoexec_profile` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '工具参数',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `system_id` bigint NOT NULL COMMENT '所属系统id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY ` idx_system_id` (`system_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布工具profile表';

-- ----------------------------
-- Table structure for autoexec_profile_cientity
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_profile_cientity`;
CREATE TABLE `autoexec_profile_cientity` (
  `ci_entity_id` bigint NOT NULL COMMENT '配置项id',
  `profile_id` bigint NOT NULL COMMENT ' id',
  PRIMARY KEY (`ci_entity_id`,`profile_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布工具profile配置项关系表';

-- ----------------------------
-- Table structure for autoexec_profile_operation
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_profile_operation`;
CREATE TABLE `autoexec_profile_operation` (
  `operation_id` bigint NOT NULL COMMENT '工具库工具id/自定义工具id',
  `profile_id` bigint NOT NULL COMMENT 'profile id',
  `type` enum('script','tool') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工具类型',
  `update_tag` bigint DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`operation_id`,`profile_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布工具profile和tool、script关系表';

-- ----------------------------
-- Table structure for autoexec_profile_param
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_profile_param`;
CREATE TABLE `autoexec_profile_param` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `profile_id` bigint DEFAULT NULL COMMENT 'profile id',
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'key',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `default_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '默认值',
  `operation_id` bigint DEFAULT NULL COMMENT 'key来源的工具id',
  `operation_type` enum('script','tool') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'key来源的工具类型',
  `update_tag` bigint DEFAULT NULL COMMENT '修改时间',
  `mapping_mode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '值引用类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_profile_id_key` (`profile_id`,`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化profile参数表';

-- ----------------------------
-- Table structure for autoexec_profile_param_value_invoke
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_profile_param_value_invoke`;
CREATE TABLE `autoexec_profile_param_value_invoke` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `profile_param_id` bigint NOT NULL COMMENT 'profile 参数id',
  `value_invoke_id` bigint DEFAULT NULL COMMENT '引用参数id（如：全局参数）',
  `value_invoke_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '值引用类型',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_profile_param_id_value_invoke_id_value_invoke_type` (`profile_param_id`,`value_invoke_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化profile参数值引用表';

-- ----------------------------
-- Table structure for autoexec_risk
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_risk`;
CREATE TABLE `autoexec_risk` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '状态是否启用 1：启用 0：禁用',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `sort` int DEFAULT NULL COMMENT '排序',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建用户',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化操作级别表';

-- ----------------------------
-- Table structure for autoexec_scenario
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_scenario`;
CREATE TABLE `autoexec_scenario` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化场景定义表';

-- ----------------------------
-- Table structure for autoexec_scenario_cientity
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_scenario_cientity`;
CREATE TABLE `autoexec_scenario_cientity` (
  `scenario_id` bigint NOT NULL COMMENT '场景 id',
  `ci_entity_id` bigint NOT NULL COMMENT '应用 id',
  PRIMARY KEY (`ci_entity_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化场景应用关系表';

-- ----------------------------
-- Table structure for autoexec_schedule
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_schedule`;
CREATE TABLE `autoexec_schedule` (
  `id` bigint NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一uuid',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `autoexec_combop_id` bigint NOT NULL COMMENT '组合工具id',
  `begin_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `cron` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'corn表达式',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0:禁用，1:激活',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行配置信息',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业信息表';

-- ----------------------------
-- Table structure for autoexec_script
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script`;
CREATE TABLE `autoexec_script` (
  `id` bigint NOT NULL COMMENT 'id',
  `uk` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识(英文名)',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type_id` bigint DEFAULT NULL COMMENT '分类id',
  `catalog_id` bigint DEFAULT NULL COMMENT '工具目录id',
  `exec_mode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行方式',
  `risk_id` bigint DEFAULT NULL COMMENT '操作级别id',
  `customtemplate_id` bigint DEFAULT NULL COMMENT '自定义模版id',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `default_profile_id` bigint DEFAULT NULL COMMENT '默认profile id',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `is_lib` tinyint DEFAULT '0' COMMENT '是否库文件',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE,
  KEY `idx_type_id` (`type_id`) USING BTREE,
  KEY `idx_catalog_id` (`catalog_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具表';

-- ----------------------------
-- Table structure for autoexec_script_audit
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_audit`;
CREATE TABLE `autoexec_script_audit` (
  `id` bigint NOT NULL COMMENT '主键',
  `script_id` bigint DEFAULT NULL COMMENT '脚本ID',
  `script_version_id` bigint DEFAULT NULL COMMENT '脚本版本ID',
  `operate` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '活动内容hash',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_script_id` (`script_id`) USING BTREE,
  KEY `idx_script_version_id` (`script_version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具活动表';

-- ----------------------------
-- Table structure for autoexec_script_audit_detail
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_audit_detail`;
CREATE TABLE `autoexec_script_audit_detail` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具活动内容表';

-- ----------------------------
-- Table structure for autoexec_script_line
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_line`;
CREATE TABLE `autoexec_script_line` (
  `id` bigint NOT NULL COMMENT 'id',
  `script_id` bigint DEFAULT NULL COMMENT '脚本id',
  `script_version_id` bigint DEFAULT NULL COMMENT '脚本版本id',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本内容hash',
  `line_number` int DEFAULT NULL COMMENT '脚本内容行号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_script_id` (`script_id`) USING BTREE,
  KEY `idx_version_id` (`script_version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具内容行表';

-- ----------------------------
-- Table structure for autoexec_script_line_content
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_line_content`;
CREATE TABLE `autoexec_script_line_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容hash值',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '行脚本内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具内容表';

-- ----------------------------
-- Table structure for autoexec_script_validate
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_validate`;
CREATE TABLE `autoexec_script_validate` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '危险代码',
  `level` enum('warning','critical') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '等级',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具危险代码表';

-- ----------------------------
-- Table structure for autoexec_script_validate_type
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_validate_type`;
CREATE TABLE `autoexec_script_validate_type` (
  `id` bigint NOT NULL COMMENT 'id',
  `validate_id` bigint DEFAULT NULL COMMENT '高危代码id',
  `script_type` enum('xml','python','vbs','shell','perl','powershell','bat') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具危险代码类型表';

-- ----------------------------
-- Table structure for autoexec_script_version
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_version`;
CREATE TABLE `autoexec_script_version` (
  `id` bigint NOT NULL COMMENT 'id',
  `script_id` bigint DEFAULT NULL COMMENT '脚本id',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `version` int DEFAULT NULL COMMENT '版本号',
  `encoding` enum('UTF-8','GBK') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本编码',
  `parser` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '脚本解析器',
  `status` enum('draft','rejected','passed','submitted') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'draft:编辑中、rejected:已驳回、passed:已通过、submitted:待审批',
  `reviewer` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审批人',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '脚本配置信息',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改人',
  `package_file_id` bigint DEFAULT NULL COMMENT '包文件id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_scriptid_version` (`script_id`,`version`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具版本表';

-- ----------------------------
-- Table structure for autoexec_script_version_argument
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_version_argument`;
CREATE TABLE `autoexec_script_version_argument` (
  `script_version_id` bigint NOT NULL COMMENT '脚本版本id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名',
  `default_value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '默认值',
  `argument_count` int DEFAULT NULL COMMENT '数量限制',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `is_required` tinyint(1) DEFAULT NULL COMMENT '是否必填',
  PRIMARY KEY (`script_version_id`,`name`) USING BTREE,
  UNIQUE KEY `idx_script_version_id` (`script_version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义工具库自由参数';

-- ----------------------------
-- Table structure for autoexec_script_version_lib
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_version_lib`;
CREATE TABLE `autoexec_script_version_lib` (
  `script_version_id` bigint NOT NULL COMMENT '脚本版本id',
  `lib_script_id` bigint NOT NULL COMMENT '依赖的脚本id',
  PRIMARY KEY (`script_version_id`,`lib_script_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='自动化脚本依赖表';

-- ----------------------------
-- Table structure for autoexec_script_version_param
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_script_version_param`;
CREATE TABLE `autoexec_script_version_param` (
  `script_version_id` bigint NOT NULL COMMENT '脚本版本id',
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数名',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中文名',
  `default_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '参数默认值',
  `mode` enum('output','input') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '参数类型：出参、入参',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文本、密码、文件、日期、节点信息、全局变量、json对象、文件路径',
  `mapping_mode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数映射模式',
  `is_required` tinyint(1) DEFAULT NULL COMMENT '是否必填(1:是;0:否)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '说明',
  `sort` int DEFAULT NULL COMMENT '排序',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  PRIMARY KEY (`script_version_id`,`key`,`mode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化自定义工具参数表';

-- ----------------------------
-- Table structure for autoexec_service
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_service`;
CREATE TABLE `autoexec_service` (
  `id` bigint NOT NULL,
  `name` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `type` enum('service','catalog') COLLATE utf8mb4_general_ci NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  `lft` int DEFAULT NULL,
  `rht` int DEFAULT NULL,
  `description` mediumtext COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_lft` (`lft`),
  KEY `idx_rht` (`rht`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for autoexec_service_authority
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_service_authority`;
CREATE TABLE `autoexec_service_authority` (
  `service_id` bigint NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `uuid` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`service_id`,`type`,`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for autoexec_service_config
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_service_config`;
CREATE TABLE `autoexec_service_config` (
  `service_id` bigint NOT NULL,
  `combop_id` bigint NOT NULL,
  `form_uuid` char(32) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `config_expired` tinyint DEFAULT '0' COMMENT '配置已失效',
  `config_expired_reason` mediumtext COLLATE utf8mb4_general_ci COMMENT '配置失效原因',
  `config` mediumtext COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for autoexec_service_user
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_service_user`;
CREATE TABLE `autoexec_service_user` (
  `service_id` bigint NOT NULL,
  `user_uuid` char(32) COLLATE utf8mb4_general_ci NOT NULL,
  `lcd` timestamp NOT NULL,
  PRIMARY KEY (`service_id`,`user_uuid`),
  KEY `idx_user_uuid` (`user_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for autoexec_tag
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_tag`;
CREATE TABLE `autoexec_tag` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化标签表';

-- ----------------------------
-- Table structure for autoexec_tool
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_tool`;
CREATE TABLE `autoexec_tool` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `exec_mode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '执行方式',
  `type_id` bigint DEFAULT NULL COMMENT '分类id',
  `risk_id` bigint DEFAULT NULL COMMENT '操作级别id',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述说明',
  `parser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '解析器',
  `customtemplate_id` bigint DEFAULT NULL COMMENT '自定义模版id',
  `default_profile_id` bigint DEFAULT NULL COMMENT '默认profile id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '参数配置',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改人',
  `is_lib` tinyint DEFAULT '0' COMMENT '是否库文件',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化工具表';

-- ----------------------------
-- Table structure for autoexec_type
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_type`;
CREATE TABLE `autoexec_type` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类名',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改人',
  `type` enum('factory','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'custom' COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化类型表';

-- ----------------------------
-- Table structure for autoexec_type_authority
-- ----------------------------
DROP TABLE IF EXISTS `autoexec_type_authority`;
CREATE TABLE `autoexec_type_authority` (
  `type_id` bigint NOT NULL COMMENT '工具类型id',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型',
  `auth_type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限类型\n',
  `auth_uuid` varbinary(255) NOT NULL COMMENT '权限Uuid',
  PRIMARY KEY (`type_id`,`auth_uuid`,`auth_type`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动化分类权限表';

-- ----------------------------
-- Table structure for catalog
-- ----------------------------
DROP TABLE IF EXISTS `catalog`;
CREATE TABLE `catalog` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `parent_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '父级uuid',
  `is_active` int DEFAULT '1' COMMENT '是否启用',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色',
  `desc` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `lft` int DEFAULT NULL COMMENT '左编码',
  `rht` int DEFAULT NULL COMMENT '右编码',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务目录表';

-- ----------------------------
-- Table structure for catalog_authority
-- ----------------------------
DROP TABLE IF EXISTS `catalog_authority`;
CREATE TABLE `catalog_authority` (
  `catalog_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目录uuid',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  PRIMARY KEY (`catalog_uuid`,`type`,`uuid`) USING BTREE,
  KEY `idx_uuid` (`uuid`) USING BTREE,
  KEY `idx_catalog_uuid` (`catalog_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目录授权表';

-- ----------------------------
-- Table structure for change
-- ----------------------------
DROP TABLE IF EXISTS `change`;
CREATE TABLE `change` (
  `id` bigint NOT NULL COMMENT '唯一主键id',
  `plan_start_time` varchar(23) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` varchar(23) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划结束时间',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '实际开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '实际结束时间',
  `start_time_window` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开始时间窗口',
  `end_time_window` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结束时间窗口',
  `reporter` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '变更代报人',
  `auto_start` tinyint(1) DEFAULT NULL COMMENT '是否自动开始',
  `status` enum('pending','running','aborting','succeed','failed','aborted','paused') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '变更配置md5散列值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `plan_start_time_idx` (`plan_start_time`) USING BTREE,
  KEY `plan_end_time_idx` (`plan_end_time`) USING BTREE,
  KEY `actual_start_time_idx` (`start_time`) USING BTREE,
  KEY `actual_end_time_idx` (`end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更信息表';

-- ----------------------------
-- Table structure for change_auto_start
-- ----------------------------
DROP TABLE IF EXISTS `change_auto_start`;
CREATE TABLE `change_auto_start` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `target_time` timestamp(3) NULL DEFAULT NULL COMMENT '自动开始时间点',
  PRIMARY KEY (`change_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更定时自动开始表';

-- ----------------------------
-- Table structure for change_change_template
-- ----------------------------
DROP TABLE IF EXISTS `change_change_template`;
CREATE TABLE `change_change_template` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_template_id` bigint NOT NULL COMMENT '变更模板id',
  PRIMARY KEY (`change_id`) USING BTREE,
  KEY `idx_change_template_id` (`change_template_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更引用变更模板关系表';

-- ----------------------------
-- Table structure for change_content
-- ----------------------------
DROP TABLE IF EXISTS `change_content`;
CREATE TABLE `change_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash值',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '文本内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更回复文本压缩表';

-- ----------------------------
-- Table structure for change_description
-- ----------------------------
DROP TABLE IF EXISTS `change_description`;
CREATE TABLE `change_description` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash值',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`change_id`) USING BTREE,
  KEY `change_id_idx` (`change_id`) USING BTREE,
  KEY `content_hash_idx` (`content_hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更描述表';

-- ----------------------------
-- Table structure for change_file
-- ----------------------------
DROP TABLE IF EXISTS `change_file`;
CREATE TABLE `change_file` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `file_id` bigint NOT NULL COMMENT '附件id',
  PRIMARY KEY (`change_id`,`file_id`) USING BTREE,
  KEY `idx_file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更附件表';

-- ----------------------------
-- Table structure for change_param
-- ----------------------------
DROP TABLE IF EXISTS `change_param`;
CREATE TABLE `change_param` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变量名',
  `mapping_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '映射方式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更参数表';

-- ----------------------------
-- Table structure for change_sop
-- ----------------------------
DROP TABLE IF EXISTS `change_sop`;
CREATE TABLE `change_sop` (
  `id` bigint NOT NULL COMMENT '变更sop模板id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分组uuid，用于条件过滤',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型，用于条件过滤',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP表';

-- ----------------------------
-- Table structure for change_sop_step
-- ----------------------------
DROP TABLE IF EXISTS `change_sop_step`;
CREATE TABLE `change_sop_step` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '前端生成的uuid',
  `change_sop_id` bigint DEFAULT NULL COMMENT '变更sop模板id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `plan_start_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划开始日期，yyyy-MM-dd',
  `start_time_window` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间窗口开始时间',
  `end_time_window` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间窗口结束时间',
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编码',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `chang_sop_id_idx` (`change_sop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP步骤表';

-- ----------------------------
-- Table structure for change_sop_step_content
-- ----------------------------
DROP TABLE IF EXISTS `change_sop_step_content`;
CREATE TABLE `change_sop_step_content` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一主键id',
  `change_sop_id` bigint NOT NULL COMMENT '变更sop模板id',
  `change_sop_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更sop模板步骤uuid',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash值',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `change_step_id_idx` (`change_sop_step_uuid`) USING BTREE,
  KEY `change_id_idx` (`change_sop_id`) USING BTREE,
  KEY `content_hash_idx` (`content_hash`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=531 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP表步骤描述表';

-- ----------------------------
-- Table structure for change_sop_step_file
-- ----------------------------
DROP TABLE IF EXISTS `change_sop_step_file`;
CREATE TABLE `change_sop_step_file` (
  `change_sop_id` bigint NOT NULL COMMENT '变更sop模板id',
  `change_sop_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更sop模板步骤uuid',
  `file_id` bigint NOT NULL COMMENT '附件id',
  PRIMARY KEY (`change_sop_id`,`change_sop_step_uuid`,`file_id`) USING BTREE,
  KEY `idx_file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP表步骤附件表';

-- ----------------------------
-- Table structure for change_sop_step_param
-- ----------------------------
DROP TABLE IF EXISTS `change_sop_step_param`;
CREATE TABLE `change_sop_step_param` (
  `change_sop_id` bigint NOT NULL COMMENT 'sop模板id',
  `change_sop_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'sop模板步骤uuid',
  `change_param_id` bigint NOT NULL COMMENT '变更参数id',
  PRIMARY KEY (`change_param_id`,`change_sop_step_uuid`) USING BTREE,
  KEY `change_sop_id_idx` (`change_sop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP表步骤参数表';

-- ----------------------------
-- Table structure for change_sop_step_team
-- ----------------------------
DROP TABLE IF EXISTS `change_sop_step_team`;
CREATE TABLE `change_sop_step_team` (
  `change_sop_id` bigint NOT NULL COMMENT '变更sop模板id',
  `change_sop_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更sop模板步骤uuid',
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理组uuid',
  PRIMARY KEY (`change_sop_step_uuid`) USING BTREE,
  KEY `change_id_idx` (`change_sop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP表步骤处理组表';

-- ----------------------------
-- Table structure for change_sop_step_user
-- ----------------------------
DROP TABLE IF EXISTS `change_sop_step_user`;
CREATE TABLE `change_sop_step_user` (
  `change_sop_id` bigint NOT NULL COMMENT '变更sop模板id',
  `change_sop_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更sop模板步骤uuid',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理人uuid',
  PRIMARY KEY (`change_sop_step_uuid`) USING BTREE,
  KEY `change_id_idx` (`change_sop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更SOP表步骤处理人表';

-- ----------------------------
-- Table structure for change_step
-- ----------------------------
DROP TABLE IF EXISTS `change_step`;
CREATE TABLE `change_step` (
  `id` bigint NOT NULL COMMENT '唯一主键id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '前端生成的uuid',
  `change_id` bigint DEFAULT NULL COMMENT '变更id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `plan_start_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '计划开始日期，yyyy-MM-dd',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '实际开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '实际结束时间',
  `abort_time` timestamp(3) NULL DEFAULT NULL COMMENT '终止时间',
  `start_time_window` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间窗口开始时间',
  `end_time_window` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '时间窗口结束时间',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活，未激活：0，已激活：1',
  `status` enum('unactived','pending','running','succeed','aborted') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `parent_id` bigint DEFAULT NULL COMMENT '父级id',
  `parent_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '父级uuid',
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `chang_id_idx` (`change_id`) USING BTREE,
  KEY `actual_start_time_idx` (`start_time`) USING BTREE,
  KEY `actual_end_time_idx` (`end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤信息表';

-- ----------------------------
-- Table structure for change_step_comment
-- ----------------------------
DROP TABLE IF EXISTS `change_step_comment`;
CREATE TABLE `change_step_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一标识',
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_step_id` bigint NOT NULL COMMENT '变更步骤id',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文本hash值',
  `file_id_list_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '附件列表hash值',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `processtask_step_id_idx` (`change_step_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤回复表';

-- ----------------------------
-- Table structure for change_step_content
-- ----------------------------
DROP TABLE IF EXISTS `change_step_content`;
CREATE TABLE `change_step_content` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '唯一主键id',
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_step_id` bigint NOT NULL COMMENT '变更步骤id',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash值',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型，描述、评论等',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `change_step_id_idx` (`change_step_id`) USING BTREE,
  KEY `change_id_idx` (`change_id`) USING BTREE,
  KEY `content_hash_idx` (`content_hash`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=461 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤描述表';

-- ----------------------------
-- Table structure for change_step_file
-- ----------------------------
DROP TABLE IF EXISTS `change_step_file`;
CREATE TABLE `change_step_file` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_step_id` bigint NOT NULL COMMENT '变更步骤id',
  `file_id` bigint NOT NULL COMMENT '附件id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型，变更创建、变更评论等',
  PRIMARY KEY (`change_id`,`change_step_id`,`file_id`) USING BTREE,
  KEY `idx_file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤附件表';

-- ----------------------------
-- Table structure for change_step_pause_operate
-- ----------------------------
DROP TABLE IF EXISTS `change_step_pause_operate`;
CREATE TABLE `change_step_pause_operate` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_step_id` bigint DEFAULT NULL COMMENT '变更步骤id',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`change_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤暂停操作表';

-- ----------------------------
-- Table structure for change_step_team
-- ----------------------------
DROP TABLE IF EXISTS `change_step_team`;
CREATE TABLE `change_step_team` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_step_id` bigint NOT NULL COMMENT '变更步骤id',
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理组uuid',
  PRIMARY KEY (`change_step_id`) USING BTREE,
  KEY `change_id_idx` (`change_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤处理组表';

-- ----------------------------
-- Table structure for change_step_user
-- ----------------------------
DROP TABLE IF EXISTS `change_step_user`;
CREATE TABLE `change_step_user` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `change_step_id` bigint NOT NULL COMMENT '变更步骤id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理人uuid',
  PRIMARY KEY (`change_step_id`) USING BTREE,
  KEY `change_id_idx` (`change_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更步骤处理人表';

-- ----------------------------
-- Table structure for change_template
-- ----------------------------
DROP TABLE IF EXISTS `change_template`;
CREATE TABLE `change_template` (
  `id` bigint NOT NULL COMMENT '变更模板id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分组uuid，用于条件过滤',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型，用于条件过滤',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更模板表';

-- ----------------------------
-- Table structure for change_template_sop
-- ----------------------------
DROP TABLE IF EXISTS `change_template_sop`;
CREATE TABLE `change_template_sop` (
  `change_template_id` bigint NOT NULL COMMENT '变更模板id',
  `change_sop_id` bigint NOT NULL COMMENT '变更sop模板id',
  `sort` int NOT NULL COMMENT '排序',
  PRIMARY KEY (`change_template_id`,`change_sop_id`,`sort`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更模板引用SOP关系表';

-- ----------------------------
-- Table structure for change_user
-- ----------------------------
DROP TABLE IF EXISTS `change_user`;
CREATE TABLE `change_user` (
  `change_id` bigint NOT NULL COMMENT '变更id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更经理',
  PRIMARY KEY (`change_id`) USING BTREE,
  KEY `user_uuid_idx` (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='变更经理表';

-- ----------------------------
-- Table structure for channel
-- ----------------------------
DROP TABLE IF EXISTS `channel`;
CREATE TABLE `channel` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `parent_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'catalog的uuid',
  `is_active` int NOT NULL COMMENT '是否启用',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色',
  `desc` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `sort` int NOT NULL COMMENT '排序',
  `sla` int DEFAULT NULL COMMENT 'sla',
  `allow_desc` int DEFAULT NULL COMMENT '是否显示上报页描述',
  `help` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述帮助',
  `is_active_help` int DEFAULT NULL COMMENT '是否激活描述帮助',
  `channel_type_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务类型uuid',
  `support` enum('all','pc','mobile') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'all' COMMENT '使用范围',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_channeltype_uuid` (`channel_type_uuid`) USING BTREE,
  KEY `idx_parent_uuid` (`parent_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务表';

-- ----------------------------
-- Table structure for channel_authority
-- ----------------------------
DROP TABLE IF EXISTS `channel_authority`;
CREATE TABLE `channel_authority` (
  `channel_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务uuid',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  PRIMARY KEY (`channel_uuid`,`type`,`uuid`) USING BTREE,
  KEY `idx_channel_uuid` (`channel_uuid`) USING BTREE,
  KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务授权表';

-- ----------------------------
-- Table structure for channel_priority
-- ----------------------------
DROP TABLE IF EXISTS `channel_priority`;
CREATE TABLE `channel_priority` (
  `channel_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'channel表的uuid',
  `priority_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'priority表的uuid',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1:默认优先级,0:否',
  PRIMARY KEY (`channel_uuid`,`priority_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务引用优先级关系表';

-- ----------------------------
-- Table structure for channel_process
-- ----------------------------
DROP TABLE IF EXISTS `channel_process`;
CREATE TABLE `channel_process` (
  `channel_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'channel表的uuid',
  `process_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'process表的uuid',
  PRIMARY KEY (`channel_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务引用流程关系表';

-- ----------------------------
-- Table structure for channel_relation
-- ----------------------------
DROP TABLE IF EXISTS `channel_relation`;
CREATE TABLE `channel_relation` (
  `source` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源服务uuid',
  `channel_type_relation_id` bigint NOT NULL COMMENT '关系类型id',
  `type` enum('channel','catalog') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识目标是服务还是目录',
  `target` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标服务或目录uuid',
  PRIMARY KEY (`source`,`channel_type_relation_id`,`type`,`target`) USING BTREE,
  KEY `idx_source` (`source`) USING BTREE,
  KEY `idx_channel_type_relation_id` (`channel_type_relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务转报设置表';

-- ----------------------------
-- Table structure for channel_relation_authority
-- ----------------------------
DROP TABLE IF EXISTS `channel_relation_authority`;
CREATE TABLE `channel_relation_authority` (
  `source` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务uuid',
  `channel_type_relation_id` bigint NOT NULL COMMENT '关系类型id',
  `type` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权对象类型',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权对象uuid',
  PRIMARY KEY (`source`,`channel_type_relation_id`,`type`,`uuid`) USING BTREE,
  KEY `idx_source` (`source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务转报设置授权表';

-- ----------------------------
-- Table structure for channel_relation_isusepreowner
-- ----------------------------
DROP TABLE IF EXISTS `channel_relation_isusepreowner`;
CREATE TABLE `channel_relation_isusepreowner` (
  `source` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务uuid',
  `channel_type_relation_id` bigint NOT NULL COMMENT '关系类型id',
  `is_use_pre_owner` tinyint(1) NOT NULL COMMENT '是否使用原用户上报',
  PRIMARY KEY (`source`,`channel_type_relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务转报设置是否使用原用户表';

-- ----------------------------
-- Table structure for channel_type
-- ----------------------------
DROP TABLE IF EXISTS `channel_type`;
CREATE TABLE `channel_type` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `sort` int DEFAULT NULL COMMENT '排序',
  `prefix` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工单号前缀',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务类型信息表';

-- ----------------------------
-- Table structure for channel_type_relation
-- ----------------------------
DROP TABLE IF EXISTS `channel_type_relation`;
CREATE TABLE `channel_type_relation` (
  `id` bigint NOT NULL COMMENT '唯一主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否激活',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关联关系类型表';

-- ----------------------------
-- Table structure for channel_type_relation_source
-- ----------------------------
DROP TABLE IF EXISTS `channel_type_relation_source`;
CREATE TABLE `channel_type_relation_source` (
  `channel_type_relation_id` bigint NOT NULL COMMENT '关系类型id',
  `channel_type_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务类型uuid',
  PRIMARY KEY (`channel_type_relation_id`,`channel_type_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关联关系来源服务类型表';

-- ----------------------------
-- Table structure for channel_type_relation_target
-- ----------------------------
DROP TABLE IF EXISTS `channel_type_relation_target`;
CREATE TABLE `channel_type_relation_target` (
  `channel_type_relation_id` bigint NOT NULL COMMENT '关系类型id',
  `channel_type_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务类型uuid',
  PRIMARY KEY (`channel_type_relation_id`,`channel_type_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关联关系目标服务类型表';

-- ----------------------------
-- Table structure for channel_user
-- ----------------------------
DROP TABLE IF EXISTS `channel_user`;
CREATE TABLE `channel_user` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'user的uuid',
  `channel_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'channel的uuid',
  `insert_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  UNIQUE KEY `user_channel_index` (`user_uuid`,`channel_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户收藏服务关系表';

-- ----------------------------
-- Table structure for channel_worktime
-- ----------------------------
DROP TABLE IF EXISTS `channel_worktime`;
CREATE TABLE `channel_worktime` (
  `channel_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'channel表的uuid',
  `worktime_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'worktime表的uuid',
  PRIMARY KEY (`channel_uuid`) USING BTREE,
  KEY `idx_wt_uuid` (`worktime_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务引用服务窗口关系表';

-- ----------------------------
-- Table structure for cmdb_attr
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attr`;
CREATE TABLE `cmdb_attr` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_id` bigint NOT NULL COMMENT '引用ecmdb_ci的id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '值类型',
  `prop_id` bigint DEFAULT NULL COMMENT '属性id',
  `target_ci_id` bigint DEFAULT NULL COMMENT '目标模型id',
  `expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表达式',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '英文名',
  `label` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '录入时的label名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `validator_id` bigint DEFAULT '0' COMMENT '验证器组件id，需要在代码中实现验证器',
  `is_required` tinyint NOT NULL COMMENT '是否必填',
  `is_unique` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0不唯一，1同类唯一，2全局唯一',
  `input_type` enum('at','mt') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mt' COMMENT '属性录入方式',
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性分组',
  `is_private` tinyint(1) DEFAULT NULL COMMENT '私有属性',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '属性设置',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`ci_id`,`name`) USING BTREE,
  KEY `idx_prop_id` (`prop_id`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项属性表';

-- ----------------------------
-- Table structure for cmdb_attrentity
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attrentity`;
CREATE TABLE `cmdb_attrentity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `from_cientity_id` bigint DEFAULT NULL COMMENT '所属配置项id',
  `to_cientity_id` bigint DEFAULT NULL COMMENT '引用配置项id',
  `attr_id` bigint DEFAULT NULL COMMENT '属性id',
  `from_ci_id` bigint DEFAULT NULL COMMENT '所属配置项模型id',
  `to_ci_id` bigint DEFAULT NULL COMMENT '引用配置项模型id',
  `transaction_id` bigint DEFAULT NULL COMMENT '事务id',
  `from_index` int DEFAULT NULL COMMENT '数据序号，用于检索时提高效率，只会生成前N条数据的序号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_from_cientity_id` (`from_cientity_id`,`attr_id`,`to_cientity_id`) USING BTREE,
  KEY `idx_to_cientity_id` (`to_cientity_id`) USING BTREE,
  KEY `idx_attr_id` (`attr_id`) USING BTREE,
  KEY `idx_from_ci_id` (`from_ci_id`) USING BTREE,
  KEY `idx_to_ci_id` (`to_ci_id`) USING BTREE,
  KEY `idx_transaction_id` (`transaction_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项属性实例表';

-- ----------------------------
-- Table structure for cmdb_attrentity_content
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attrentity_content`;
CREATE TABLE `cmdb_attrentity_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `value_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'value值的hash值，用于精确匹配',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`hash`) USING BTREE,
  KEY `idx_value_hash` (`value_hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项属性实例内容表';

-- ----------------------------
-- Table structure for cmdb_attrentity_content_offset
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attrentity_content_offset`;
CREATE TABLE `cmdb_attrentity_content_offset` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容hash',
  `start` int DEFAULT NULL COMMENT 'start',
  `end` int DEFAULT NULL COMMENT 'end',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_field_id` (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_attrentity_content_offset';

-- ----------------------------
-- Table structure for cmdb_attrexpression_rebuild_audit
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attrexpression_rebuild_audit`;
CREATE TABLE `cmdb_attrexpression_rebuild_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `cientity_id` bigint DEFAULT NULL COMMENT '配置项id',
  `attr_id` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '修改了哪些属性，多个属性用逗号分隔',
  `cientity_id_start` bigint DEFAULT NULL COMMENT '开始配置项id',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联方式，当cientityid不为空时才有效，invoke代表更新自己的表达式属性，invoked代表更新关联配置项的表达式属性',
  `server_id` int DEFAULT NULL COMMENT '服务器id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_attrexpression_rebuild_audit';

-- ----------------------------
-- Table structure for cmdb_attrexpression_rel
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_attrexpression_rel`;
CREATE TABLE `cmdb_attrexpression_rel` (
  `expression_ci_id` bigint NOT NULL COMMENT 'expression_ci_id',
  `expression_attr_id` bigint NOT NULL COMMENT '表达式属性id',
  `value_attr_id` bigint NOT NULL COMMENT '值属性id',
  `value_ci_id` bigint NOT NULL COMMENT 'value_ci_id',
  PRIMARY KEY (`value_ci_id`,`value_attr_id`,`expression_attr_id`,`expression_ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_attrexpression_rel';

-- ----------------------------
-- Table structure for cmdb_ci
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci`;
CREATE TABLE `cmdb_ci` (
  `id` bigint NOT NULL COMMENT 'ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '英文名',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中文名',
  `description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `type_id` bigint DEFAULT NULL COMMENT '类型ID ecmdb_ci_type',
  `parent_ci_id` bigint DEFAULT NULL COMMENT '父模型ID',
  `name_attr_id` bigint DEFAULT NULL COMMENT '名称属性',
  `lft` int DEFAULT NULL COMMENT '左编码',
  `rht` int DEFAULT NULL COMMENT '右编码',
  `is_private` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否私有模型，私有模型不允许修改和删除',
  `is_menu` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在菜单中显示',
  `is_abstract` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否抽象模型',
  `is_virtual` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否虚拟模型，虚拟模型实际上是视图不是物理表',
  `file_id` bigint DEFAULT NULL COMMENT '虚拟模型配置文件id',
  `xml` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '虚拟模型配置内容',
  `expired_day` int DEFAULT '0' COMMENT '有效天数，0代表不超期',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_enname` (`name`) USING BTREE,
  KEY `idx_lft` (`lft`) USING BTREE,
  KEY `idx_rht` (`rht`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项表';

-- ----------------------------
-- Table structure for cmdb_ci_auth
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_auth`;
CREATE TABLE `cmdb_ci_auth` (
  `ci_id` bigint NOT NULL COMMENT '引用ecmdb_ci的id',
  `auth_type` enum('user','role','team','common') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `action` enum('cientityinsert','cientityupdate','cientitydelete','cientityrecover','cientityquery','cimanage','transactionmanage','passwordview') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '对应的操作动作',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'auth uuid',
  PRIMARY KEY (`ci_id`,`auth_type`,`action`,`auth_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项授权表';

-- ----------------------------
-- Table structure for cmdb_ci_customview
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_customview`;
CREATE TABLE `cmdb_ci_customview` (
  `ci_id` bigint NOT NULL COMMENT '模型id',
  `customview_id` bigint NOT NULL COMMENT '自定义视图id',
  PRIMARY KEY (`ci_id`,`customview_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='配置模型自定义视图关联表';

-- ----------------------------
-- Table structure for cmdb_ci_group
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_group`;
CREATE TABLE `cmdb_ci_group` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `group_id` bigint DEFAULT NULL COMMENT '团体id',
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '规则',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_ci_id` (`ci_id`,`group_id`) USING BTREE,
  KEY `idx_group_id` (`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='模型团体关系表';

-- ----------------------------
-- Table structure for cmdb_ci_unique
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_ci_unique`;
CREATE TABLE `cmdb_ci_unique` (
  `ci_id` bigint NOT NULL COMMENT 'ci id',
  `attr_id` bigint NOT NULL COMMENT '属性id',
  PRIMARY KEY (`ci_id`,`attr_id`) USING BTREE,
  KEY `idx_attr_id` (`attr_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_ci_unique';

-- ----------------------------
-- Table structure for cmdb_cientity
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity`;
CREATE TABLE `cmdb_cientity` (
  `id` bigint NOT NULL COMMENT 'ID',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'uuid',
  `ci_id` bigint NOT NULL COMMENT '引用ecmdb_ci的id',
  `name` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置项名称',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `is_locked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '如果有未提交事务，处于锁定状态',
  `fcu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改用户',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `inspect_status` enum('normal','warn','critical','','fatal') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '巡检状态',
  `inspect_time` timestamp(3) NULL DEFAULT NULL COMMENT '巡检时间',
  `monitor_status` enum('normal','warn','critical','','fatal') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '监控状态',
  `monitor_time` timestamp(3) NULL DEFAULT NULL COMMENT '监控时间',
  `renew_time` timestamp(3) NULL DEFAULT NULL COMMENT '刷新时间，用来判断是否老化',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ci_id` (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项实例表';

-- ----------------------------
-- Table structure for cmdb_cientity_alert
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_alert`;
CREATE TABLE `cmdb_cientity_alert` (
  `id` bigint NOT NULL,
  `cientity_id` bigint DEFAULT NULL,
  `cientity_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `alert_time` timestamp(3) NULL DEFAULT NULL,
  `metric_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `metric_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alert_message` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alert_link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_cientity_id` (`cientity_id`) USING BTREE,
  KEY `idx_cientity_uuid` (`cientity_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_cientity_alertlevel
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_alertlevel`;
CREATE TABLE `cmdb_cientity_alertlevel` (
  `level` int NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_cientity_expiredtime
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_expiredtime`;
CREATE TABLE `cmdb_cientity_expiredtime` (
  `cientity_id` bigint NOT NULL COMMENT '配置项id',
  `expired_day` int DEFAULT NULL COMMENT '原来的超时天数，用于比对修正expired_time',
  `expired_time` timestamp(3) NULL DEFAULT NULL COMMENT '过期日期',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  PRIMARY KEY (`cientity_id`) USING BTREE,
  KEY `idx_expired_time` (`expired_time`) USING BTREE,
  KEY `idx_ci_id` (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_cientity_group
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_group`;
CREATE TABLE `cmdb_cientity_group` (
  `cientity_id` bigint NOT NULL COMMENT '配置项ID',
  `group_id` bigint NOT NULL COMMENT '圈子id',
  `ci_group_id` bigint DEFAULT NULL COMMENT '命中的规则id',
  PRIMARY KEY (`group_id`,`cientity_id`) USING BTREE,
  KEY `idx_ci_group_id` (`ci_group_id`) USING BTREE,
  KEY `idx_cientity_id` (`cientity_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='配置项团体关系表';

-- ----------------------------
-- Table structure for cmdb_cientity_illegal
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_illegal`;
CREATE TABLE `cmdb_cientity_illegal` (
  `ci_id` bigint NOT NULL COMMENT '模型id',
  `cientity_id` bigint NOT NULL COMMENT '配置项id',
  `legalvalid_id` bigint NOT NULL COMMENT '规则id',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `valid_time` timestamp(3) NULL DEFAULT NULL COMMENT '校验时间',
  PRIMARY KEY (`cientity_id`,`legalvalid_id`) USING BTREE,
  KEY `idx_legalvalid_id` (`legalvalid_id`) USING BTREE,
  KEY `idx_ci_id` (`ci_id`) USING BTREE,
  KEY `idx_time` (`valid_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='非法配置项';

-- ----------------------------
-- Table structure for cmdb_cientity_inspect
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_inspect`;
CREATE TABLE `cmdb_cientity_inspect` (
  `id` bigint NOT NULL COMMENT '主键',
  `job_id` bigint NOT NULL COMMENT '作业id',
  `ci_entity_id` bigint NOT NULL COMMENT '配置项id',
  `inspect_status` enum('normal','warn','critical','','fatal') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '巡检状态',
  `inspect_time` timestamp(3) NULL DEFAULT NULL COMMENT '巡检时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_job_id_cientity_id` (`job_id`,`ci_entity_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='配置项的巡检状态表';

-- ----------------------------
-- Table structure for cmdb_cientity_snapshot
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_snapshot`;
CREATE TABLE `cmdb_cientity_snapshot` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项实例快照表';

-- ----------------------------
-- Table structure for cmdb_cientity_transaction
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_cientity_transaction`;
CREATE TABLE `cmdb_cientity_transaction` (
  `id` bigint unsigned NOT NULL COMMENT 'ID',
  `ci_entity_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置项实例uuid',
  `ci_id` bigint NOT NULL COMMENT '引用ecmdb_ci的id',
  `ci_entity_id` bigint NOT NULL DEFAULT '0' COMMENT '引用ecmdb_ci_entity的id',
  `name` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `action` enum('insert','update','delete','recover') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型，I:insert,U:update;D:delete;S:recover;',
  `edit_mode` enum('global','partial') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编辑模式',
  `transaction_id` bigint NOT NULL COMMENT '事务id',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '修改内容，json格式',
  `snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '修改前快照hash',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_NewIndex1` (`transaction_id`) USING BTREE,
  KEY `idx_NewIndex2` (`ci_entity_id`) USING BTREE,
  KEY `idx_NewIndex3` (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项实例事务表';

-- ----------------------------
-- Table structure for cmdb_citype
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_citype`;
CREATE TABLE `cmdb_citype` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型名称',
  `sort` int NOT NULL COMMENT '排序',
  `is_menu` tinyint(1) NOT NULL COMMENT '是否在菜单中显示',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `is_showintopo` tinyint(1) DEFAULT NULL COMMENT '是否在topo图中展示',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项类型表';

-- ----------------------------
-- Table structure for cmdb_customview
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview`;
CREATE TABLE `cmdb_customview` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `is_private` tinyint(1) DEFAULT NULL COMMENT '是否私有视图',
  `type` enum('private','public','scene') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '说明',
  `icon` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所有人uuid',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb自定义视图表';

-- ----------------------------
-- Table structure for cmdb_customview_attr
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_attr`;
CREATE TABLE `cmdb_customview_attr` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `customview_ci_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型在视图中的唯一id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `attr_id` bigint DEFAULT NULL COMMENT '属性id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '别名',
  `sort` int DEFAULT NULL COMMENT '顺序',
  `is_hidden` tinyint DEFAULT '0' COMMENT '是否隐藏',
  `is_primary` tinyint DEFAULT '0' COMMENT '是否主键',
  `condition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '条件，json结构',
  PRIMARY KEY (`customview_id`,`uuid`) USING BTREE,
  KEY `idx_attr_id` (`attr_id`) USING BTREE,
  KEY `idx_customviewci_id` (`customview_ci_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb自定义视图属性表';

-- ----------------------------
-- Table structure for cmdb_customview_auth
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_auth`;
CREATE TABLE `cmdb_customview_auth` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `auth_type` enum('user','team','role','common') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '''user'',''team'',''role''',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'auth uuid',
  PRIMARY KEY (`customview_id`,`auth_type`,`auth_uuid`) USING BTREE,
  KEY `idx_customview_id` (`customview_id`) USING BTREE,
  KEY `idx_auth_uuid` (`auth_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义视图授权表';

-- ----------------------------
-- Table structure for cmdb_customview_ci
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_ci`;
CREATE TABLE `cmdb_customview_ci` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '在视图中的uuid',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `sort` int DEFAULT NULL COMMENT '排序',
  `is_hidden` tinyint(1) DEFAULT NULL COMMENT '是否在topo中展示',
  `alias` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '别名',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `is_start` tinyint(1) DEFAULT NULL COMMENT '是否起始模型',
  PRIMARY KEY (`customview_id`,`uuid`) USING BTREE,
  KEY `idx_ci_id` (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_customview_ci';

-- ----------------------------
-- Table structure for cmdb_customview_constattr
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_constattr`;
CREATE TABLE `cmdb_customview_constattr` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `customview_ci_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模型在视图中的唯一id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `const_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性名称',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '别名',
  `sort` int DEFAULT NULL COMMENT '顺序',
  `is_hidden` tinyint DEFAULT '0' COMMENT '是否隐藏',
  `is_primary` tinyint DEFAULT '0' COMMENT '是否主键',
  PRIMARY KEY (`customview_id`,`uuid`) USING BTREE,
  KEY `idx_attr_id` (`const_name`) USING BTREE,
  KEY `idx_customviewci_id` (`customview_ci_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='视图属性配置';

-- ----------------------------
-- Table structure for cmdb_customview_link
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_link`;
CREATE TABLE `cmdb_customview_link` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '别名',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `from_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '源视图uuid',
  `to_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标视图uuid',
  `from_type` enum('attr','rel','ci','constattr') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源类型',
  `to_type` enum('attr','rel','ci','constattr') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标类型',
  `join_type` enum('join','leftjoin','rightjoin','outerjoin') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '连接方式',
  `from_ci_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '源配置项uuid',
  `to_ci_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标配置项uuid',
  PRIMARY KEY (`customview_id`,`uuid`) USING BTREE,
  KEY `idx_view_id` (`from_uuid`) USING BTREE,
  KEY `idx_to_attr_id` (`from_type`) USING BTREE,
  KEY `idx_fromcustomviewci_id` (`to_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb自定义视图关联表';

-- ----------------------------
-- Table structure for cmdb_customview_rel
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_rel`;
CREATE TABLE `cmdb_customview_rel` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `customview_ci_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'customview_ci_uuid',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `rel_id` bigint DEFAULT NULL COMMENT 'rel_id',
  PRIMARY KEY (`customview_id`,`uuid`) USING BTREE,
  KEY `idx_customci_uuid` (`customview_ci_uuid`) USING BTREE,
  KEY `idx_rel_id` (`rel_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_customview_rel';

-- ----------------------------
-- Table structure for cmdb_customview_tag
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_tag`;
CREATE TABLE `cmdb_customview_tag` (
  `customview_id` bigint NOT NULL COMMENT '视图id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`customview_id`,`tag_id`) USING BTREE,
  KEY `idx_tag_id` (`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb自定义视图标签表';

-- ----------------------------
-- Table structure for cmdb_customview_template
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_customview_template`;
CREATE TABLE `cmdb_customview_template` (
  `customview_id` bigint NOT NULL COMMENT '自定义模板id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `template` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容模板',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  PRIMARY KEY (`customview_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb自定义视图模板\r\n';

-- ----------------------------
-- Table structure for cmdb_graph
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_graph`;
CREATE TABLE `cmdb_graph` (
  `id` bigint NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint DEFAULT NULL,
  `icon` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `type` enum('private','public','scene') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fcd` timestamp(3) NULL DEFAULT NULL,
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lcd` timestamp(3) NULL DEFAULT NULL,
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_graph_auth
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_graph_auth`;
CREATE TABLE `cmdb_graph_auth` (
  `graph_id` bigint NOT NULL,
  `auth_type` enum('user','team','role','common') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`graph_id`,`auth_type`,`auth_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_graph_cientity
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_graph_cientity`;
CREATE TABLE `cmdb_graph_cientity` (
  `graph_id` bigint NOT NULL,
  `cientity_id` bigint NOT NULL,
  PRIMARY KEY (`graph_id`,`cientity_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_graph_rel
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_graph_rel`;
CREATE TABLE `cmdb_graph_rel` (
  `from_graph_id` bigint NOT NULL,
  `to_graph_id` bigint NOT NULL,
  PRIMARY KEY (`from_graph_id`,`to_graph_id`) USING BTREE,
  KEY `idx_to_graph_id` (`to_graph_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for cmdb_group
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_group`;
CREATE TABLE `cmdb_group` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名字',
  `type` enum('readonly','maintain') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `is_active` tinyint DEFAULT NULL COMMENT '是否激活',
  `cientity_count` int DEFAULT NULL COMMENT '配置项数量',
  `status` enum('doing','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `fcd` timestamp(3) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '创建日期',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改日期',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `server_id` int DEFAULT NULL COMMENT '服务器id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_server_id` (`server_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='团体';

-- ----------------------------
-- Table structure for cmdb_group_auth
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_group_auth`;
CREATE TABLE `cmdb_group_auth` (
  `group_id` bigint NOT NULL COMMENT '引用cmdb_group表id',
  `auth_type` enum('user','role','team','common') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'user,role,team',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'auth uuid',
  PRIMARY KEY (`group_id`,`auth_uuid`,`auth_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_group_auth';

-- ----------------------------
-- Table structure for cmdb_import_audit
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_import_audit`;
CREATE TABLE `cmdb_import_audit` (
  `id` bigint NOT NULL COMMENT 'ID',
  `import_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '导入用户',
  `import_date` timestamp(3) NULL DEFAULT NULL COMMENT '导入时间',
  `finish_date` timestamp(3) NULL DEFAULT NULL COMMENT '完成时间',
  `action` enum('append','update','all') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'append：增量导入；update：存量导入；all：全部导入',
  `file_id` bigint DEFAULT NULL COMMENT '导入附件的id',
  `ci_id` bigint DEFAULT NULL COMMENT '引用cmdb_ci的id',
  `success_count` int DEFAULT NULL COMMENT '导入数量',
  `failed_count` int DEFAULT NULL COMMENT '失败数量',
  `status` enum('running','success','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '错误信息',
  `total_count` int DEFAULT NULL COMMENT '总数',
  `server_id` int DEFAULT NULL COMMENT '应用ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_import_date` (`import_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb批量导入审计表';

-- ----------------------------
-- Table structure for cmdb_import_file
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_import_file`;
CREATE TABLE `cmdb_import_file` (
  `file_id` bigint NOT NULL COMMENT '文件ID',
  PRIMARY KEY (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_import_file';

-- ----------------------------
-- Table structure for cmdb_legalvalid
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_legalvalid`;
CREATE TABLE `cmdb_legalvalid` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` enum('ci','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '校验类型',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '规则',
  `cron` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '定时表达式',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ci_id` (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='合规设置表';

-- ----------------------------
-- Table structure for cmdb_rel
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_rel`;
CREATE TABLE `cmdb_rel` (
  `id` bigint NOT NULL COMMENT 'ID',
  `type_id` bigint DEFAULT NULL COMMENT '类型id',
  `input_type` enum('at','mt') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'mt' COMMENT '录入方式',
  `from_ci_id` bigint NOT NULL COMMENT '来源模型id',
  `from_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源端名称',
  `from_label` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源端标签',
  `from_rule` enum('1:N','0:N','1:1','0:1','O','N') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源端规则',
  `from_group_id` bigint DEFAULT NULL COMMENT '来源端分组,引用cmdb_relgroup的id',
  `from_is_unique` tinyint DEFAULT NULL COMMENT '来源引用是否唯一',
  `from_is_cascade_delete` tinyint DEFAULT '0' COMMENT '来源端是否级联删除',
  `from_is_required` tinyint DEFAULT NULL COMMENT '来源端是否必填',
  `to_ci_id` bigint NOT NULL COMMENT '目标端模型id',
  `to_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标端名称',
  `to_label` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标端标签',
  `to_rule` enum('1:N','0:N','0:1','1:1','O','N') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标端规则',
  `to_group_id` bigint DEFAULT NULL COMMENT '目标端分组,引用cmdb_relgroup的id',
  `to_is_unique` tinyint DEFAULT NULL COMMENT '目标引用是否唯一',
  `to_is_cascade_delete` tinyint DEFAULT '0' COMMENT '目标端是否级联删除',
  `to_is_required` tinyint DEFAULT NULL COMMENT '目标端是否必填',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_from_to_name` (`from_name`,`to_name`) USING BTREE,
  UNIQUE KEY `uk_fromlabel_tolabel` (`from_label`,`to_label`) USING BTREE,
  KEY `idx_from_ciid` (`from_ci_id`) USING BTREE,
  KEY `idx_to_ciid` (`to_ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='CI关联类型表';

-- ----------------------------
-- Table structure for cmdb_relativerel
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_relativerel`;
CREATE TABLE `cmdb_relativerel` (
  `rel_id` bigint NOT NULL COMMENT '关系id',
  `from_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '上游端路径',
  `to_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '下游端路径',
  `path_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全路径hash',
  `relative_rel_id` bigint NOT NULL COMMENT '级联关系id',
  PRIMARY KEY (`rel_id`,`relative_rel_id`,`path_hash`) USING BTREE,
  UNIQUE KEY `uk_path` (`path_hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb引用关系';

-- ----------------------------
-- Table structure for cmdb_relentity
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_relentity`;
CREATE TABLE `cmdb_relentity` (
  `id` bigint NOT NULL COMMENT 'ID',
  `rel_id` bigint NOT NULL COMMENT '关联属性ID',
  `from_cientity_id` bigint NOT NULL COMMENT '来源配置项ID',
  `to_cientity_id` bigint NOT NULL COMMENT '目标配置项ID',
  `transaction_id` bigint DEFAULT NULL COMMENT '生效事务id',
  `from_index` int DEFAULT NULL COMMENT '数据序号，用于检索时提高效率，只会生成前N条数据的序号',
  `to_index` int DEFAULT NULL COMMENT '数据序号，用于检索时提高效率，只会生成前N条数据的序号',
  `insert_time` timestamp(3) NULL DEFAULT NULL COMMENT '插入时间',
  `renew_time` timestamp(3) NULL DEFAULT NULL COMMENT '更新时间，用于判断老化',
  `valid_day` int DEFAULT NULL COMMENT '有效天数，为空代表长期有效',
  `expired_time` timestamp(3) NULL DEFAULT NULL COMMENT '过期日期',
  `relativerel_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联关系hash',
  `source_relentity_id` bigint DEFAULT NULL COMMENT '源头关系id，不为空代表是级联关系，源头关系删除后这条关系也要删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_from_to` (`rel_id`,`from_cientity_id`,`to_cientity_id`) USING BTREE,
  KEY `idx_from_cientity_id` (`from_cientity_id`) USING BTREE,
  KEY `idx_to_cientity_id` (`to_cientity_id`) USING BTREE,
  KEY `idx_from_index` (`rel_id`,`from_cientity_id`,`from_index`) USING BTREE,
  KEY `idx_to_index` (`rel_id`,`to_cientity_id`,`to_index`) USING BTREE,
  KEY `idx_expiredtime` (`expired_time`) USING BTREE,
  KEY `idx_source_relentity_id` (`source_relentity_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb配置项实例关联表';

-- ----------------------------
-- Table structure for cmdb_relgroup
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_relgroup`;
CREATE TABLE `cmdb_relgroup` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_id` bigint NOT NULL COMMENT '配置项id',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_group_name` (`ci_id`,`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_relgroup';

-- ----------------------------
-- Table structure for cmdb_reltype
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_reltype`;
CREATE TABLE `cmdb_reltype` (
  `id` bigint NOT NULL COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_showintopo` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在拓扑图中显示',
  `from_cnname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '调用方名称',
  `to_cnname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标方名称',
  `from_enname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '调用方英文名',
  `to_enname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标方英文名',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_reltype';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_account
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_account`;
CREATE TABLE `cmdb_resourcecenter_account` (
  `id` bigint NOT NULL COMMENT '主键id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '账号',
  `password` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '密码',
  `protocol_id` bigint NOT NULL COMMENT '协议id',
  `type` enum('public','private') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否该协议默认账号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY ` idx_protocolid` (`protocol_id`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb资源中心账号表';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_account_ip
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_account_ip`;
CREATE TABLE `cmdb_resourcecenter_account_ip` (
  `account_id` bigint NOT NULL COMMENT '账号id',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号对应的ip',
  PRIMARY KEY (`account_id`,`ip`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用于ip账号匹配';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_account_protocol
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_account_protocol`;
CREATE TABLE `cmdb_resourcecenter_account_protocol` (
  `id` bigint NOT NULL COMMENT '协议id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '协议名称',
  `port` int DEFAULT NULL COMMENT '协议端口',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后一次修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb资源中心账号协议表';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_account_tag
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_account_tag`;
CREATE TABLE `cmdb_resourcecenter_account_tag` (
  `account_id` bigint NOT NULL COMMENT '账号id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`account_id`,`tag_id`) USING BTREE,
  KEY `idx_tag_id` (`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_resourcecenter_account_tag';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_config
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_config`;
CREATE TABLE `cmdb_resourcecenter_config` (
  `id` int NOT NULL DEFAULT '1' COMMENT 'id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建用户',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改用户',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='资源中心配置表';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_entity
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_entity`;
CREATE TABLE `cmdb_resourcecenter_entity` (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标识',
  `type` enum('resource','scene') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `status` enum('ready','pending','error','') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'error',
  `xml` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `init_time` timestamp(3) NULL DEFAULT NULL COMMENT 'init time',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_resourcecenter_entity';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_resource_account
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_resource_account`;
CREATE TABLE `cmdb_resourcecenter_resource_account` (
  `resource_id` bigint NOT NULL COMMENT '资源id',
  `account_id` bigint NOT NULL COMMENT '账号id',
  PRIMARY KEY (`resource_id`,`account_id`) USING BTREE,
  KEY `idx_account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='资源中心资源与账号关联表';

-- ----------------------------
-- Table structure for cmdb_resourcecenter_resource_tag
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_resourcecenter_resource_tag`;
CREATE TABLE `cmdb_resourcecenter_resource_tag` (
  `resource_id` bigint NOT NULL COMMENT '资源id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`resource_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_resourcecenter_resource_tag';

-- ----------------------------
-- Table structure for cmdb_schema_audit
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_schema_audit`;
CREATE TABLE `cmdb_schema_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_type` enum('ci','attr','rel','cientity') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `action` enum('insert','delete','update') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '动作',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `server_id` int NOT NULL COMMENT 'server id',
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'data',
  `is_failed` tinyint(1) DEFAULT '0' COMMENT '是否失败',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk` (`target_id`,`target_type`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE,
  KEY `idx_server_id` (`server_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_schema_audit';

-- ----------------------------
-- Table structure for cmdb_sync_audit
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_sync_audit`;
CREATE TABLE `cmdb_sync_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_collection_id` bigint DEFAULT NULL COMMENT '同步配置id',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `data_count` int DEFAULT NULL COMMENT '需处理的数据量',
  `input_from` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '触发方式',
  `status` enum('doing','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `transaction_group_id` bigint DEFAULT NULL COMMENT '事务组id',
  `server_id` int DEFAULT NULL COMMENT '服务器id',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ci_collection_id` (`ci_collection_id`) USING BTREE,
  KEY `idx_start_time` (`start_time`) USING BTREE,
  KEY `idx_end_time` (`end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb同步记录表';

-- ----------------------------
-- Table structure for cmdb_sync_ci_collection
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_sync_ci_collection`;
CREATE TABLE `cmdb_sync_ci_collection` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_id` bigint NOT NULL COMMENT '配置项id',
  `collection_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'collection name',
  `parent_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '父属性，可以为空',
  `collect_mode` enum('initiative','passive') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'collect mode',
  `is_auto_commit` tinyint DEFAULT NULL COMMENT '是否自动提交',
  `match_mode` enum('key','level') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'key' COMMENT '匹配模式',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `last_sync_date` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次成功同步时间',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '说明',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk` (`ci_id`,`collection_name`,`parent_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_sync_ci_collection';

-- ----------------------------
-- Table structure for cmdb_sync_mapping
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_sync_mapping`;
CREATE TABLE `cmdb_sync_mapping` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_collection_id` bigint DEFAULT NULL COMMENT '模型集合id',
  `rel_id` bigint DEFAULT NULL COMMENT '关系id',
  `direction` enum('from','to') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关系方向',
  `attr_id` bigint DEFAULT NULL COMMENT '属性id',
  `field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集合字段，支持jsonpath',
  `action` enum('insert','replace','delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'insert' COMMENT '动作',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_sync_mapping';

-- ----------------------------
-- Table structure for cmdb_sync_policy
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_sync_policy`;
CREATE TABLE `cmdb_sync_policy` (
  `id` bigint NOT NULL COMMENT '主键',
  `ci_collection_id` bigint DEFAULT NULL COMMENT '模型id',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `condition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'mongodb过滤条件',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_ci_id` (`ci_collection_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb同步策略';

-- ----------------------------
-- Table structure for cmdb_sync_schedule
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_sync_schedule`;
CREATE TABLE `cmdb_sync_schedule` (
  `id` bigint NOT NULL COMMENT 'id',
  `cron` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `policy_id` bigint NOT NULL COMMENT '策略id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_policy_id` (`policy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb同步计划表';

-- ----------------------------
-- Table structure for cmdb_sync_unique
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_sync_unique`;
CREATE TABLE `cmdb_sync_unique` (
  `ci_collection_id` bigint NOT NULL COMMENT '配置集合id',
  `attr_id` bigint NOT NULL COMMENT '配置属性id',
  PRIMARY KEY (`ci_collection_id`,`attr_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='配置同步唯一属性';

-- ----------------------------
-- Table structure for cmdb_tag
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_tag`;
CREATE TABLE `cmdb_tag` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb标签表';

-- ----------------------------
-- Table structure for cmdb_transaction
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_transaction`;
CREATE TABLE `cmdb_transaction` (
  `id` bigint unsigned NOT NULL COMMENT '事务ID',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `status` enum('commited','uncommit','recover') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否提交',
  `create_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建用户ID',
  `commit_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '提交用户ID',
  `recover_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '恢复用户',
  `input_from` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据来源类型',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源',
  `expire_time` timestamp(3) NULL DEFAULT NULL COMMENT '快照超时时间，这时候以后没提交，自动删除',
  `create_time` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `commit_time` timestamp(3) NULL DEFAULT NULL COMMENT '提交时间',
  `recover_time` timestamp(3) NULL DEFAULT NULL COMMENT '恢复时间',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '最后一次错误原因',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改备注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_commit_time` (`commit_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb事务表';

-- ----------------------------
-- Table structure for cmdb_transactiongroup
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_transactiongroup`;
CREATE TABLE `cmdb_transactiongroup` (
  `id` bigint NOT NULL COMMENT 'id',
  `transaction_id` bigint NOT NULL COMMENT '事务id',
  PRIMARY KEY (`id`,`transaction_id`) USING BTREE,
  KEY `idx_transaction_id` (`transaction_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb事务组表';

-- ----------------------------
-- Table structure for cmdb_validator
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_validator`;
CREATE TABLE `cmdb_validator` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器类路径',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `error_template` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误模版',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb校验器表';

-- ----------------------------
-- Table structure for cmdb_view
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_view`;
CREATE TABLE `cmdb_view` (
  `ci_id` bigint NOT NULL COMMENT '模型id',
  `item_id` bigint NOT NULL COMMENT '关系或属性id',
  `type` enum('attr','relfrom','relto','const') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `sort` int NOT NULL COMMENT '排序',
  `show_type` enum('none','all','list','detail') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '显示方式',
  `allow_edit` tinyint(1) DEFAULT NULL COMMENT '允许修改',
  PRIMARY KEY (`ci_id`,`item_id`,`type`) USING BTREE,
  KEY `idx_item_id` (`item_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb视图表';

-- ----------------------------
-- Table structure for cmdb_viewconst
-- ----------------------------
DROP TABLE IF EXISTS `cmdb_viewconst`;
CREATE TABLE `cmdb_viewconst` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb_viewconst';

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置名',
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置值',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置描述',
  PRIMARY KEY (`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统配置表';

-- ----------------------------
-- Table structure for dashboard
-- ----------------------------
DROP TABLE IF EXISTS `dashboard`;
CREATE TABLE `dashboard` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `description` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `type` enum('custom','system') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'custom' COMMENT '类型',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改人',
  `widget_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '组件配置',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_fcu` (`fcu`) USING BTREE,
  KEY `idx_fcd` (`fcd`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='仪表板表';

-- ----------------------------
-- Table structure for dashboard_authority
-- ----------------------------
DROP TABLE IF EXISTS `dashboard_authority`;
CREATE TABLE `dashboard_authority` (
  `dashboard_id` bigint NOT NULL COMMENT '面板id',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '查看权限类型',
  `uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '查看权限uuid',
  PRIMARY KEY (`dashboard_id`,`type`,`uuid`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_uuid` (`uuid`) USING BTREE,
  KEY `idx_dashboard_uuid` (`dashboard_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='仪表板权限表';

-- ----------------------------
-- Table structure for dashboard_default
-- ----------------------------
DROP TABLE IF EXISTS `dashboard_default`;
CREATE TABLE `dashboard_default` (
  `dashboard_id` bigint NOT NULL COMMENT '仪表板唯一标识',
  `user_uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仪表板用户',
  `type` enum('custom','system') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'custom' COMMENT '仪表板类型',
  PRIMARY KEY (`dashboard_id`,`user_uuid`,`type`) USING BTREE,
  KEY `idx_uuid_userid_type` (`dashboard_id`,`user_uuid`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='仪表板默认表';

-- ----------------------------
-- Table structure for dashboard_userdefault
-- ----------------------------
DROP TABLE IF EXISTS `dashboard_userdefault`;
CREATE TABLE `dashboard_userdefault` (
  `dashboard_id` bigint NOT NULL COMMENT '仪表板唯一标识',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  PRIMARY KEY (`dashboard_id`,`user_uuid`) USING BTREE,
  UNIQUE KEY `uk_user_uuid` (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户默认仪表板表';

-- ----------------------------
-- Table structure for dashboard_visitcounter
-- ----------------------------
DROP TABLE IF EXISTS `dashboard_visitcounter`;
CREATE TABLE `dashboard_visitcounter` (
  `dashboard_id` bigint NOT NULL COMMENT '仪表板id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `visit_count` int DEFAULT NULL COMMENT '访问次数',
  PRIMARY KEY (`dashboard_id`,`user_uuid`) USING BTREE,
  KEY `idx_user_uuid` (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='仪表板访问统计表';

-- ----------------------------
-- Table structure for dashboard_widget
-- ----------------------------
DROP TABLE IF EXISTS `dashboard_widget`;
CREATE TABLE `dashboard_widget` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'porlet名称',
  `refresh_interval` int NOT NULL DEFAULT '1' COMMENT '自动刷新间隔，单位秒，0代表不刷新',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `dashboard_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '面板Id',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件',
  `chart_type` enum('barchart','piechart','stackbarchart','areachart','linechart','columnchart','stackcolumnchart','tablechart','numberchart','donutchart') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '视图模板',
  `condition_config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '条件配置',
  `chart_config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '图表配置',
  `detail_widget_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '明细组件uuid',
  `x` int DEFAULT NULL COMMENT 'x',
  `y` int DEFAULT NULL COMMENT 'y',
  `h` int DEFAULT NULL COMMENT 'h',
  `w` int DEFAULT NULL COMMENT 'w',
  `i` int DEFAULT NULL COMMENT 'i',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='dashboard_widget';

-- ----------------------------
-- Table structure for datawarehouse_datasource
-- ----------------------------
DROP TABLE IF EXISTS `datawarehouse_datasource`;
CREATE TABLE `datawarehouse_datasource` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '中文名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '说明',
  `xml` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'sql语句',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '定时策略',
  `mode` enum('replace','append') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新模式，追加或替换',
  `expire_count` int DEFAULT NULL COMMENT '过期数值',
  `module_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '所属模块',
  `status` enum('doing','done','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '同步状态',
  `data_count` int DEFAULT NULL COMMENT '数据量',
  `expire_unit` enum('minute','hour','day','month','year') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '过期单位',
  `db_type` enum('mysql','mongodb') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'mysql' COMMENT '数据库类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据仓库-数据源';

-- ----------------------------
-- Table structure for datawarehouse_datasource_audit
-- ----------------------------
DROP TABLE IF EXISTS `datawarehouse_datasource_audit`;
CREATE TABLE `datawarehouse_datasource_audit` (
  `id` bigint NOT NULL COMMENT '自增id',
  `datasource_id` bigint DEFAULT NULL COMMENT '数据源id',
  `start_time` datetime(3) DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime(3) DEFAULT NULL COMMENT '结束时间',
  `data_count` int DEFAULT NULL COMMENT '数据量',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_datasource_id` (`datasource_id`) USING BTREE,
  KEY `idx_end_time` (`end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据仓库-数据源审计';

-- ----------------------------
-- Table structure for datawarehouse_datasource_condition
-- ----------------------------
DROP TABLE IF EXISTS `datawarehouse_datasource_condition`;
CREATE TABLE `datawarehouse_datasource_condition` (
  `id` bigint NOT NULL COMMENT '主键',
  `datasource_id` bigint DEFAULT NULL COMMENT '数据源Id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` enum('text','datetime','time','date','number') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据类型',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '条件值',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置，例如下拉框需要配置',
  `is_required` tinyint DEFAULT NULL COMMENT '是否必填',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据仓库-数据源-条件';

-- ----------------------------
-- Table structure for datawarehouse_datasource_field
-- ----------------------------
DROP TABLE IF EXISTS `datawarehouse_datasource_field`;
CREATE TABLE `datawarehouse_datasource_field` (
  `id` bigint NOT NULL COMMENT '主键',
  `datasource_id` bigint DEFAULT NULL COMMENT '数据源id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` enum('text','number','datetime','date','time') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `input_type` enum('text','userselect','enumselect','timeselect') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作为条件时的输入方式',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '作为条件时的配置，例如下拉框',
  `is_key` tinyint(1) DEFAULT NULL COMMENT '是否主键',
  `is_condition` tinyint(1) DEFAULT NULL COMMENT '是否作为条件',
  `aggregate` enum('count','sum') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '聚合函数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据仓库-数据源-字段';

-- ----------------------------
-- Table structure for datawarehouse_datasource_param
-- ----------------------------
DROP TABLE IF EXISTS `datawarehouse_datasource_param`;
CREATE TABLE `datawarehouse_datasource_param` (
  `id` bigint NOT NULL COMMENT '自增id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `default_value` bigint DEFAULT NULL COMMENT '默认值',
  `datasource_id` bigint DEFAULT NULL COMMENT '数据源id',
  `current_value` bigint DEFAULT NULL COMMENT '当前值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_datasource_id` (`datasource_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='数据仓库-数据源-参数';

-- ----------------------------
-- Table structure for dependency
-- ----------------------------
DROP TABLE IF EXISTS `dependency`;
CREATE TABLE `dependency` (
  `from` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '被引用方(上游)标识',
  `type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `to` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '下游标识',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '额外信息',
  PRIMARY KEY (`from`,`type`,`to`) USING BTREE,
  KEY `to_index` (`to`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='全局引用关系表';

-- ----------------------------
-- Table structure for deploy_app_config
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config`;
CREATE TABLE `deploy_app_config` (
  `id` bigint NOT NULL COMMENT 'id',
  `app_system_id` bigint NOT NULL COMMENT '应用系统id',
  `app_module_id` bigint NOT NULL DEFAULT '0' COMMENT '模块id',
  `env_id` bigint NOT NULL DEFAULT '0' COMMENT '环境id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置信息',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_appId_moduleId_envId` (`app_system_id`,`app_module_id`,`env_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用系统配置';

-- ----------------------------
-- Table structure for deploy_app_config_authority
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config_authority`;
CREATE TABLE `deploy_app_config_authority` (
  `app_system_id` bigint NOT NULL COMMENT '应用资产id',
  `auth_type` enum('team','user','role','common') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权类型 user|team|role',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权用户对象',
  `action_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权操作类型',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权操作',
  `lcd` timestamp(3) NOT NULL COMMENT '最后一次修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后一次修改人',
  PRIMARY KEY (`app_system_id`,`auth_type`,`auth_uuid`,`action_type`,`action`) USING BTREE,
  KEY `idx_app_env_authuuid_action` (`app_system_id`,`action_type`,`auth_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用系统配置授权';

-- ----------------------------
-- Table structure for deploy_app_config_draft
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config_draft`;
CREATE TABLE `deploy_app_config_draft` (
  `app_system_id` bigint NOT NULL COMMENT '应用系统id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `env_id` bigint NOT NULL DEFAULT '0' COMMENT '环境id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '流水线部分配置信息',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改用户',
  PRIMARY KEY (`app_system_id`,`app_module_id`,`env_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='应用系统模块环境流水线阶段关系表';

-- ----------------------------
-- Table structure for deploy_app_config_env
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config_env`;
CREATE TABLE `deploy_app_config_env` (
  `app_system_id` bigint NOT NULL COMMENT '应用系统id',
  `app_module_id` bigint NOT NULL COMMENT '应用模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  PRIMARY KEY (`app_system_id`,`app_module_id`,`env_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用配置环境表';

-- ----------------------------
-- Table structure for deploy_app_config_env_db
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config_env_db`;
CREATE TABLE `deploy_app_config_env_db` (
  `id` bigint NOT NULL COMMENT 'id',
  `db_schema` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据库schema',
  `app_system_id` bigint NOT NULL COMMENT '应用系统id',
  `app_module_id` bigint NOT NULL COMMENT '应用模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `db_resource_id` bigint DEFAULT NULL COMMENT '数据库id',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '高级设置',
  `account_id` bigint DEFAULT NULL COMMENT '账号id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `un_app_system_id_app_module_id_env_id_db_schema` (`db_schema`,`app_system_id`,`app_module_id`,`env_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用配置环境层DB配置表';

-- ----------------------------
-- Table structure for deploy_app_config_env_db_account
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config_env_db_account`;
CREATE TABLE `deploy_app_config_env_db_account` (
  `id` bigint NOT NULL COMMENT 'id',
  `db_config_id` bigint NOT NULL COMMENT 'DB配置id',
  `account_alias` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户别名',
  `account_id` bigint NOT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用配置环境层DB配置账号表';

-- ----------------------------
-- Table structure for deploy_app_config_user
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_config_user`;
CREATE TABLE `deploy_app_config_user` (
  `app_system_id` bigint NOT NULL COMMENT '应用资产id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '收藏人',
  PRIMARY KEY (`app_system_id`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用系统配置收藏';

-- ----------------------------
-- Table structure for deploy_app_env_auto_config
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_env_auto_config`;
CREATE TABLE `deploy_app_env_auto_config` (
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `env_id` bigint NOT NULL COMMENT '环境资产id',
  `instance_id` bigint NOT NULL COMMENT '实例资产id',
  `key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变量名',
  `value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '变量值',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后一次修改人',
  PRIMARY KEY (`app_system_id`,`app_module_id`,`env_id`,`instance_id`,`key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用环境变量配置';

-- ----------------------------
-- Table structure for deploy_app_module_runner_group
-- ----------------------------
DROP TABLE IF EXISTS `deploy_app_module_runner_group`;
CREATE TABLE `deploy_app_module_runner_group` (
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块资产id',
  `runner_group_id` bigint DEFAULT NULL COMMENT 'runner组id',
  PRIMARY KEY (`app_system_id`,`app_module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布应用模块runner组关联';

-- ----------------------------
-- Table structure for deploy_ci
-- ----------------------------
DROP TABLE IF EXISTS `deploy_ci`;
CREATE TABLE `deploy_ci` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_active` tinyint(1) NOT NULL COMMENT '是否激活',
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `repo_type` enum('gitlab','svn') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库类型',
  `repo_server_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库服务器地址',
  `repo_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '仓库名',
  `branch_filter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分支过滤',
  `event` enum('post-receive','post-commit') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事件',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '动作',
  `trigger_type` enum('auto','manual','instant','delay') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '触发类型',
  `trigger_time` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '触发时间',
  `delay_time` int DEFAULT NULL COMMENT '延迟时间',
  `version_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本号规则',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `hook_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'webhook id',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布持续集成表';

-- ----------------------------
-- Table structure for deploy_ci_audit
-- ----------------------------
DROP TABLE IF EXISTS `deploy_ci_audit`;
CREATE TABLE `deploy_ci_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `ci_id` bigint NOT NULL COMMENT '持续集成配置id',
  `commit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '提交id',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '动作',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `job_id` bigint DEFAULT NULL COMMENT '作业id',
  `param_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数内容文件路径',
  `result_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结果内容文件路径',
  `error_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误内容文件路径',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '触发时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布持续集成记录表';

-- ----------------------------
-- Table structure for deploy_env_version
-- ----------------------------
DROP TABLE IF EXISTS `deploy_env_version`;
CREATE TABLE `deploy_env_version` (
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `version_id` bigint NOT NULL COMMENT '版本id',
  `build_no` int DEFAULT NULL COMMENT '编译号',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`app_system_id`,`app_module_id`,`env_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='环境当前版本';

-- ----------------------------
-- Table structure for deploy_env_version_audit
-- ----------------------------
DROP TABLE IF EXISTS `deploy_env_version_audit`;
CREATE TABLE `deploy_env_version_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `new_version_id` bigint NOT NULL COMMENT '新版本id',
  `old_version_id` bigint DEFAULT NULL COMMENT '旧版本id',
  `new_build_no` int DEFAULT NULL COMMENT '新版本编译号',
  `old_build_no` int DEFAULT NULL COMMENT '旧版本编译号',
  `direction` enum('forward','rollback') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'forward:发布版本;rollback:回滚版本',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_system_module_env_new_version` (`app_system_id`,`app_module_id`,`env_id`,`new_version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='环境版本变更记录';

-- ----------------------------
-- Table structure for deploy_instance_version
-- ----------------------------
DROP TABLE IF EXISTS `deploy_instance_version`;
CREATE TABLE `deploy_instance_version` (
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `resource_id` bigint NOT NULL COMMENT '实例id',
  `version_id` bigint NOT NULL COMMENT '版本id',
  `build_no` int DEFAULT NULL COMMENT '编译号',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`app_system_id`,`app_module_id`,`env_id`,`resource_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布实例当前版本';

-- ----------------------------
-- Table structure for deploy_instance_version_audit
-- ----------------------------
DROP TABLE IF EXISTS `deploy_instance_version_audit`;
CREATE TABLE `deploy_instance_version_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_module_id` bigint NOT NULL COMMENT '模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `resource_id` bigint NOT NULL COMMENT '实例id',
  `new_version_id` bigint NOT NULL COMMENT '新版本id',
  `old_version_id` bigint DEFAULT NULL COMMENT '旧版本id',
  `new_build_no` int DEFAULT NULL COMMENT '新版本编译号',
  `old_build_no` int DEFAULT NULL COMMENT '旧版本编译号',
  `direction` enum('forward','rollback') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'forward:发布版本;rollback:回滚版本',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_system_module_env_resource_new_version` (`app_system_id`,`app_module_id`,`env_id`,`resource_id`,`new_version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='实例版本变更记录';

-- ----------------------------
-- Table structure for deploy_job
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job`;
CREATE TABLE `deploy_job` (
  `id` bigint NOT NULL COMMENT 'id',
  `app_system_id` bigint NOT NULL COMMENT '系统id',
  `app_module_id` bigint NOT NULL COMMENT '系统模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `version_id` bigint DEFAULT NULL COMMENT '版本id',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本号',
  `scenario_id` bigint DEFAULT NULL COMMENT '场景id',
  `runner_map_id` bigint DEFAULT NULL COMMENT '编译|构造的runner_id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `build_no` int DEFAULT NULL COMMENT '编译号',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置hash',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_app_id` (`app_system_id`) USING BTREE,
  KEY `idx_module_id` (`app_module_id`) USING BTREE,
  KEY `idx_appId_modueId_version_jobId` (`app_system_id`,`app_module_id`,`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布作业表';

-- ----------------------------
-- Table structure for deploy_job_auth
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_auth`;
CREATE TABLE `deploy_job_auth` (
  `job_id` bigint DEFAULT NULL COMMENT '作业id',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权对象',
  `type` enum('user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权类型',
  KEY `idx_job_id` (`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布作业授权';

-- ----------------------------
-- Table structure for deploy_job_content
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_content`;
CREATE TABLE `deploy_job_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置hash',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布作业配置hash';

-- ----------------------------
-- Table structure for deploy_job_lane
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_lane`;
CREATE TABLE `deploy_job_lane` (
  `id` bigint NOT NULL COMMENT '批量作业泳道id',
  `batch_job_id` bigint DEFAULT NULL COMMENT '批量作业id',
  `sort` int DEFAULT NULL COMMENT '排序',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布作业泳道表';

-- ----------------------------
-- Table structure for deploy_job_lane_group
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_lane_group`;
CREATE TABLE `deploy_job_lane_group` (
  `id` bigint NOT NULL COMMENT '组id',
  `lane_id` bigint DEFAULT NULL COMMENT '泳道id',
  `need_wait` tinyint(1) DEFAULT NULL COMMENT '是否需要等待',
  `sort` int DEFAULT NULL COMMENT '排序',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='批量作业泳道组表';

-- ----------------------------
-- Table structure for deploy_job_lane_group_job
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_lane_group_job`;
CREATE TABLE `deploy_job_lane_group_job` (
  `group_id` bigint NOT NULL COMMENT '泳道组id',
  `job_id` bigint NOT NULL COMMENT '作业id',
  `sort` int DEFAULT NULL COMMENT '顺序',
  PRIMARY KEY (`group_id`,`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='批量作业泳道组作业关联表';

-- ----------------------------
-- Table structure for deploy_job_notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_notify_policy`;
CREATE TABLE `deploy_job_notify_policy` (
  `app_system_id` bigint NOT NULL COMMENT '应用系统id',
  `notify_policy_id` bigint NOT NULL COMMENT '通知策略id',
  `config` mediumtext COMMENT '通知策略个性化配置',
  PRIMARY KEY (`app_system_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='发布作业引用通知策略表';

-- ----------------------------
-- Table structure for deploy_job_trigger
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_trigger`;
CREATE TABLE `deploy_job_trigger` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集成uuid',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业类型',
  `pipeline_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '流水线类型',
  `build_no_policy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编译号策略:the_same :和原作业一致 new:新建buildNo',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后一次修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布触发器';

-- ----------------------------
-- Table structure for deploy_job_webhook
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_webhook`;
CREATE TABLE `deploy_job_webhook` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集成uuid',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业类型',
  `pipeline_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '流水线类型',
  `build_no_policy` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '编译号策略',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后一次修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布触发器';

-- ----------------------------
-- Table structure for deploy_job_webhook_app_module
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_webhook_app_module`;
CREATE TABLE `deploy_job_webhook_app_module` (
  `webhook_id` bigint NOT NULL COMMENT '触发器id',
  `app_system_id` bigint NOT NULL COMMENT '应用系统id',
  `app_module_id` bigint NOT NULL COMMENT '应用模块id',
  PRIMARY KEY (`webhook_id`,`app_system_id`,`app_module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for deploy_job_webhook_audit
-- ----------------------------
DROP TABLE IF EXISTS `deploy_job_webhook_audit`;
CREATE TABLE `deploy_job_webhook_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `webhook_id` bigint DEFAULT NULL COMMENT '触发器id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `integration_audit_id` bigint DEFAULT NULL COMMENT '集成记录id',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '触发事件',
  `from_job_id` bigint DEFAULT NULL COMMENT '来源作业id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_triggerid` (`webhook_id`) USING BTREE,
  KEY `idx_integration_autditid` (`integration_audit_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='作业触发器记录表';

-- ----------------------------
-- Table structure for deploy_package
-- ----------------------------
DROP TABLE IF EXISTS `deploy_package`;
CREATE TABLE `deploy_package` (
  `id` bigint NOT NULL COMMENT '主键',
  `group_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工程组标识，在一个组织或者项目中通常是唯一的',
  `artifact_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工程标识，通常是工程的名称，groupId 和 artifact_id 一起定义了 artifact在仓库中的位置',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工程版本号',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'jar' COMMENT '包类型，默认为jar',
  `license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版权许可，开源协议等',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '包在maven仓库中的地址',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_pkg` (`group_id`,`artifact_id`,`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布包信息';

-- ----------------------------
-- Table structure for deploy_pipeline
-- ----------------------------
DROP TABLE IF EXISTS `deploy_pipeline`;
CREATE TABLE `deploy_pipeline` (
  `id` bigint NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint DEFAULT NULL,
  `fcd` timestamp(3) NULL DEFAULT NULL,
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lcd` timestamp(3) NULL DEFAULT NULL,
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` enum('appsystem','global') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_system_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='超级流水线';

-- ----------------------------
-- Table structure for deploy_pipeline_auth
-- ----------------------------
DROP TABLE IF EXISTS `deploy_pipeline_auth`;
CREATE TABLE `deploy_pipeline_auth` (
  `pipeline_id` bigint DEFAULT NULL COMMENT '作业id',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权对象',
  `type` enum('user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权类型',
  KEY `idx_job_id` (`pipeline_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='超级流水线授权';

-- ----------------------------
-- Table structure for deploy_pipeline_group
-- ----------------------------
DROP TABLE IF EXISTS `deploy_pipeline_group`;
CREATE TABLE `deploy_pipeline_group` (
  `id` bigint NOT NULL COMMENT '组id',
  `lane_id` bigint DEFAULT NULL COMMENT '泳道id',
  `need_wait` tinyint(1) DEFAULT NULL COMMENT '是否需要等待',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='批量作业泳道组表';

-- ----------------------------
-- Table structure for deploy_pipeline_jobtemplate
-- ----------------------------
DROP TABLE IF EXISTS `deploy_pipeline_jobtemplate`;
CREATE TABLE `deploy_pipeline_jobtemplate` (
  `id` bigint NOT NULL COMMENT 'id',
  `group_id` bigint DEFAULT NULL COMMENT '分组id',
  `app_system_id` bigint NOT NULL COMMENT '系统id',
  `app_module_id` bigint NOT NULL COMMENT '系统模块id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `scenario_id` bigint DEFAULT NULL COMMENT '场景id',
  `round_count` int DEFAULT NULL COMMENT '分批数量',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_app_id` (`app_system_id`) USING BTREE,
  KEY `idx_module_id` (`app_module_id`) USING BTREE,
  KEY `idx_appId_modueId_version_jobId` (`app_system_id`,`app_module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布超级流水线作业模板表';

-- ----------------------------
-- Table structure for deploy_pipeline_lane
-- ----------------------------
DROP TABLE IF EXISTS `deploy_pipeline_lane`;
CREATE TABLE `deploy_pipeline_lane` (
  `id` bigint NOT NULL COMMENT '流水线泳道id',
  `pipeline_id` bigint DEFAULT NULL COMMENT '流水线id',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布作业泳道超级流水线表';

-- ----------------------------
-- Table structure for deploy_schedule
-- ----------------------------
DROP TABLE IF EXISTS `deploy_schedule`;
CREATE TABLE `deploy_schedule` (
  `id` bigint NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一uuid',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `begin_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `cron` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'corn表达式',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0:禁用，1:激活',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '执行配置信息',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改用户',
  `type` enum('general','pipeline') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作业类型',
  `app_system_id` bigint DEFAULT NULL COMMENT '应用id',
  `app_module_id` bigint DEFAULT NULL COMMENT '模块id',
  `pipeline_id` bigint DEFAULT NULL COMMENT '流水线id',
  `pipeline_type` enum('appsystem','global') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '流水线类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业信息表';

-- ----------------------------
-- Table structure for deploy_sql_detail
-- ----------------------------
DROP TABLE IF EXISTS `deploy_sql_detail`;
CREATE TABLE `deploy_sql_detail` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `system_id` bigint DEFAULT NULL COMMENT '系统 id',
  `module_id` bigint DEFAULT NULL COMMENT '模块 id',
  `env_id` bigint DEFAULT NULL COMMENT '环境 id',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '版本',
  `status` enum('pending','running','aborting','aborted','succeed','failed','ignored','waitInput') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `sql_file` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sql文件名称',
  `md5` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'sql文件md5',
  `host` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip',
  `port` int DEFAULT NULL COMMENT '端口',
  `resource_id` bigint DEFAULT NULL COMMENT '资产 id',
  `node_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业节点名',
  `is_delete` tinyint DEFAULT NULL COMMENT '是否删除',
  `runner_id` bigint DEFAULT NULL COMMENT 'runner id',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `node_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '节点类型',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名',
  `sort` int DEFAULT NULL COMMENT '排序',
  `is_modified` int DEFAULT NULL COMMENT '是否改动',
  `warn_count` int DEFAULT NULL COMMENT '告警个数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_system_id_module_id_env_id_version_sql_file` (`system_id`,`module_id`,`env_id`,`version`,`sql_file`,`resource_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布sql状态表';

-- ----------------------------
-- Table structure for deploy_sql_job_phase
-- ----------------------------
DROP TABLE IF EXISTS `deploy_sql_job_phase`;
CREATE TABLE `deploy_sql_job_phase` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `job_id` bigint DEFAULT NULL COMMENT '作业 id',
  `sql_id` bigint DEFAULT NULL COMMENT '执行sql详情 id',
  `job_phase_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作业剧本名',
  `job_phase_id` bigint DEFAULT NULL COMMENT '作业剧本id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `ux_job_id_sql_id_job_phase_name` (`job_id`,`sql_id`,`job_phase_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布sql与作业剧本关系表';

-- ----------------------------
-- Table structure for deploy_type_status
-- ----------------------------
DROP TABLE IF EXISTS `deploy_type_status`;
CREATE TABLE `deploy_type_status` (
  `type_id` bigint NOT NULL COMMENT '工具类型id',
  `is_active` int NOT NULL COMMENT '是否激活(0:禁用，1：激活)',
  PRIMARY KEY (`type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布工具类型状态表';

-- ----------------------------
-- Table structure for deploy_version
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version`;
CREATE TABLE `deploy_version` (
  `id` bigint NOT NULL COMMENT '主键',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本',
  `app_system_id` bigint NOT NULL COMMENT '应用id',
  `app_system_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '应用名称',
  `app_module_id` bigint NOT NULL COMMENT '应用模块id',
  `app_module_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '应用模块名称',
  `is_freeze` tinyint NOT NULL COMMENT '是否封版',
  `runner_map_id` bigint DEFAULT NULL COMMENT 'runner映射id',
  `runner_group` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'runner组',
  `compile_success_count` int DEFAULT NULL COMMENT '编译成功次数',
  `compile_fail_count` int DEFAULT NULL COMMENT '编译失败次数',
  `repo_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '仓库类型',
  `repo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '仓库地址',
  `trunk` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主干',
  `branch` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分支',
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `tags_dir` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签目录',
  `start_rev` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开始Rev号',
  `end_rev` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结束Rev号',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_app_system_id_app_module_id_version` (`version`,`app_system_id`,`app_module_id`) USING BTREE,
  KEY `id_is_locked` (`is_freeze`) USING BTREE,
  KEY `idx_fcd` (`fcd`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布版本表';

-- ----------------------------
-- Table structure for deploy_version_appbuild_credential
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_appbuild_credential`;
CREATE TABLE `deploy_version_appbuild_credential` (
  `proxy_to_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '跳转url',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转认证用户',
  PRIMARY KEY (`proxy_to_url`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布版本应用系统编译认证关联表';

-- ----------------------------
-- Table structure for deploy_version_build_quality
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_build_quality`;
CREATE TABLE `deploy_version_build_quality` (
  `id` bigint NOT NULL COMMENT 'id',
  `version_id` bigint NOT NULL COMMENT '版本id',
  `build_time` timestamp(3) NULL DEFAULT NULL COMMENT '编译时间',
  `files` int DEFAULT NULL COMMENT '文件数',
  `classes` int DEFAULT NULL COMMENT '类数',
  `lines` int DEFAULT NULL COMMENT '物理行数（回车数）',
  `ncloc` int DEFAULT NULL COMMENT '代码行数',
  `functions` int DEFAULT NULL COMMENT '函数个数',
  `statements` int DEFAULT NULL COMMENT '语句数',
  `complexity` int DEFAULT NULL COMMENT '复杂度',
  `file_complexity` int DEFAULT NULL COMMENT '文件复杂度',
  `class_complexity` int DEFAULT NULL COMMENT '类复杂度',
  `function_complexity` int DEFAULT NULL COMMENT '函数复杂度',
  `violations` int DEFAULT NULL COMMENT '违规总数',
  `blocker_violations` int DEFAULT NULL COMMENT '阻碍性违规',
  `critical_violations` int DEFAULT NULL COMMENT '严重违规',
  `major_violations` int DEFAULT NULL COMMENT '主要违规',
  `minor_violations` int DEFAULT NULL COMMENT '次要违规',
  `executable_lines_data` int DEFAULT NULL COMMENT '可执行行数据',
  `it_conditions_to_cover` int DEFAULT NULL COMMENT 'it_conditions_to_cover',
  `it_branch_coverage` int DEFAULT NULL COMMENT 'it_branch_coverage',
  `it_conditions_by_line` int DEFAULT NULL COMMENT 'it_conditions_by_line',
  `it_coverage` int DEFAULT NULL COMMENT 'it_coverage',
  `it_coverage_line_hits_data` int DEFAULT NULL COMMENT 'it_coverage_line_hits_data',
  `it_covered_conditions_by_line` int DEFAULT NULL COMMENT 'it_covered_conditions_by_line',
  `it_line_coverage` int DEFAULT NULL COMMENT 'it_line_coverage',
  `it_lines_to_cover` int DEFAULT NULL COMMENT 'it_lines_to_cover',
  `comment_lines_density` double(5,1) DEFAULT NULL COMMENT '行注释 (%)',
  `public_documented_api_density` int DEFAULT NULL COMMENT '添加注释的公有API占比',
  `duplicated_files` int DEFAULT NULL COMMENT '重复文件',
  `duplicated_lines` int DEFAULT NULL COMMENT '重复行',
  `duplicated_lines_density` double(5,1) DEFAULT NULL COMMENT '重复行 (%)',
  `new_duplicated_lines` int DEFAULT NULL COMMENT '新重复行',
  `new_duplicated_lines_density` int DEFAULT NULL COMMENT '新重复行 (%)',
  `duplicated_blocks` int DEFAULT NULL COMMENT '重复块',
  `new_duplicated_blocks` int DEFAULT NULL COMMENT '新重复块',
  `bugs` int DEFAULT NULL COMMENT '漏洞',
  `vulnerabilities` int DEFAULT NULL COMMENT '缺陷',
  `code_smells` int DEFAULT NULL COMMENT '代码味道',
  `new_security_hotspots` int DEFAULT NULL COMMENT '新代码安全热点',
  `new_security_rating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '新代码安全率',
  `new_security_remediation_effort` int DEFAULT NULL COMMENT '新代码修复工作',
  `new_vulnerabilities` int DEFAULT NULL COMMENT '新代码漏洞',
  `security_hotspots` int DEFAULT NULL COMMENT '安全热点',
  `security_rating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '安全率',
  `security_remediation_effort` int DEFAULT NULL COMMENT '修复工作',
  `comment_lines` int DEFAULT NULL COMMENT '注释行',
  `ncloc_language_distribution` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '每种语言的代码行数',
  `new_lines` int DEFAULT NULL COMMENT '新增代码行数',
  `cognitive_complexity` int DEFAULT NULL COMMENT '认知复杂性',
  `conditions_to_cover` int DEFAULT NULL COMMENT '覆盖的条件',
  `coverage` double(7,2) DEFAULT NULL COMMENT '覆盖率',
  `lines_to_cover` int DEFAULT NULL COMMENT '覆盖行',
  `new_conditions_to_cover` int DEFAULT NULL COMMENT '新代码覆盖的条件',
  `new_coverage` double(7,2) DEFAULT NULL COMMENT '新代码覆盖率',
  `new_lines_to_cover` int DEFAULT NULL COMMENT '新代码覆盖行',
  `new_uncovered_conditions` int DEFAULT NULL COMMENT '新代码未覆盖的条件',
  `new_uncovered_lines` int DEFAULT NULL COMMENT '新代码未覆盖行',
  `uncovered_conditions` int DEFAULT NULL COMMENT '未覆盖的条件',
  `uncovered_lines` int DEFAULT NULL COMMENT '未覆盖行',
  `new_bugs` int DEFAULT NULL COMMENT '新代码错误',
  `new_reliability_rating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '新代码可靠率',
  `reliability_rating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '可靠率',
  `new_code_smells` int DEFAULT NULL COMMENT '新代码异味',
  `new_sqale_debt_ratio` double(7,2) DEFAULT NULL COMMENT '新代码的技术债务比率',
  `new_technical_debt` int DEFAULT NULL COMMENT '新代码的技术债务',
  `sqale_debt_ratio` double(7,2) DEFAULT NULL COMMENT '技术债务比率',
  `sqale_index` int DEFAULT NULL COMMENT '技术债务',
  `sqale_rating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '可维护率',
  `confirmed_issues` int DEFAULT NULL COMMENT '确认问题',
  `false_positive_issues` int DEFAULT NULL COMMENT '误判问题',
  `info_violations` int DEFAULT NULL COMMENT '提示问题',
  `new_blocker_violations` int DEFAULT NULL COMMENT '新代码阻断问题',
  `new_critical_violations` int DEFAULT NULL COMMENT '新代码严重问题',
  `new_info_violations` int DEFAULT NULL COMMENT '新代码提示问题',
  `new_major_violations` int DEFAULT NULL COMMENT '新代码主要问题',
  `new_minor_violations` int DEFAULT NULL COMMENT '新代码次要问题',
  `new_violations` int DEFAULT NULL COMMENT '新违规',
  `open_issues` int DEFAULT NULL COMMENT '开启问题',
  `reopened_issues` int DEFAULT NULL COMMENT '重开问题',
  `wont_fix_issues` int DEFAULT NULL COMMENT '不修复的问题',
  `alert_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '质量阀',
  `quality_gate_details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '质量阀详细信息',
  `threshold` bigint DEFAULT NULL COMMENT '漏洞阀值',
  `new_maintainability_rating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '新代码可维护率',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `version_build_time` (`version_id`,`build_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布编译质量';

-- ----------------------------
-- Table structure for deploy_version_buildno
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_buildno`;
CREATE TABLE `deploy_version_buildno` (
  `version_id` bigint NOT NULL COMMENT '发布版本表关联id',
  `build_no` int NOT NULL COMMENT '编译号',
  `job_id` bigint NOT NULL COMMENT '作业id',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编译状态',
  `runner_map_id` bigint NOT NULL DEFAULT '0' COMMENT 'runner映射id',
  `runner_group` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'runner组',
  `compile_start_time` timestamp(3) NULL DEFAULT NULL COMMENT '编译开始时间',
  `compile_end_time` timestamp(3) NULL DEFAULT NULL COMMENT '编译结束时间',
  `end_rev` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结束Rev号',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`version_id`,`build_no`) USING BTREE,
  KEY `idx_jobId` (`job_id`) USING BTREE,
  KEY `id_fcd` (`compile_start_time`) USING BTREE,
  KEY `idx_compile_start_time` (`compile_start_time`) USING BTREE,
  KEY `idx_buildno` (`build_no`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布版本编译序号关联表';

-- ----------------------------
-- Table structure for deploy_version_dependency
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_dependency`;
CREATE TABLE `deploy_version_dependency` (
  `id` bigint NOT NULL COMMENT '主键',
  `version_id` bigint NOT NULL COMMENT '版本id',
  `package_id` bigint NOT NULL COMMENT '关联deploy_pkg表中id',
  `scope` enum('compile','provided','runtime','test','system','import') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'compile' COMMENT '依赖作用域，默认compile',
  `parent_id` bigint DEFAULT NULL COMMENT '父依赖id，关联deploy_pkg表中id',
  `build_time` timestamp(3) NULL DEFAULT NULL COMMENT '编译时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_version_id_package_id` (`version_id`,`package_id`) USING BTREE,
  KEY `idx_version_id` (`version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布版本依赖';

-- ----------------------------
-- Table structure for deploy_version_deployed_instance
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_deployed_instance`;
CREATE TABLE `deploy_version_deployed_instance` (
  `id` bigint NOT NULL COMMENT 'id',
  `resource_id` bigint NOT NULL COMMENT '实例id',
  `version_id` bigint NOT NULL COMMENT '版本id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `deploy_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发布人',
  `deploy_time` timestamp(3) NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_instance_version` (`resource_id`,`version_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='已发布的版本实例表';

-- ----------------------------
-- Table structure for deploy_version_env
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_env`;
CREATE TABLE `deploy_version_env` (
  `version_id` bigint NOT NULL COMMENT '发布版本表关联id',
  `env_id` bigint NOT NULL COMMENT '环境id',
  `job_id` bigint NOT NULL COMMENT '作业id',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '环境状态',
  `runner_map_id` bigint NOT NULL COMMENT 'runner映射id',
  `runner_group` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'runner组',
  `build_no` int DEFAULT NULL COMMENT 'build序号',
  `is_mirror` tinyint(1) DEFAULT NULL COMMENT '是否是镜像制品',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`version_id`,`env_id`) USING BTREE,
  KEY `idx_jobId` (`job_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发布版本环境关联表';

-- ----------------------------
-- Table structure for deploy_version_unit_test
-- ----------------------------
DROP TABLE IF EXISTS `deploy_version_unit_test`;
CREATE TABLE `deploy_version_unit_test` (
  `id` bigint NOT NULL COMMENT 'id',
  `version_id` bigint NOT NULL COMMENT '版本id',
  `build_time` timestamp(3) NULL DEFAULT NULL COMMENT '编译时间',
  `tests` int DEFAULT NULL COMMENT '单元测试总数',
  `test_success_density` int DEFAULT NULL COMMENT '单元测试成功率',
  `test_errors` int DEFAULT NULL COMMENT '单元测试失败数',
  `branch_coverage` int DEFAULT NULL COMMENT '全量代码分支覆盖率',
  `new_branch_coverage` int DEFAULT NULL COMMENT '增量代码分支覆盖率',
  `line_coverage` int DEFAULT NULL COMMENT '全量行覆盖率',
  `new_line_coverage` int DEFAULT NULL COMMENT '增量行覆盖率',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `version_build_time` (`version_id`,`build_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='发版版本单元测试';

-- ----------------------------
-- Table structure for discovery_conf_combop
-- ----------------------------
DROP TABLE IF EXISTS `discovery_conf_combop`;
CREATE TABLE `discovery_conf_combop` (
  `conf_id` bigint NOT NULL COMMENT '自动发现id',
  `combop_id` bigint NOT NULL COMMENT '组合工具id',
  PRIMARY KEY (`conf_id`,`combop_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自动发现关联组合工具表';

-- ----------------------------
-- Table structure for event
-- ----------------------------
DROP TABLE IF EXISTS `event`;
CREATE TABLE `event` (
  `id` bigint NOT NULL COMMENT '主键',
  `event_type_id` bigint NOT NULL COMMENT '事件类型ID',
  `event_solution_id` bigint DEFAULT NULL COMMENT '解决方案ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='事件表';

-- ----------------------------
-- Table structure for event_solution
-- ----------------------------
DROP TABLE IF EXISTS `event_solution`;
CREATE TABLE `event_solution` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '解决方案名称',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人ID',
  `is_active` tinyint DEFAULT NULL COMMENT '是否启用',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '更新时间',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='事件解决方案表';

-- ----------------------------
-- Table structure for event_type
-- ----------------------------
DROP TABLE IF EXISTS `event_type`;
CREATE TABLE `event_type` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '事件类型名称',
  `parent_id` bigint NOT NULL COMMENT '父类型ID',
  `lft` int DEFAULT NULL COMMENT '左编码',
  `rht` int DEFAULT NULL COMMENT '右编码',
  `layer` int DEFAULT NULL COMMENT '节点所在层级',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_lft_rht` (`lft`,`rht`) USING BTREE,
  KEY `idx_rht_lft` (`rht`,`lft`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='事件类型表';

-- ----------------------------
-- Table structure for event_type_authority
-- ----------------------------
DROP TABLE IF EXISTS `event_type_authority`;
CREATE TABLE `event_type_authority` (
  `event_type_id` bigint NOT NULL COMMENT '事件类型ID',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权对象类型',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权对象ID',
  PRIMARY KEY (`event_type_id`,`type`,`uuid`) USING BTREE,
  KEY `idx_event_type_id` (`event_type_id`) USING BTREE,
  KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='事件类型授权表';

-- ----------------------------
-- Table structure for event_type_solution
-- ----------------------------
DROP TABLE IF EXISTS `event_type_solution`;
CREATE TABLE `event_type_solution` (
  `event_type_id` bigint NOT NULL COMMENT '事件类型ID',
  `solution_id` bigint NOT NULL COMMENT '解决方案ID',
  PRIMARY KEY (`event_type_id`,`solution_id`) USING BTREE,
  KEY `idx_solution_id` (`solution_id`) USING BTREE,
  KEY `idx_event_type_id` (`event_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='事件类型-解决方案关联表';

-- ----------------------------
-- Table structure for file
-- ----------------------------
DROP TABLE IF EXISTS `file`;
CREATE TABLE `file` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名称',
  `size` bigint NOT NULL COMMENT '文件大小',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属用户，引用user的user_uuid',
  `upload_time` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `content_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'mime type',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路径',
  `unique_key` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当附件名称需要保持唯一时，需要提供unique_key的md5 hex值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_size` (`size`) USING BTREE,
  KEY `idx_upload_time` (`upload_time`) USING BTREE,
  KEY `idx_name` (`name`,`unique_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='上传文件信息表';

-- ----------------------------
-- Table structure for filetype_config
-- ----------------------------
DROP TABLE IF EXISTS `filetype_config`;
CREATE TABLE `filetype_config` (
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'jsong格式，进行允许扩展名等设置',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文件类型配置表';

-- ----------------------------
-- Table structure for form
-- ----------------------------
DROP TABLE IF EXISTS `form`;
CREATE TABLE `form` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单uuid',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单名字',
  `is_active` tinyint(1) NOT NULL COMMENT '表单是否启用，1：启用，0：禁用',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='表单';

-- ----------------------------
-- Table structure for form_attribute
-- ----------------------------
DROP TABLE IF EXISTS `form_attribute`;
CREATE TABLE `form_attribute` (
  `form_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单uuid',
  `formversion_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单版本uuid',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性uuid',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性名',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性类型，系统属性不允许修改',
  `handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性处理器',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '属性配置',
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '属性默认值',
  PRIMARY KEY (`form_uuid`,`formversion_uuid`,`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='表单版本属性';

-- ----------------------------
-- Table structure for form_attribute_matrix
-- ----------------------------
DROP TABLE IF EXISTS `form_attribute_matrix`;
CREATE TABLE `form_attribute_matrix` (
  `form_version_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单版本uuid',
  `matrix_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '矩阵uuid',
  `form_attribute_label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单组件名称',
  `form_attribute_uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单组件uuid',
  PRIMARY KEY (`form_version_uuid`,`matrix_uuid`,`form_attribute_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='表单属性引用矩阵关系表';

-- ----------------------------
-- Table structure for form_customitem
-- ----------------------------
DROP TABLE IF EXISTS `form_customitem`;
CREATE TABLE `form_customitem` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示名',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置,json格式',
  `view_template_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '表单模板配置',
  `view_template` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '表单模板',
  `config_template_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '设置模板配置',
  `config_template` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '设置模板',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='自定义表单属性表';

-- ----------------------------
-- Table structure for form_version
-- ----------------------------
DROP TABLE IF EXISTS `form_version`;
CREATE TABLE `form_version` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单版本uuid',
  `version` int DEFAULT NULL COMMENT '表单版本',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '表单版本是否启用，1：启用；2：禁用',
  `form_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表单uuid',
  `form_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '表单配置',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '第一次创建表单版本时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '第一次创建表单版本用户',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次修改表单版本时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '崔后一次修改表单版本用户',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_form_uui` (`form_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='表单版本';

-- ----------------------------
-- Table structure for fulltextindex_content_autoexec
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_content_autoexec`;
CREATE TABLE `fulltextindex_content_autoexec` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标内容表';

-- ----------------------------
-- Table structure for fulltextindex_content_cmdb
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_content_cmdb`;
CREATE TABLE `fulltextindex_content_cmdb` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标内容表';

-- ----------------------------
-- Table structure for fulltextindex_content_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_content_knowledge`;
CREATE TABLE `fulltextindex_content_knowledge` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标内容表';

-- ----------------------------
-- Table structure for fulltextindex_content_process
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_content_process`;
CREATE TABLE `fulltextindex_content_process` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标内容表';

-- ----------------------------
-- Table structure for fulltextindex_content_rdm
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_content_rdm`;
CREATE TABLE `fulltextindex_content_rdm` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_field` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段',
  `content` mediumtext COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`target_id`,`target_field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标内容表';

-- ----------------------------
-- Table structure for fulltextindex_field_autoexec
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_field_autoexec`;
CREATE TABLE `fulltextindex_field_autoexec` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_id` bigint NOT NULL COMMENT '词id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段',
  `target_id` bigint NOT NULL COMMENT '目标文档id',
  `counter` int NOT NULL DEFAULT '0' COMMENT '出现次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_word` (`word_id`,`target_id`,`target_field`) USING BTREE,
  KEY `idx_target_id` (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=884764531032095 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词表';

-- ----------------------------
-- Table structure for fulltextindex_field_cmdb
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_field_cmdb`;
CREATE TABLE `fulltextindex_field_cmdb` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_id` bigint NOT NULL COMMENT '词id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段',
  `target_id` bigint NOT NULL COMMENT '目标文档id',
  `counter` int NOT NULL DEFAULT '0' COMMENT '出现次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_word` (`word_id`,`target_id`,`target_field`) USING BTREE,
  KEY `idx_target_id` (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=899239753613415 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词表';

-- ----------------------------
-- Table structure for fulltextindex_field_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_field_knowledge`;
CREATE TABLE `fulltextindex_field_knowledge` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_id` bigint NOT NULL COMMENT '词id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段',
  `target_id` bigint NOT NULL COMMENT '目标文档id',
  `counter` int NOT NULL DEFAULT '0' COMMENT '出现次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_word` (`word_id`,`target_id`,`target_field`) USING BTREE,
  KEY `idx_target_id` (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=899063525736455 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词表';

-- ----------------------------
-- Table structure for fulltextindex_field_process
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_field_process`;
CREATE TABLE `fulltextindex_field_process` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_id` bigint NOT NULL COMMENT '词id',
  `target_field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段',
  `target_id` bigint NOT NULL COMMENT '目标文档id',
  `counter` int NOT NULL DEFAULT '0' COMMENT '出现次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_word` (`word_id`,`target_id`,`target_field`) USING BTREE,
  KEY `idx_target_id` (`target_id`,`target_field`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=899239040581874 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词表';

-- ----------------------------
-- Table structure for fulltextindex_field_rdm
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_field_rdm`;
CREATE TABLE `fulltextindex_field_rdm` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_id` bigint NOT NULL COMMENT '词id',
  `target_field` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段',
  `target_id` bigint NOT NULL COMMENT '目标文档id',
  `counter` int NOT NULL DEFAULT '0' COMMENT '出现次数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_word` (`word_id`,`target_id`,`target_field`),
  KEY `idx_target_id` (`target_id`,`target_field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词表';

-- ----------------------------
-- Table structure for fulltextindex_offset_autoexec
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_offset_autoexec`;
CREATE TABLE `fulltextindex_offset_autoexec` (
  `field_id` bigint NOT NULL COMMENT '词id',
  `start` int NOT NULL COMMENT 'start',
  `end` int NOT NULL COMMENT 'end',
  PRIMARY KEY (`field_id`,`start`,`end`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词定位表';

-- ----------------------------
-- Table structure for fulltextindex_offset_cmdb
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_offset_cmdb`;
CREATE TABLE `fulltextindex_offset_cmdb` (
  `field_id` bigint NOT NULL COMMENT '词id',
  `start` int NOT NULL COMMENT 'start',
  `end` int NOT NULL COMMENT 'end',
  PRIMARY KEY (`field_id`,`start`,`end`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词定位表';

-- ----------------------------
-- Table structure for fulltextindex_offset_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_offset_knowledge`;
CREATE TABLE `fulltextindex_offset_knowledge` (
  `field_id` bigint NOT NULL COMMENT '词id',
  `start` int NOT NULL COMMENT 'start',
  `end` int NOT NULL COMMENT 'end',
  PRIMARY KEY (`field_id`,`start`,`end`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词定位表';

-- ----------------------------
-- Table structure for fulltextindex_offset_process
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_offset_process`;
CREATE TABLE `fulltextindex_offset_process` (
  `field_id` bigint NOT NULL COMMENT '词id',
  `start` int NOT NULL COMMENT 'start',
  `end` int NOT NULL COMMENT 'end',
  PRIMARY KEY (`field_id`,`start`,`end`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词定位表';

-- ----------------------------
-- Table structure for fulltextindex_offset_rdm
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_offset_rdm`;
CREATE TABLE `fulltextindex_offset_rdm` (
  `field_id` bigint NOT NULL COMMENT '词id',
  `start` int NOT NULL COMMENT 'start',
  `end` int NOT NULL COMMENT 'end',
  PRIMARY KEY (`field_id`,`start`,`end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引词定位表';

-- ----------------------------
-- Table structure for fulltextindex_rebuild_audit
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_rebuild_audit`;
CREATE TABLE `fulltextindex_rebuild_audit` (
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `status` enum('doing','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `editor` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发起人',
  `server_id` int DEFAULT NULL COMMENT '服务器id',
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='索引重建日志';

-- ----------------------------
-- Table structure for fulltextindex_target_autoexec
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_target_autoexec`;
CREATE TABLE `fulltextindex_target_autoexec` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `hit_count` int DEFAULT NULL COMMENT '命中次数',
  `click_count` int DEFAULT NULL COMMENT '点击次数',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '索引异常',
  PRIMARY KEY (`target_id`) USING BTREE,
  KEY `idx_type` (`target_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引命中表';

-- ----------------------------
-- Table structure for fulltextindex_target_cmdb
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_target_cmdb`;
CREATE TABLE `fulltextindex_target_cmdb` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `hit_count` int DEFAULT NULL COMMENT '命中次数',
  `click_count` int DEFAULT NULL COMMENT '点击次数',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '索引异常',
  PRIMARY KEY (`target_id`) USING BTREE,
  KEY `idx_type` (`target_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引命中表';

-- ----------------------------
-- Table structure for fulltextindex_target_knowledge
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_target_knowledge`;
CREATE TABLE `fulltextindex_target_knowledge` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `hit_count` int DEFAULT NULL COMMENT '命中次数',
  `click_count` int DEFAULT NULL COMMENT '点击次数',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '索引异常',
  PRIMARY KEY (`target_id`) USING BTREE,
  KEY `idx_type` (`target_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引命中表';

-- ----------------------------
-- Table structure for fulltextindex_target_process
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_target_process`;
CREATE TABLE `fulltextindex_target_process` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `hit_count` int DEFAULT NULL COMMENT '命中次数',
  `click_count` int DEFAULT NULL COMMENT '点击次数',
  `error` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '索引异常',
  PRIMARY KEY (`target_id`) USING BTREE,
  KEY `idx_type` (`target_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引命中表';

-- ----------------------------
-- Table structure for fulltextindex_target_rdm
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_target_rdm`;
CREATE TABLE `fulltextindex_target_rdm` (
  `target_id` bigint NOT NULL COMMENT '目标id',
  `target_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `hit_count` int DEFAULT NULL COMMENT '命中次数',
  `click_count` int DEFAULT NULL COMMENT '点击次数',
  `error` longtext COLLATE utf8mb4_general_ci COMMENT '索引异常',
  PRIMARY KEY (`target_id`),
  KEY `idx_type` (`target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='目标索引命中表';

-- ----------------------------
-- Table structure for fulltextindex_word
-- ----------------------------
DROP TABLE IF EXISTS `fulltextindex_word`;
CREATE TABLE `fulltextindex_word` (
  `id` bigint unsigned NOT NULL COMMENT 'id',
  `word` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'word',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'type',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_word` (`word`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='wordbook';

-- ----------------------------
-- Table structure for global_lock
-- ----------------------------
DROP TABLE IF EXISTS `global_lock`;
CREATE TABLE `global_lock` (
  `id` bigint NOT NULL COMMENT '主键id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'key 散列的唯一标识',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'key ',
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '使用方',
  `handler_param` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '使用方入参',
  `is_lock` tinyint(1) DEFAULT NULL COMMENT '是否上锁,1:上锁,0:未锁,队列中',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '进队列时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '上锁时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='全局锁';

-- ----------------------------
-- Table structure for globalsearch_document
-- ----------------------------
DROP TABLE IF EXISTS `globalsearch_document`;
CREATE TABLE `globalsearch_document` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `target_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'target_id',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `hit_count` int DEFAULT NULL COMMENT '搜索命中次数',
  `click_count` int DEFAULT NULL COMMENT '搜索后点击次数',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT 'fcd',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT 'lcd',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_targetid` (`target_id`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='globalsearch_document';

-- ----------------------------
-- Table structure for globalsearch_document_field
-- ----------------------------
DROP TABLE IF EXISTS `globalsearch_document_field`;
CREATE TABLE `globalsearch_document_field` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word_id` bigint NOT NULL COMMENT '词id',
  `field` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '字段',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `document_id` bigint NOT NULL COMMENT '目标文档id',
  `counter` int NOT NULL DEFAULT '0' COMMENT '出现次数',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_document` (`document_id`) USING BTREE,
  KEY `idx_word` (`word_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='globalsearch_document_field';

-- ----------------------------
-- Table structure for globalsearch_document_offset
-- ----------------------------
DROP TABLE IF EXISTS `globalsearch_document_offset`;
CREATE TABLE `globalsearch_document_offset` (
  `field_id` bigint NOT NULL COMMENT 'field_id',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `start` int NOT NULL COMMENT 'start',
  `end` int NOT NULL COMMENT 'end',
  PRIMARY KEY (`field_id`,`type`,`start`,`end`) USING BTREE,
  KEY `idx_field_id` (`field_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='globalsearch_document_offset';

-- ----------------------------
-- Table structure for globalsearch_rebuild_audit
-- ----------------------------
DROP TABLE IF EXISTS `globalsearch_rebuild_audit`;
CREATE TABLE `globalsearch_rebuild_audit` (
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'type',
  `status` enum('doing','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'status',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT 'start_time',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT 'end_time',
  `editor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'editor',
  `server_id` int DEFAULT NULL COMMENT 'server_id',
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='rebuild_audit';

-- ----------------------------
-- Table structure for globalsearch_wordbook
-- ----------------------------
DROP TABLE IF EXISTS `globalsearch_wordbook`;
CREATE TABLE `globalsearch_wordbook` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `word` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'word',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'type',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_word` (`word`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='wordbook';

-- ----------------------------
-- Table structure for inspect_accessendpoint_script
-- ----------------------------
DROP TABLE IF EXISTS `inspect_accessendpoint_script`;
CREATE TABLE `inspect_accessendpoint_script` (
  `resource_id` bigint NOT NULL COMMENT '资源id',
  `script_id` bigint DEFAULT NULL COMMENT '脚本id',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '拓展配置',
  PRIMARY KEY (`resource_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='资产清单的脚本关联表';

-- ----------------------------
-- Table structure for inspect_alert_everyday
-- ----------------------------
DROP TABLE IF EXISTS `inspect_alert_everyday`;
CREATE TABLE `inspect_alert_everyday` (
  `report_time` date NOT NULL COMMENT '巡检时间',
  `resource_id` bigint NOT NULL COMMENT '资产ID',
  `alert_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警等级',
  `alert_object` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '告警对象',
  `alert_rule` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警规则',
  `alert_tips` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警提示',
  `alert_value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '告警值',
  PRIMARY KEY (`resource_id`,`report_time`,`alert_object`) USING BTREE,
  KEY `idx_alertlevel` (`alert_level`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检告警统计表';

-- ----------------------------
-- Table structure for inspect_appsystem_schedule
-- ----------------------------
DROP TABLE IF EXISTS `inspect_appsystem_schedule`;
CREATE TABLE `inspect_appsystem_schedule` (
  `id` bigint NOT NULL COMMENT 'id',
  `app_system_id` bigint NOT NULL COMMENT '应用ID',
  `cron` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron',
  `begin_time` timestamp(3) NULL DEFAULT NULL COMMENT '计划开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '计划结束时间',
  `is_active` tinyint(1) NOT NULL COMMENT '是否启用',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_app_system_id` (`app_system_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时巡检';

-- ----------------------------
-- Table structure for inspect_ci_combop
-- ----------------------------
DROP TABLE IF EXISTS `inspect_ci_combop`;
CREATE TABLE `inspect_ci_combop` (
  `ci_id` bigint NOT NULL COMMENT 'ciType',
  `combop_id` bigint DEFAULT NULL COMMENT '组合工具id',
  PRIMARY KEY (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检配置组合';

-- ----------------------------
-- Table structure for inspect_config_file_audit
-- ----------------------------
DROP TABLE IF EXISTS `inspect_config_file_audit`;
CREATE TABLE `inspect_config_file_audit` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `inspect_time` timestamp(3) NOT NULL COMMENT '巡检时间',
  `path_id` bigint NOT NULL COMMENT '配置文件路径id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_path_id` (`path_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检资源配置文件记录';

-- ----------------------------
-- Table structure for inspect_config_file_last_change_time
-- ----------------------------
DROP TABLE IF EXISTS `inspect_config_file_last_change_time`;
CREATE TABLE `inspect_config_file_last_change_time` (
  `resource_id` bigint NOT NULL COMMENT '资产id',
  `last_change_time` timestamp(3) NOT NULL COMMENT '最近变更时间',
  PRIMARY KEY (`resource_id`) USING BTREE,
  KEY `idx_last_change_time` (`last_change_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检资产最近变更时间';

-- ----------------------------
-- Table structure for inspect_config_file_path
-- ----------------------------
DROP TABLE IF EXISTS `inspect_config_file_path`;
CREATE TABLE `inspect_config_file_path` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `resource_id` bigint NOT NULL COMMENT '资源id',
  `path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路径',
  `md5` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最新配置文件MD5',
  `inspect_time` timestamp(3) NULL DEFAULT NULL COMMENT '最近修改时间',
  `file_id` bigint DEFAULT NULL COMMENT '文件id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_resource_id` (`resource_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检资源配置文件路径';

-- ----------------------------
-- Table structure for inspect_config_file_version
-- ----------------------------
DROP TABLE IF EXISTS `inspect_config_file_version`;
CREATE TABLE `inspect_config_file_version` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `md5` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'MD5',
  `inspect_time` timestamp(3) NOT NULL COMMENT '巡检时间',
  `file_id` bigint NOT NULL COMMENT '配置文件id',
  `audit_id` bigint NOT NULL COMMENT '巡检记录id',
  `path_id` bigint NOT NULL COMMENT '路径id',
  `job_id` bigint DEFAULT NULL COMMENT '作业ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_record_id` (`audit_id`) USING BTREE,
  KEY `idx_path_id` (`path_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检资源配置文件版本';

-- ----------------------------
-- Table structure for inspect_new_problem_customview
-- ----------------------------
DROP TABLE IF EXISTS `inspect_new_problem_customview`;
CREATE TABLE `inspect_new_problem_customview` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属用户',
  `condition_config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '搜索条件配置',
  `sort` int NOT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name_user` (`name`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='巡检报告个人视图';

-- ----------------------------
-- Table structure for inspect_schedule
-- ----------------------------
DROP TABLE IF EXISTS `inspect_schedule`;
CREATE TABLE `inspect_schedule` (
  `id` bigint NOT NULL COMMENT 'id',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `ci_id` bigint NOT NULL COMMENT '模型id',
  `cron` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron',
  `begin_time` timestamp(3) NULL DEFAULT NULL COMMENT '计划开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '计划结束时间',
  `is_active` tinyint(1) NOT NULL COMMENT '是否启用',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_ci_id` (`ci_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时巡检';

-- ----------------------------
-- Table structure for integration
-- ----------------------------
DROP TABLE IF EXISTS `integration`;
CREATE TABLE `integration` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'url',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器类路径',
  `method` enum('get','post') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求方式',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`uuid`) USING BTREE,
  UNIQUE KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_fcd` (`fcd`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='集成配置表';

-- ----------------------------
-- Table structure for integration_audit
-- ----------------------------
DROP TABLE IF EXISTS `integration_audit`;
CREATE TABLE `integration_audit` (
  `id` bigint NOT NULL COMMENT '记录id',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接口token',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '访问用户uuid',
  `request_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '请求方',
  `server_id` int NOT NULL COMMENT '请求处理服务器id',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `status` enum('succeed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `param_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数hash',
  `result_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '返回内容hash',
  `error_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误hash',
  `param_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参数内容文件路径',
  `result_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '结果内容文件路径',
  `error_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '错误内容文件路径',
  `headers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '请求头',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_integration_uuid` (`integration_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='integration_audit';

-- ----------------------------
-- Table structure for integration_invoke
-- ----------------------------
DROP TABLE IF EXISTS `integration_invoke`;
CREATE TABLE `integration_invoke` (
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '集成配置uuid',
  `invoke_config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  `invoke_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  PRIMARY KEY (`integration_uuid`,`invoke_hash`) USING BTREE,
  KEY `idx_invoke_hash` (`invoke_hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='集成配置接口调用表';

-- ----------------------------
-- Table structure for knowledge_circle
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_circle`;
CREATE TABLE `knowledge_circle` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识圈表';

-- ----------------------------
-- Table structure for knowledge_circle_user
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_circle_user`;
CREATE TABLE `knowledge_circle_user` (
  `knowledge_circle_id` bigint NOT NULL COMMENT '知识圈ID',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户/角色/分组UUID',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `auth_type` enum('approver','member') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区分审批人与成员字段（approver：审批人；member：成员）',
  PRIMARY KEY (`knowledge_circle_id`,`uuid`,`type`,`auth_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识圈用户表';

-- ----------------------------
-- Table structure for knowledge_document
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document`;
CREATE TABLE `knowledge_document` (
  `id` bigint NOT NULL COMMENT '文档主键id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `knowledge_document_version_id` bigint DEFAULT NULL COMMENT '激活版本id',
  `knowledge_document_type_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类id',
  `knowledge_circle_id` bigint DEFAULT NULL COMMENT '知识圈id',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否删除',
  `version` int DEFAULT NULL COMMENT '激活版本号',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文档来源',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `source_idx` (`source`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档';

-- ----------------------------
-- Table structure for knowledge_document_audit
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_audit`;
CREATE TABLE `knowledge_document_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `knowledge_document_id` bigint DEFAULT NULL COMMENT '知识id',
  `knowledge_document_version_id` bigint DEFAULT NULL COMMENT '知识版本id',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `operate` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置hash',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_document` (`knowledge_document_id`,`knowledge_document_version_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识库操作记录表';

-- ----------------------------
-- Table structure for knowledge_document_audit_detail
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_audit_detail`;
CREATE TABLE `knowledge_document_audit_detail` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '记录hash',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '记录详细',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识库操作记录详情表';

-- ----------------------------
-- Table structure for knowledge_document_collect
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_collect`;
CREATE TABLE `knowledge_document_collect` (
  `knowledge_document_id` bigint NOT NULL COMMENT '文档主键',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户UUID',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '收藏时间',
  PRIMARY KEY (`knowledge_document_id`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档收集';

-- ----------------------------
-- Table structure for knowledge_document_favor
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_favor`;
CREATE TABLE `knowledge_document_favor` (
  `knowledge_document_id` bigint NOT NULL COMMENT '文档主键',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户UUID',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '点赞时间',
  PRIMARY KEY (`knowledge_document_id`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档收藏';

-- ----------------------------
-- Table structure for knowledge_document_file
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_file`;
CREATE TABLE `knowledge_document_file` (
  `knowledge_document_id` bigint NOT NULL COMMENT '文档id',
  `knowledge_document_version_id` bigint NOT NULL COMMENT '文档版本id',
  `file_id` bigint NOT NULL COMMENT '附件id',
  PRIMARY KEY (`knowledge_document_id`,`knowledge_document_version_id`,`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档附件';

-- ----------------------------
-- Table structure for knowledge_document_invoke
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_invoke`;
CREATE TABLE `knowledge_document_invoke` (
  `knowledge_document_id` bigint NOT NULL COMMENT '知识文档id',
  `invoke_id` bigint NOT NULL COMMENT '调用者id',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源',
  PRIMARY KEY (`knowledge_document_id`) USING BTREE,
  UNIQUE KEY `idx_invoke_id` (`invoke_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档调用';

-- ----------------------------
-- Table structure for knowledge_document_line
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_line`;
CREATE TABLE `knowledge_document_line` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '行uuid',
  `handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '行组件',
  `knowledge_document_id` bigint DEFAULT NULL COMMENT '文档id',
  `knowledge_document_version_id` bigint DEFAULT NULL COMMENT '文档版本id',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容hash',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置hash',
  `line_number` int DEFAULT NULL COMMENT '行号',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_document_id` (`knowledge_document_id`) USING BTREE,
  KEY `idx_document_version_id` (`knowledge_document_version_id`) USING BTREE,
  KEY `idx_document_linenum` (`line_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档行';

-- ----------------------------
-- Table structure for knowledge_document_line_config
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_line_config`;
CREATE TABLE `knowledge_document_line_config` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档行配置';

-- ----------------------------
-- Table structure for knowledge_document_line_content
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_line_content`;
CREATE TABLE `knowledge_document_line_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash值',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '文本内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档行内容';

-- ----------------------------
-- Table structure for knowledge_document_tag
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_tag`;
CREATE TABLE `knowledge_document_tag` (
  `knowledge_document_id` bigint NOT NULL COMMENT '文档id',
  `knowledge_document_version_id` bigint NOT NULL COMMENT '文档版本id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`knowledge_document_id`,`knowledge_document_version_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识文档标签';

-- ----------------------------
-- Table structure for knowledge_document_type
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_type`;
CREATE TABLE `knowledge_document_type` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `knowledge_circle_id` bigint NOT NULL COMMENT '知识圈ID',
  `parent_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '父类型ID',
  `lft` int DEFAULT NULL COMMENT '左编码',
  `rht` int DEFAULT NULL COMMENT '右编码',
  `sort` int DEFAULT NULL COMMENT '排序（相对于同级节点的顺序）',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识类型表';

-- ----------------------------
-- Table structure for knowledge_document_version
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_version`;
CREATE TABLE `knowledge_document_version` (
  `id` bigint NOT NULL COMMENT '文档版本主键id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `knowledge_document_type_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '文档类型uuid',
  `knowledge_document_id` bigint DEFAULT NULL COMMENT '文档id',
  `from_version` int DEFAULT NULL COMMENT '原版本号',
  `version` int DEFAULT NULL COMMENT '版本号',
  `status` enum('draft','submitted','rejected','passed','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态，(草稿、提交审核、审核通过)',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `size` int DEFAULT NULL COMMENT '文档大小，单位字节byte',
  `reviewer` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审批人',
  `review_time` timestamp(3) NULL DEFAULT NULL COMMENT '审批时间',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否已删除',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_knowledge_document_id` (`knowledge_document_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识库版本表';

-- ----------------------------
-- Table structure for knowledge_document_view_count
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_document_view_count`;
CREATE TABLE `knowledge_document_view_count` (
  `knowledge_document_id` bigint NOT NULL COMMENT '文档主键',
  `count` int DEFAULT NULL COMMENT '浏览量',
  PRIMARY KEY (`knowledge_document_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识查看次数';

-- ----------------------------
-- Table structure for knowledge_tag
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_tag`;
CREATE TABLE `knowledge_tag` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name_unique` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识库标签表';

-- ----------------------------
-- Table structure for knowledge_template
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_template`;
CREATE TABLE `knowledge_template` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模版名称',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目录',
  `is_active` tinyint NOT NULL COMMENT '是否激活',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人ID',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_lcd` (`lcd`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='知识库模版';

-- ----------------------------
-- Table structure for lock
-- ----------------------------
DROP TABLE IF EXISTS `lock`;
CREATE TABLE `lock` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='专门用来放锁的表';

-- ----------------------------
-- Table structure for login_captcha
-- ----------------------------
DROP TABLE IF EXISTS `login_captcha`;
CREATE TABLE `login_captcha` (
  `session_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录session_id',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '验证码',
  `expired_time` timestamp NULL DEFAULT NULL COMMENT '超时时间点',
  PRIMARY KEY (`session_id`) USING BTREE,
  KEY `idx_expired_time` (`expired_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='登录验证码表';

-- ----------------------------
-- Table structure for login_failed_count
-- ----------------------------
DROP TABLE IF EXISTS `login_failed_count`;
CREATE TABLE `login_failed_count` (
  `user_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `failed_count` int DEFAULT NULL COMMENT '错误次数',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='登录失败次数';

-- ----------------------------
-- Table structure for mail_server
-- ----------------------------
DROP TABLE IF EXISTS `mail_server`;
CREATE TABLE `mail_server` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `host` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'host',
  `port` int NOT NULL COMMENT '端口',
  `from_address` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱地址',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `domain` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '域名',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='邮件服务器表';

-- ----------------------------
-- Table structure for matrix
-- ----------------------------
DROP TABLE IF EXISTS `matrix`;
CREATE TABLE `matrix` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一表示id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '矩阵名称',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'custom,自定义 external外部数据',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `label` (`label`) USING BTREE,
  UNIQUE KEY `uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=472 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='矩阵信息表';

-- ----------------------------
-- Table structure for matrix_attribute
-- ----------------------------
DROP TABLE IF EXISTS `matrix_attribute`;
CREATE TABLE `matrix_attribute` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性uuid',
  `matrix_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '矩阵uuid',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性类型',
  `is_required` tinyint(1) DEFAULT NULL COMMENT '属性是否必填',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性名称',
  `sort` int DEFAULT NULL COMMENT '排序',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '属性配置',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `matrix_attribute_key` (`matrix_uuid`,`uuid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1081 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='矩阵自定义属性表';

-- ----------------------------
-- Table structure for matrix_ci
-- ----------------------------
DROP TABLE IF EXISTS `matrix_ci`;
CREATE TABLE `matrix_ci` (
  `matrix_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '矩阵uuid',
  `ci_id` bigint NOT NULL COMMENT 'ci模型id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置信息',
  PRIMARY KEY (`matrix_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='cmdb模型矩阵';

-- ----------------------------
-- Table structure for matrix_external
-- ----------------------------
DROP TABLE IF EXISTS `matrix_external`;
CREATE TABLE `matrix_external` (
  `matrix_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '矩阵uuid',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '插件类型',
  PRIMARY KEY (`matrix_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='矩阵外部数据源配置信息表';

-- ----------------------------
-- Table structure for matrix_view
-- ----------------------------
DROP TABLE IF EXISTS `matrix_view`;
CREATE TABLE `matrix_view` (
  `matrix_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '矩阵uuid',
  `file_id` bigint DEFAULT NULL COMMENT '配置文件',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'config',
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '上传配置文件名称',
  `xml` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '上传配置文件内容',
  PRIMARY KEY (`matrix_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='矩阵视图表';

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父节点id',
  `url` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单url',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目录对应的图标class',
  `sort` int DEFAULT '0' COMMENT '顺序(正序,数字小的靠前',
  `is_active` int DEFAULT '0' COMMENT '0:正常，1:禁用',
  `module` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模块名',
  `description` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单描述',
  `is_auto` tinyint(1) DEFAULT '0' COMMENT '是否自动打开，0:否，1:是',
  `open_mode` enum('tab','blank') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '打开页面方式，tab:打开新tab页面   blank:打开新标签页',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单表';

-- ----------------------------
-- Table structure for menu_mobile
-- ----------------------------
DROP TABLE IF EXISTS `menu_mobile`;
CREATE TABLE `menu_mobile` (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单标识',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '菜单名',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '其他配置',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='移动菜单';

-- ----------------------------
-- Table structure for menu_role
-- ----------------------------
DROP TABLE IF EXISTS `menu_role`;
CREATE TABLE `menu_role` (
  `menu_id` bigint NOT NULL COMMENT '菜单Id',
  `role_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色uuid(引用role的uuid)',
  PRIMARY KEY (`menu_id`,`role_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单角色表';

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` bigint NOT NULL COMMENT '主键id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '发送时间',
  `handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '消息类型处理器全类名',
  `insert_time` timestamp(3) NULL DEFAULT NULL COMMENT '插入时间',
  `trigger` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active' COMMENT '触发点',
  `notify_policy_handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通知策略处理器全类名',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_insert_time` (`insert_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='消息详情表';

-- ----------------------------
-- Table structure for message_recipient
-- ----------------------------
DROP TABLE IF EXISTS `message_recipient`;
CREATE TABLE `message_recipient` (
  `message_id` bigint NOT NULL COMMENT '消息id',
  `type` enum('user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接收者类型，用户、组、角色',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接收者标识',
  PRIMARY KEY (`uuid`,`message_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='消息接收者表';

-- ----------------------------
-- Table structure for message_subscribe
-- ----------------------------
DROP TABLE IF EXISTS `message_subscribe`;
CREATE TABLE `message_subscribe` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订阅用户uuid',
  `handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息类型处理器全类名',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否订阅',
  `pop_up` enum('shortshow','longshow','close') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '弹框方式，shortshow：临时，longshow：持续，close：不弹框',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '订阅时间',
  PRIMARY KEY (`user_uuid`,`handler`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='消息订阅表';

-- ----------------------------
-- Table structure for message_user
-- ----------------------------
DROP TABLE IF EXISTS `message_user`;
CREATE TABLE `message_user` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `message_id` bigint NOT NULL COMMENT '消息id',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '1：已读，0：未读',
  `is_show` tinyint(1) DEFAULT '0' COMMENT '0：未弹窗，1：已弹窗，2：弹窗关闭',
  `expired_time` timestamp(3) NULL DEFAULT NULL COMMENT '失效时间',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`user_uuid`,`message_id`) USING BTREE,
  KEY `idx_news_message_id` (`message_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户消息状态表';

-- ----------------------------
-- Table structure for mq_subscribe
-- ----------------------------
DROP TABLE IF EXISTS `mq_subscribe`;
CREATE TABLE `mq_subscribe` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '唯一标识',
  `topic_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主题唯一标识',
  `class_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理类名',
  `is_durable` tinyint(1) DEFAULT NULL COMMENT '是否持久订阅',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `status` enum('running','error','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '是否禁用',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `server_id` int DEFAULT NULL COMMENT '服务器id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_classname` (`class_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='mq订阅表';

-- ----------------------------
-- Table structure for mq_topic
-- ----------------------------
DROP TABLE IF EXISTS `mq_topic`;
CREATE TABLE `mq_topic` (
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='mq主题表';

-- ----------------------------
-- Table structure for notify_job
-- ----------------------------
DROP TABLE IF EXISTS `notify_job`;
CREATE TABLE `notify_job` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '任务名称',
  `cron` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '插件',
  `notify_handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知方式插件',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  `is_active` tinyint NOT NULL COMMENT '1：启用；0：禁用',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知定时任务表';

-- ----------------------------
-- Table structure for notify_job_receiver
-- ----------------------------
DROP TABLE IF EXISTS `notify_job_receiver`;
CREATE TABLE `notify_job_receiver` (
  `notify_job_id` bigint NOT NULL COMMENT '通知定时任务ID',
  `receiver` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接收者、组、角色uuid或者邮箱',
  `type` enum('common','user','team','role','processUserType','email') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'receiver类型，区分是用户、组、角色的uuid还是邮箱',
  `receive_type` enum('to','cc') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接收者类型，to:收件人;cc:抄送人',
  PRIMARY KEY (`notify_job_id`,`receiver`,`type`,`receive_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知定时任务接收者表';

-- ----------------------------
-- Table structure for notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `notify_policy`;
CREATE TABLE `notify_policy` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '不同类型策略处理器',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否是默认通知策略',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'json格式配置信息',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='通知策略信息表';

-- ----------------------------
-- Table structure for pbc_branch_item
-- ----------------------------
DROP TABLE IF EXISTS `pbc_branch_item`;
CREATE TABLE `pbc_branch_item` (
  `branch_id` bigint NOT NULL COMMENT '批次ID',
  `item_id` bigint NOT NULL COMMENT '数据ID',
  PRIMARY KEY (`branch_id`,`item_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送批次关联报送数据表';

-- ----------------------------
-- Table structure for pbc_category
-- ----------------------------
DROP TABLE IF EXISTS `pbc_category`;
CREATE TABLE `pbc_category` (
  `id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '一级分类标识符（两位）、二级分类标识符（两位）、三级分类标识符（三位）和四级分类标识符（三位）',
  `interface_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据元名称',
  `interface_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据元传输标识',
  `id_1` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一级分类标识符',
  `name_1` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '一级分类',
  `id_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '二级分类标识符',
  `name_2` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '二级分类',
  `id_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三级分类标识符',
  `name_3` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '三级分类',
  `id_4` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '四级分类标识符',
  `name_4` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '四级分类',
  `is_match` tinyint(1) DEFAULT NULL COMMENT '报送是否符合要求',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_full_category` (`name_1`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送分类标识符表';

-- ----------------------------
-- Table structure for pbc_corporation
-- ----------------------------
DROP TABLE IF EXISTS `pbc_corporation`;
CREATE TABLE `pbc_corporation` (
  `id` bigint NOT NULL COMMENT '主键',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送公司表';

-- ----------------------------
-- Table structure for pbc_enum
-- ----------------------------
DROP TABLE IF EXISTS `pbc_enum`;
CREATE TABLE `pbc_enum` (
  `property_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '人行属性ID',
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '枚举属性显示',
  `value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '枚举属性值',
  PRIMARY KEY (`property_id`,`value`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送属性枚举表';

-- ----------------------------
-- Table structure for pbc_interface
-- ----------------------------
DROP TABLE IF EXISTS `pbc_interface`;
CREATE TABLE `pbc_interface` (
  `uid` int NOT NULL COMMENT '数字id',
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '人行提供的id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `customview_id` bigint DEFAULT NULL COMMENT '自定义视图id',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `status` enum('','validating','reporting','mapping') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `user_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '同步用户',
  `action_time` timestamp(3) NULL DEFAULT NULL COMMENT '同步时间',
  `error` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '错误信息',
  `priority` enum('view','ci') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ci' COMMENT '同步数据优先级',
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE KEY `uk_id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送模型表';

-- ----------------------------
-- Table structure for pbc_interface_corporation
-- ----------------------------
DROP TABLE IF EXISTS `pbc_interface_corporation`;
CREATE TABLE `pbc_interface_corporation` (
  `interface_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接口id',
  `rule` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '规则',
  `corporation_id` bigint NOT NULL COMMENT '机构id',
  PRIMARY KEY (`interface_id`,`corporation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送接口公司关联表';

-- ----------------------------
-- Table structure for pbc_interface_item
-- ----------------------------
DROP TABLE IF EXISTS `pbc_interface_item`;
CREATE TABLE `pbc_interface_item` (
  `id` bigint NOT NULL COMMENT '雪花id',
  `interface_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '接口id',
  `cientity_id` bigint DEFAULT NULL COMMENT '配置项id',
  `ci_id` bigint DEFAULT NULL COMMENT '模型id',
  `customview_id` bigint DEFAULT NULL COMMENT '自定义视图id',
  `primary_key` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '如果数据来自其他来源，使用此字段作为唯一标识',
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '数据',
  `data_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容哈希，用于检查是否有变化',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '校验异常',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '添加日期',
  `fcu` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '添加人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '更新日期',
  `lcu` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人',
  `is_new` tinyint(1) DEFAULT NULL COMMENT '是否新数据',
  `is_imported` tinyint(1) DEFAULT NULL COMMENT '是否已经上报过',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '是否删除',
  `corporation_id` bigint DEFAULT NULL COMMENT '机构id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_cientity_id` (`cientity_id`) USING BTREE,
  KEY `idx_primary_key` (`primary_key`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送模型数据表';

-- ----------------------------
-- Table structure for pbc_policy
-- ----------------------------
DROP TABLE IF EXISTS `pbc_policy`;
CREATE TABLE `pbc_policy` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '说明',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `cron_expression` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '定时策略',
  `last_exec_date` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次执行时间',
  `input_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发起方式',
  `phase` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '范例:sync,collect',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'json格式，额外配置',
  `corporation_id` bigint NOT NULL COMMENT '机构id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送策略表';

-- ----------------------------
-- Table structure for pbc_policy_audit
-- ----------------------------
DROP TABLE IF EXISTS `pbc_policy_audit`;
CREATE TABLE `pbc_policy_audit` (
  `id` bigint NOT NULL COMMENT '主键',
  `policy_id` bigint DEFAULT NULL COMMENT '策略id',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `status` enum('running','failed','success','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `user_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发起用户',
  `server_id` int DEFAULT NULL COMMENT '机器id',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `input_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '发起方式',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_policy_id` (`policy_id`) USING BTREE,
  KEY `idx_end_time` (`end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送策略执行记录表';

-- ----------------------------
-- Table structure for pbc_policy_audit_interfaceitem
-- ----------------------------
DROP TABLE IF EXISTS `pbc_policy_audit_interfaceitem`;
CREATE TABLE `pbc_policy_audit_interfaceitem` (
  `audit_id` bigint NOT NULL COMMENT '策略执行记录ID',
  `interfaceitem_id` bigint NOT NULL COMMENT '模型数据ID',
  `action` enum('new','update','delete') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '动作',
  PRIMARY KEY (`audit_id`,`interfaceitem_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送策略执行记录关联报送数据表';

-- ----------------------------
-- Table structure for pbc_policy_interface
-- ----------------------------
DROP TABLE IF EXISTS `pbc_policy_interface`;
CREATE TABLE `pbc_policy_interface` (
  `policy_id` bigint NOT NULL COMMENT '策略id',
  `interface_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接口id',
  PRIMARY KEY (`policy_id`,`interface_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送策略关联模型表';

-- ----------------------------
-- Table structure for pbc_policy_phase
-- ----------------------------
DROP TABLE IF EXISTS `pbc_policy_phase`;
CREATE TABLE `pbc_policy_phase` (
  `id` bigint NOT NULL COMMENT '自增id',
  `audit_id` bigint DEFAULT NULL COMMENT '记录ID',
  `phase` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '阶段',
  `status` enum('running','success','failed','aborted','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '处理结果',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `sort` tinyint DEFAULT NULL COMMENT '排序',
  `exec_count` int DEFAULT NULL COMMENT '执行次数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk` (`audit_id`,`phase`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送策略执行阶段表';

-- ----------------------------
-- Table structure for pbc_property
-- ----------------------------
DROP TABLE IF EXISTS `pbc_property`;
CREATE TABLE `pbc_property` (
  `uid` int NOT NULL COMMENT 'global id',
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性标识',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性名称',
  `complex_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复合属性标识',
  `complex_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复合属性名称',
  `alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '别名',
  `interface_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接口id',
  `data_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '数据类型',
  `value_range` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '值域',
  `restraint` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '约束条件',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注',
  `definition` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '定义',
  `is_key` tinyint(1) DEFAULT NULL COMMENT '是否接口属性，一个接口只有一个',
  `example` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '示例',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE KEY `uk_id` (`id`,`complex_id`,`interface_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送模型属性表';

-- ----------------------------
-- Table structure for pbc_property_mapping
-- ----------------------------
DROP TABLE IF EXISTS `pbc_property_mapping`;
CREATE TABLE `pbc_property_mapping` (
  `property_uid` bigint NOT NULL COMMENT 'pbc_property表的主键',
  `interface_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模型ID',
  `complex_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '复合属性ID',
  `property_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性ID',
  `mapping` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '映射配置',
  `transfer_rule` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '转换规则',
  `default_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '默认值',
  PRIMARY KEY (`property_uid`) USING BTREE,
  KEY `idx_interface_id` (`interface_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送属性映射表';

-- ----------------------------
-- Table structure for pbc_property_rel
-- ----------------------------
DROP TABLE IF EXISTS `pbc_property_rel`;
CREATE TABLE `pbc_property_rel` (
  `id` bigint NOT NULL COMMENT '自增id',
  `from_property_uid` bigint DEFAULT NULL COMMENT '上游属性uid',
  `to_interface_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关联接口id',
  `to_value_property_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '值属性uid',
  `to_text_property_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示文本uid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk` (`from_property_uid`,`to_interface_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='监管报送属性关联表';

-- ----------------------------
-- Table structure for priority
-- ----------------------------
DROP TABLE IF EXISTS `priority`;
CREATE TABLE `priority` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否激活，1:激活,0:禁用',
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '图标',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='优先级信息表';

-- ----------------------------
-- Table structure for process
-- ----------------------------
DROP TABLE IF EXISTS `process`;
CREATE TABLE `process` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint DEFAULT NULL COMMENT '是否激活',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '流程图配置',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改用户',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程信息表';

-- ----------------------------
-- Table structure for process_comment_template
-- ----------------------------
DROP TABLE IF EXISTS `process_comment_template`;
CREATE TABLE `process_comment_template` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '回复内容',
  `type` enum('system','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'system:系统模版;custom:自定义模版',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统回复模版表';

-- ----------------------------
-- Table structure for process_comment_template_authority
-- ----------------------------
DROP TABLE IF EXISTS `process_comment_template_authority`;
CREATE TABLE `process_comment_template_authority` (
  `comment_template_id` bigint NOT NULL COMMENT '回复模版ID',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权对象类型',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权对象UUID',
  PRIMARY KEY (`comment_template_id`,`type`,`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统回复模版授权表';

-- ----------------------------
-- Table structure for process_comment_template_usecount
-- ----------------------------
DROP TABLE IF EXISTS `process_comment_template_usecount`;
CREATE TABLE `process_comment_template_usecount` (
  `comment_template_id` bigint NOT NULL COMMENT '回复模版ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `count` int DEFAULT NULL COMMENT '使用次数',
  PRIMARY KEY (`comment_template_id`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='回复模版使用次数表';

-- ----------------------------
-- Table structure for process_draft
-- ----------------------------
DROP TABLE IF EXISTS `process_draft`;
CREATE TABLE `process_draft` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `process_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '流程图配置',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建用户',
  `md5` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'md5',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程草稿信息表';

-- ----------------------------
-- Table structure for process_form
-- ----------------------------
DROP TABLE IF EXISTS `process_form`;
CREATE TABLE `process_form` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `form_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '关联的表单uuid',
  PRIMARY KEY (`process_uuid`,`form_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程表单';

-- ----------------------------
-- Table structure for process_integration
-- ----------------------------
DROP TABLE IF EXISTS `process_integration`;
CREATE TABLE `process_integration` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '集成uuid',
  PRIMARY KEY (`process_uuid`,`integration_uuid`) USING BTREE,
  KEY `idx_integration_uuid` (`integration_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程设置引用集成表';

-- ----------------------------
-- Table structure for process_notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `process_notify_policy`;
CREATE TABLE `process_notify_policy` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `notify_policy_id` bigint NOT NULL COMMENT '通知策略id',
  PRIMARY KEY (`process_uuid`) USING BTREE,
  KEY `idx_notify_policy_id` (`notify_policy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程设置引用通知策略表';

-- ----------------------------
-- Table structure for process_score_template
-- ----------------------------
DROP TABLE IF EXISTS `process_score_template`;
CREATE TABLE `process_score_template` (
  `score_template_id` bigint NOT NULL COMMENT '评分模版ID',
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程UUID',
  `is_active` tinyint DEFAULT NULL COMMENT '是否启用评分（0：否，1：是）',
  `is_auto` tinyint(1) DEFAULT NULL COMMENT '是否自动评分',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '评分设置',
  PRIMARY KEY (`score_template_id`,`process_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='评分模版-流程关联表';

-- ----------------------------
-- Table structure for process_sla
-- ----------------------------
DROP TABLE IF EXISTS `process_sla`;
CREATE TABLE `process_sla` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置规则,json格式',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程时效表';

-- ----------------------------
-- Table structure for process_sla_notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `process_sla_notify_policy`;
CREATE TABLE `process_sla_notify_policy` (
  `sla_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '时效uuid',
  `notify_policy_id` bigint NOT NULL COMMENT '通知策略id',
  PRIMARY KEY (`sla_uuid`,`notify_policy_id`) USING BTREE,
  KEY `idx_notify_policy_id` (`notify_policy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程时效引用通知策略表';

-- ----------------------------
-- Table structure for process_step
-- ----------------------------
DROP TABLE IF EXISTS `process_step`;
CREATE TABLE `process_step` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `type` enum('start','end','process','converge','auto','timer') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理器',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '额外配置,json格式',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_process_step` (`process_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤信息表';

-- ----------------------------
-- Table structure for process_step_comment_template
-- ----------------------------
DROP TABLE IF EXISTS `process_step_comment_template`;
CREATE TABLE `process_step_comment_template` (
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程步骤uuid',
  `comment_template_id` bigint NOT NULL COMMENT '回复模版ID',
  PRIMARY KEY (`process_step_uuid`,`comment_template_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤-回复模版关联表';

-- ----------------------------
-- Table structure for process_step_formattribute
-- ----------------------------
DROP TABLE IF EXISTS `process_step_formattribute`;
CREATE TABLE `process_step_formattribute` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤uuid',
  `form_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表单uuid',
  `attribute_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性uuid',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权类型',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`process_uuid`,`process_step_uuid`,`form_uuid`,`attribute_uuid`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤表单组件授权表';

-- ----------------------------
-- Table structure for process_step_handler
-- ----------------------------
DROP TABLE IF EXISTS `process_step_handler`;
CREATE TABLE `process_step_handler` (
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '节点组件',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '组件配置信息',
  PRIMARY KEY (`handler`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程组件全局配置信息表';

-- ----------------------------
-- Table structure for process_step_handler_integration
-- ----------------------------
DROP TABLE IF EXISTS `process_step_handler_integration`;
CREATE TABLE `process_step_handler_integration` (
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '节点组件类型',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '集成uuid',
  PRIMARY KEY (`handler`,`integration_uuid`) USING BTREE,
  KEY `idx_integration_uuid` (`integration_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程组件引用集成表';

-- ----------------------------
-- Table structure for process_step_handler_notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `process_step_handler_notify_policy`;
CREATE TABLE `process_step_handler_notify_policy` (
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '节点组件类型',
  `notify_policy_id` bigint NOT NULL COMMENT '通知策略id',
  PRIMARY KEY (`handler`) USING BTREE,
  KEY `idx_notify_policy_id` (`notify_policy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程组件引用通知策略表';

-- ----------------------------
-- Table structure for process_step_integration
-- ----------------------------
DROP TABLE IF EXISTS `process_step_integration`;
CREATE TABLE `process_step_integration` (
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤uuid',
  `integration_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '集成配置uuid',
  PRIMARY KEY (`process_step_uuid`,`integration_uuid`) USING BTREE,
  KEY `idx_integration_uuid` (`integration_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤引用集成表';

-- ----------------------------
-- Table structure for process_step_notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `process_step_notify_policy`;
CREATE TABLE `process_step_notify_policy` (
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程步骤uuid',
  `notify_policy_id` bigint NOT NULL COMMENT '通知策略id',
  PRIMARY KEY (`process_step_uuid`) USING BTREE,
  KEY `idx_notify_policy_id` (`notify_policy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤引用通知策略表';

-- ----------------------------
-- Table structure for process_step_rel
-- ----------------------------
DROP TABLE IF EXISTS `process_step_rel`;
CREATE TABLE `process_step_rel` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id',
  `from_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '源步骤uuid',
  `to_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标步骤uuid',
  `condition` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '条件',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` enum('forward','backward') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_process_uuid` (`process_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤之间连线表';

-- ----------------------------
-- Table structure for process_step_sla
-- ----------------------------
DROP TABLE IF EXISTS `process_step_sla`;
CREATE TABLE `process_step_sla` (
  `sla_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'sla uuid',
  `step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤uuid',
  PRIMARY KEY (`sla_uuid`,`step_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤时效表';

-- ----------------------------
-- Table structure for process_step_tag
-- ----------------------------
DROP TABLE IF EXISTS `process_step_tag`;
CREATE TABLE `process_step_tag` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '流程uuid',
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤uuid',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`process_step_uuid`,`tag_id`) USING BTREE,
  KEY `idx_process_uuid` (`process_uuid`) USING BTREE,
  KEY `idx_tag_id` (`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤打标签表';

-- ----------------------------
-- Table structure for process_step_task_config
-- ----------------------------
DROP TABLE IF EXISTS `process_step_task_config`;
CREATE TABLE `process_step_task_config` (
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程步骤uuid',
  `task_config_id` bigint NOT NULL COMMENT '任务id',
  PRIMARY KEY (`process_step_uuid`,`task_config_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤子任务表';

-- ----------------------------
-- Table structure for process_step_worker_dispatcher
-- ----------------------------
DROP TABLE IF EXISTS `process_step_worker_dispatcher`;
CREATE TABLE `process_step_worker_dispatcher` (
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器',
  `config` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `help` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '帮助',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤分派器表';

-- ----------------------------
-- Table structure for process_step_worker_policy
-- ----------------------------
DROP TABLE IF EXISTS `process_step_worker_policy`;
CREATE TABLE `process_step_worker_policy` (
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '流程uuid',
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤uuid',
  `policy` enum('manual','automatic','assign','copy','fromer','form','attribute','prestepassign') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '策略',
  `sort` int DEFAULT NULL COMMENT '排序',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '策略配置，一段json',
  PRIMARY KEY (`process_step_uuid`,`policy`) USING BTREE,
  KEY `idx_process_uuid` (`process_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='流程步骤分配策略表';

-- ----------------------------
-- Table structure for process_tag
-- ----------------------------
DROP TABLE IF EXISTS `process_tag`;
CREATE TABLE `process_tag` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ITSM模块标签表';

-- ----------------------------
-- Table structure for process_workcenter
-- ----------------------------
DROP TABLE IF EXISTS `process_workcenter`;
CREATE TABLE `process_workcenter` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '分类名',
  `type` enum('factory','system','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'default:默认出厂  system：系统分类  custom：自定义分类',
  `sort` int NOT NULL AUTO_INCREMENT COMMENT '分类排序，越小越靠前',
  `condition_config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '分类条件配置',
  `support` enum('all','mobile','pc') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'all' COMMENT '使用显示范围',
  `catalog_id` bigint DEFAULT NULL COMMENT '菜单id',
  `is_show_total` tinyint(1) DEFAULT NULL COMMENT '是否显示总数,默认显示待办数',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_sort` (`sort`) USING BTREE,
  KEY `idx_support` (`support`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=301 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单中心分类表';

-- ----------------------------
-- Table structure for process_workcenter_authority
-- ----------------------------
DROP TABLE IF EXISTS `process_workcenter_authority`;
CREATE TABLE `process_workcenter_authority` (
  `workcenter_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单分类uuid',
  `type` enum('common','user','role','team') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  PRIMARY KEY (`workcenter_uuid`,`type`,`uuid`) USING BTREE,
  KEY `index_role` (`uuid`) USING BTREE,
  KEY `index_user` (`type`,`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单中心分类授权表';

-- ----------------------------
-- Table structure for process_workcenter_catalog
-- ----------------------------
DROP TABLE IF EXISTS `process_workcenter_catalog`;
CREATE TABLE `process_workcenter_catalog` (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单类型唯一标识',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单中心菜单类型表';

-- ----------------------------
-- Table structure for process_workcenter_owner
-- ----------------------------
DROP TABLE IF EXISTS `process_workcenter_owner`;
CREATE TABLE `process_workcenter_owner` (
  `workcenter_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类唯一标识uuid',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '如果属于私人分类，分类所属人',
  PRIMARY KEY (`workcenter_uuid`) USING BTREE,
  KEY `idx_user_uuid` (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单中心分类所属人表';

-- ----------------------------
-- Table structure for process_workcenter_thead
-- ----------------------------
DROP TABLE IF EXISTS `process_workcenter_thead`;
CREATE TABLE `process_workcenter_thead` (
  `workcenter_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类唯一标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段名（表单属性则存属性uuid）',
  `sort` int NOT NULL COMMENT '字段排序',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属用户',
  `is_show` bigint NOT NULL COMMENT '字段是否展示',
  `width` int NOT NULL DEFAULT '1' COMMENT '字段宽度',
  `type` enum('common','form') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段类型，common:工单固有字段  form：表单属性',
  `disabled` tinyint DEFAULT NULL COMMENT '字段是否禁用(1：是，0：否)',
  PRIMARY KEY (`workcenter_uuid`,`name`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户自定义thead 显示排序';

-- ----------------------------
-- Table structure for process_workcenter_user_profile
-- ----------------------------
DROP TABLE IF EXISTS `process_workcenter_user_profile`;
CREATE TABLE `process_workcenter_user_profile` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '用户个性化配置，如排序等',
  PRIMARY KEY (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='process_workcenter_user_profile';

-- ----------------------------
-- Table structure for processtask
-- ----------------------------
DROP TABLE IF EXISTS `processtask`;
CREATE TABLE `processtask` (
  `id` bigint NOT NULL COMMENT '工单id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `process_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程uuid',
  `channel_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务uuid',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '流程配置md5散列值',
  `priority_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '优先级uid',
  `status` enum('pending','draft','running','aborted','succeed','failed','hang','scored') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单状态',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '上报时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '关单时间',
  `owner` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '上报人',
  `reporter` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代报人',
  `expire_time` timestamp(3) NULL DEFAULT NULL COMMENT '超时时间',
  `worktime_uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工作时间窗口uuid',
  `error` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '流程级异常',
  `is_show` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示 1：显示；0：隐藏',
  `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单序列号',
  `source` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pc' COMMENT '来源',
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT '是否已删除',
  `need_score` tinyint(1) DEFAULT NULL COMMENT '是否启用评分',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_processuuid` (`process_uuid`) USING BTREE,
  KEY `idx_channel` (`channel_uuid`) USING BTREE,
  KEY `idx_isshow` (`is_show`) USING BTREE,
  KEY `idx_owner` (`owner`) USING BTREE,
  KEY `idx_priority` (`priority_uuid`) USING BTREE,
  KEY `idx_reporter` (`reporter`) USING BTREE,
  KEY `idx_serialnum` (`serial_number`) USING BTREE,
  KEY `idx_starttime` (`start_time`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_worktime` (`worktime_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单信息表';

-- ----------------------------
-- Table structure for processtask_agent
-- ----------------------------
DROP TABLE IF EXISTS `processtask_agent`;
CREATE TABLE `processtask_agent` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `from_user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '来源用户uuid',
  `to_user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标用户uuid',
  `begin_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `is_active` tinyint(1) NOT NULL COMMENT '启用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_from_to_user_uuid` (`from_user_uuid`,`to_user_uuid`) USING BTREE,
  KEY `idx_to_user_uuid` (`to_user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单代理';

-- ----------------------------
-- Table structure for processtask_agent_target
-- ----------------------------
DROP TABLE IF EXISTS `processtask_agent_target`;
CREATE TABLE `processtask_agent_target` (
  `processtask_agent_id` bigint NOT NULL COMMENT '代办id',
  `target` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标uuid,目录或服务',
  `type` enum('catalog','channel') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标类型',
  `path_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路径',
  PRIMARY KEY (`processtask_agent_id`,`target`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单代理目标';

-- ----------------------------
-- Table structure for processtask_assignworker
-- ----------------------------
DROP TABLE IF EXISTS `processtask_assignworker`;
CREATE TABLE `processtask_assignworker` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '被指派步骤id',
  `from_processtask_step_id` bigint NOT NULL COMMENT '指派步骤id',
  `from_process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '指派步骤流程步骤uuid',
  `type` enum('user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '指派对象类型',
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '指派对象',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`processtask_id`,`processtask_step_id`,`from_processtask_step_id`,`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单指派处理人表';

-- ----------------------------
-- Table structure for processtask_auto_score
-- ----------------------------
DROP TABLE IF EXISTS `processtask_auto_score`;
CREATE TABLE `processtask_auto_score` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `trigger_time` timestamp NULL DEFAULT NULL COMMENT '自动评分时间',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单自动评分表';

-- ----------------------------
-- Table structure for processtask_config
-- ----------------------------
DROP TABLE IF EXISTS `processtask_config`;
CREATE TABLE `processtask_config` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通过process表中config生成的md5唯一标识',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '历史流程配置',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单配置信息压缩表';

-- ----------------------------
-- Table structure for processtask_content
-- ----------------------------
DROP TABLE IF EXISTS `processtask_content`;
CREATE TABLE `processtask_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单活动内容表';

-- ----------------------------
-- Table structure for processtask_converge
-- ----------------------------
DROP TABLE IF EXISTS `processtask_converge`;
CREATE TABLE `processtask_converge` (
  `converge_id` bigint NOT NULL COMMENT '汇集',
  `processtask_step_id` bigint NOT NULL COMMENT '作业步骤id',
  `processtask_id` bigint NOT NULL COMMENT '作业id',
  `is_check` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否确认',
  PRIMARY KEY (`processtask_id`,`processtask_step_id`,`converge_id`) USING BTREE,
  KEY `idx_convergeid` (`converge_id`) USING BTREE,
  KEY `idx_stepid` (`processtask_step_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤汇合表';

-- ----------------------------
-- Table structure for processtask_file
-- ----------------------------
DROP TABLE IF EXISTS `processtask_file`;
CREATE TABLE `processtask_file` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `file_id` bigint NOT NULL COMMENT '文件ID',
  `content_id` bigint NOT NULL COMMENT '内容ID',
  PRIMARY KEY (`processtask_id`,`processtask_step_id`,`file_id`,`content_id`) USING BTREE,
  KEY `idx_content_id` (`content_id`) USING BTREE,
  KEY `idx_processtask_step_id` (`processtask_step_id`) USING BTREE,
  KEY `idx_file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单文件表';

-- ----------------------------
-- Table structure for processtask_focus
-- ----------------------------
DROP TABLE IF EXISTS `processtask_focus`;
CREATE TABLE `processtask_focus` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户UUID',
  PRIMARY KEY (`processtask_id`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关注人表';

-- ----------------------------
-- Table structure for processtask_form
-- ----------------------------
DROP TABLE IF EXISTS `processtask_form`;
CREATE TABLE `processtask_form` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `form_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单绑定的表单uuid',
  `form_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工单绑定的表单名',
  `form_content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工单绑定的表单配置',
  PRIMARY KEY (`processtask_id`,`form_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关联的表单';

-- ----------------------------
-- Table structure for processtask_form_content
-- ----------------------------
DROP TABLE IF EXISTS `processtask_form_content`;
CREATE TABLE `processtask_form_content` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单表单内容表';

-- ----------------------------
-- Table structure for processtask_formattribute_data
-- ----------------------------
DROP TABLE IF EXISTS `processtask_formattribute_data`;
CREATE TABLE `processtask_formattribute_data` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '插件类型',
  `attribute_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性名',
  `attribute_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性uuid',
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '工单属性值,json格式',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`processtask_id`,`attribute_uuid`) USING BTREE,
  KEY `idx_attribute_uuid` (`attribute_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关联的属性当前值';

-- ----------------------------
-- Table structure for processtask_import_audit
-- ----------------------------
DROP TABLE IF EXISTS `processtask_import_audit`;
CREATE TABLE `processtask_import_audit` (
  `id` bigint NOT NULL COMMENT '主键',
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工单标题',
  `channel_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务UUID',
  `status` tinyint NOT NULL COMMENT '是否上报成功（是：1，否：0）',
  `error_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '上报失败原因',
  `owner` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '上报人',
  `import_time` timestamp(3) NULL DEFAULT NULL COMMENT '导入时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单批量导入审计表';

-- ----------------------------
-- Table structure for processtask_old_form_prop
-- ----------------------------
DROP TABLE IF EXISTS `processtask_old_form_prop`;
CREATE TABLE `processtask_old_form_prop` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `form` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '工单表单html',
  `prop` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '工单自定义属性json',
  PRIMARY KEY (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='processtask_old_form_prop';

-- ----------------------------
-- Table structure for processtask_operation_content
-- ----------------------------
DROP TABLE IF EXISTS `processtask_operation_content`;
CREATE TABLE `processtask_operation_content` (
  `id` bigint NOT NULL COMMENT 'id',
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'hash',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`),
  KEY `idx_contentid` (`content_hash`),
  KEY `idx_processtask_id` (`processtask_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单操作内容表';

-- ----------------------------
-- Table structure for processtask_relation
-- ----------------------------
DROP TABLE IF EXISTS `processtask_relation`;
CREATE TABLE `processtask_relation` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `channel_type_relation_id` bigint NOT NULL COMMENT '关系类型',
  `source` bigint NOT NULL COMMENT '来源工单id',
  `target` bigint NOT NULL COMMENT '目标工单id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_channel_type_relation_id` (`channel_type_relation_id`) USING BTREE,
  KEY `idx_source` (`source`) USING BTREE,
  KEY `idx_target` (`target`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单关联关系表';

-- ----------------------------
-- Table structure for processtask_repeat
-- ----------------------------
DROP TABLE IF EXISTS `processtask_repeat`;
CREATE TABLE `processtask_repeat` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `repeat_group_id` bigint NOT NULL COMMENT '重复组id',
  PRIMARY KEY (`processtask_id`) USING BTREE,
  KEY `idx_repeat_group_id` (`repeat_group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='重复工单表';

-- ----------------------------
-- Table structure for processtask_score
-- ----------------------------
DROP TABLE IF EXISTS `processtask_score`;
CREATE TABLE `processtask_score` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `score_template_id` bigint NOT NULL COMMENT '评分模版ID',
  `score_dimension_id` bigint NOT NULL COMMENT '评分维度ID',
  `score` int NOT NULL COMMENT '分数',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '评分人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '评分时间',
  `is_auto` tinyint NOT NULL COMMENT '是否自动评分（0：否，1：是）',
  PRIMARY KEY (`processtask_id`,`score_template_id`,`score_dimension_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单评分表';

-- ----------------------------
-- Table structure for processtask_score_content
-- ----------------------------
DROP TABLE IF EXISTS `processtask_score_content`;
CREATE TABLE `processtask_score_content` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评价内容hash',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评价人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '评价时间',
  PRIMARY KEY (`processtask_id`,`content_hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单评价内容表';

-- ----------------------------
-- Table structure for processtask_score_template
-- ----------------------------
DROP TABLE IF EXISTS `processtask_score_template`;
CREATE TABLE `processtask_score_template` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `score_template_id` bigint DEFAULT NULL COMMENT '评分模版ID',
  `is_auto` tinyint(1) DEFAULT NULL COMMENT '是否自动评分',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置hash',
  PRIMARY KEY (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单评分模版表';

-- ----------------------------
-- Table structure for processtask_score_template_config
-- ----------------------------
DROP TABLE IF EXISTS `processtask_score_template_config`;
CREATE TABLE `processtask_score_template_config` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容hash',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单评分模版配置表';

-- ----------------------------
-- Table structure for processtask_serial_number
-- ----------------------------
DROP TABLE IF EXISTS `processtask_serial_number`;
CREATE TABLE `processtask_serial_number` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '工单序列号',
  PRIMARY KEY (`processtask_id`,`serial_number`) USING BTREE,
  KEY `idx_serial_number` (`serial_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单号表';

-- ----------------------------
-- Table structure for processtask_serial_number_policy
-- ----------------------------
DROP TABLE IF EXISTS `processtask_serial_number_policy`;
CREATE TABLE `processtask_serial_number_policy` (
  `channel_type_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '服务类型uuid',
  `handler` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '工单号生成策略类名',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  `serial_number_seed` bigint DEFAULT NULL COMMENT 'serial_number_seed',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次更新工单号开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次更新工单号结束时间',
  PRIMARY KEY (`channel_type_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单号生成策略表';

-- ----------------------------
-- Table structure for processtask_sla
-- ----------------------------
DROP TABLE IF EXISTS `processtask_sla`;
CREATE TABLE `processtask_sla` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) NOT NULL COMMENT '是否激活',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_pt_id` (`processtask_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=375 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单sla表';

-- ----------------------------
-- Table structure for processtask_sla_notify
-- ----------------------------
DROP TABLE IF EXISTS `processtask_sla_notify`;
CREATE TABLE `processtask_sla_notify` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sla_id` bigint NOT NULL COMMENT 'sla id',
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `trigger_time` timestamp(3) NULL DEFAULT NULL COMMENT '触发时间',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_sla_id` (`sla_id`,`hash`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='sla通知表';

-- ----------------------------
-- Table structure for processtask_sla_time
-- ----------------------------
DROP TABLE IF EXISTS `processtask_sla_time`;
CREATE TABLE `processtask_sla_time` (
  `sla_id` bigint NOT NULL COMMENT 'id',
  `time_sum` bigint DEFAULT NULL COMMENT '总耗时，毫秒',
  `expire_time` timestamp(3) NULL DEFAULT NULL COMMENT '超时时间（根据工作日历计算）',
  `realexpire_time` timestamp(3) NULL DEFAULT NULL COMMENT '超时时间（直接计算）',
  `time_left` bigint DEFAULT NULL COMMENT '剩余时间，毫秒，根据工作日历计算',
  `realtime_left` bigint DEFAULT NULL COMMENT '剩余时间，毫秒，直接计算',
  `status` enum('doing','pause','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'doing' COMMENT '状态',
  `calculation_time` timestamp(3) NULL DEFAULT NULL COMMENT '上次耗时计算时间点',
  PRIMARY KEY (`sla_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='sla时间表';

-- ----------------------------
-- Table structure for processtask_sla_transfer
-- ----------------------------
DROP TABLE IF EXISTS `processtask_sla_transfer`;
CREATE TABLE `processtask_sla_transfer` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `sla_id` bigint NOT NULL COMMENT 'sla id',
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `trigger_time` timestamp(3) NULL DEFAULT NULL COMMENT '触发时间',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `sla_id_hash_idx` (`sla_id`,`hash`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤时效转交设置表';

-- ----------------------------
-- Table structure for processtask_step
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step`;
CREATE TABLE `processtask_step` (
  `id` bigint NOT NULL COMMENT 'id',
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤名称',
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '步骤uuid',
  `status` enum('pending','running','succeed','failed','back','hang','draft') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '状态',
  `result` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理结果',
  `type` enum('start','process','end','converge','timer') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '节点类型，不同类型节点有不同的流转行为',
  `handler` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理器',
  `is_active` tinyint(1) NOT NULL COMMENT '是否激活，终止：-1,未处理过：0，正在处理：1，处理完毕：2',
  `active_time` timestamp(3) NULL DEFAULT NULL COMMENT '激活时间',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `error` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '错误内容',
  `expire_time` timestamp(3) NULL DEFAULT NULL COMMENT '超时时间',
  `config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置散列值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_processtask_id_status` (`processtask_id`,`status`) USING BTREE,
  KEY `idx_processtask_id_active` (`processtask_id`,`is_active`) USING BTREE,
  KEY `idx_active_time` (`active_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤表';

-- ----------------------------
-- Table structure for processtask_step_agent
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_agent`;
CREATE TABLE `processtask_step_agent` (
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户uuid',
  `agent_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '代理人uuid',
  PRIMARY KEY (`processtask_step_id`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤代理表';

-- ----------------------------
-- Table structure for processtask_step_audit
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_audit`;
CREATE TABLE `processtask_step_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `processtask_step_id` bigint DEFAULT NULL COMMENT '步骤ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `action_time` timestamp(3) NULL DEFAULT NULL COMMENT '动作触发时间',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '动作',
  `step_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '步骤状态',
  `original_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '原始处理人',
  `description_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述hash',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE,
  KEY `idx_action` (`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤审计表';

-- ----------------------------
-- Table structure for processtask_step_audit_detail
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_audit_detail`;
CREATE TABLE `processtask_step_audit_detail` (
  `audit_id` bigint NOT NULL COMMENT 'id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型',
  `old_content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'old content',
  `new_content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'new content',
  PRIMARY KEY (`audit_id`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤活动详细表';

-- ----------------------------
-- Table structure for processtask_step_automatic_request
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_automatic_request`;
CREATE TABLE `processtask_step_automatic_request` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '请求或回调',
  `trigger_time` timestamp NULL DEFAULT NULL COMMENT '下次触发时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤自动节点请求';

-- ----------------------------
-- Table structure for processtask_step_change_create
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_change_create`;
CREATE TABLE `processtask_step_change_create` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `change_id` bigint NOT NULL COMMENT '变更id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更创建时配置信息',
  PRIMARY KEY (`change_id`) USING BTREE,
  UNIQUE KEY `idx_processtask_step_id` (`processtask_step_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤与变更创建关系表';

-- ----------------------------
-- Table structure for processtask_step_change_handle
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_change_handle`;
CREATE TABLE `processtask_step_change_handle` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `change_id` bigint NOT NULL COMMENT '变更id',
  PRIMARY KEY (`change_id`) USING BTREE,
  UNIQUE KEY `idx_processtask_step_id` (`processtask_step_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤与变更处理关系表';

-- ----------------------------
-- Table structure for processtask_step_config
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_config`;
CREATE TABLE `processtask_step_config` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单配置表';

-- ----------------------------
-- Table structure for processtask_step_content
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_content`;
CREATE TABLE `processtask_step_content` (
  `id` bigint NOT NULL COMMENT 'id',
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `processtask_step_id` bigint DEFAULT NULL COMMENT '步骤ID',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'hash',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_contentid` (`content_hash`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE,
  KEY `idx_processtaskstepid` (`processtask_step_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤内容表';

-- ----------------------------
-- Table structure for processtask_step_data
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_data`;
CREATE TABLE `processtask_step_data` (
  `id` bigint NOT NULL COMMENT '唯一标识',
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '工单步骤id',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '数据',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '功能类型',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `task_step_type_fcu_idx` (`processtask_id`,`processtask_step_id`,`type`,`fcu`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤数据表';

-- ----------------------------
-- Table structure for processtask_step_event
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_event`;
CREATE TABLE `processtask_step_event` (
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `event_id` bigint DEFAULT NULL COMMENT '事件ID',
  PRIMARY KEY (`processtask_step_id`) USING BTREE,
  UNIQUE KEY `idx_event_id` (`event_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤-事件关联表';

-- ----------------------------
-- Table structure for processtask_step_formattribute
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_formattribute`;
CREATE TABLE `processtask_step_formattribute` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '工单步骤id',
  `attribute_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '属性uuid',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '授权类型',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`processtask_id`,`processtask_step_id`,`attribute_uuid`,`action`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤可查看的表单属性';

-- ----------------------------
-- Table structure for processtask_step_in_operation
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_in_operation`;
CREATE TABLE `processtask_step_in_operation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型',
  `operation_time` timestamp(3) NULL DEFAULT NULL COMMENT '操作时间',
  `expire_time` timestamp(3) NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16568 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤正在后台执行操作记录表';

-- ----------------------------
-- Table structure for processtask_step_notify_policy
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_notify_policy`;
CREATE TABLE `processtask_step_notify_policy` (
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `policy_id` bigint NOT NULL COMMENT '通知策略ID',
  `policy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通知策略名称',
  `policy_config_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通知策略配置hash',
  `policy_handler` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '通知策略处理器',
  PRIMARY KEY (`processtask_step_id`,`policy_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤通知策略表';

-- ----------------------------
-- Table structure for processtask_step_notify_policy_config
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_notify_policy_config`;
CREATE TABLE `processtask_step_notify_policy_config` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'config',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤通知策略配置表';

-- ----------------------------
-- Table structure for processtask_step_reapproval_restore_backup
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_reapproval_restore_backup`;
CREATE TABLE `processtask_step_reapproval_restore_backup` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `backup_step_id` bigint NOT NULL COMMENT '备份步骤id',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '备份信息',
  `sort` int NOT NULL COMMENT '顺序',
  PRIMARY KEY (`backup_step_id`,`processtask_step_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤审批恢复备份';

-- ----------------------------
-- Table structure for processtask_step_rel
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_rel`;
CREATE TABLE `processtask_step_rel` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `from_process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '源步骤uuid',
  `to_process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标步骤uuid',
  `from_processtask_step_id` bigint NOT NULL COMMENT '源步骤ID',
  `to_processtask_step_id` bigint NOT NULL COMMENT '目标步骤ID',
  `condition` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '条件',
  `is_hit` tinyint(1) DEFAULT '0' COMMENT '0：没有触发流转，-1：触发了流转但条件不满足，1：触发了流转条件满足',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'uuid',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` enum('forward','backward') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`from_processtask_step_id`,`to_processtask_step_id`) USING BTREE,
  KEY `idx_to_processtask_step_uuid` (`to_processtask_step_id`) USING BTREE,
  KEY `idx_from_process_step_uuid` (`from_process_step_uuid`) USING BTREE,
  KEY `idx_to_process_step_uuid` (`to_process_step_uuid`) USING BTREE,
  KEY `idx_process_task_uuid` (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤之间的连线表';

-- ----------------------------
-- Table structure for processtask_step_remind
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_remind`;
CREATE TABLE `processtask_step_remind` (
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '动作',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容hash',
  PRIMARY KEY (`processtask_step_id`,`action`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤特殊提醒信息表';

-- ----------------------------
-- Table structure for processtask_step_sla
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_sla`;
CREATE TABLE `processtask_step_sla` (
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `sla_id` bigint NOT NULL COMMENT 'sla id',
  PRIMARY KEY (`processtask_step_id`,`sla_id`) USING BTREE,
  KEY `idx_slaid` (`sla_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤时效表';

-- ----------------------------
-- Table structure for processtask_step_sla_time
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_sla_time`;
CREATE TABLE `processtask_step_sla_time` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `sla_id` bigint NOT NULL COMMENT '时效id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型，响应、处理',
  `time_sum` bigint NOT NULL COMMENT '时效总时长',
  `time_cost` bigint NOT NULL COMMENT '耗时，毫秒，根据工作日历计算',
  `realtime_cost` bigint NOT NULL COMMENT '耗时，毫秒，直接计算',
  `is_timeout` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否超时',
  PRIMARY KEY (`processtask_step_id`,`sla_id`,`type`) USING BTREE,
  KEY `idx_sla_id` (`sla_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='步骤sla耗时表';

-- ----------------------------
-- Table structure for processtask_step_tag
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_tag`;
CREATE TABLE `processtask_step_tag` (
  `processtask_id` bigint DEFAULT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `tag_id` bigint NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`processtask_step_id`,`tag_id`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE,
  KEY `idx_tag_id` (`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤标签表';

-- ----------------------------
-- Table structure for processtask_step_task
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_task`;
CREATE TABLE `processtask_step_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `owner` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建者',
  `status` enum('succeed','aborted','pending') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `create_time` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `task_config_id` bigint NOT NULL COMMENT '任务配置id',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建内容',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_processtask_step_id` (`processtask_step_id`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=898506094346244 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='processtask_step_task';

-- ----------------------------
-- Table structure for processtask_step_task_user
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_task_user`;
CREATE TABLE `processtask_step_task_user` (
  `id` bigint NOT NULL COMMENT 'id',
  `processtask_step_task_id` bigint DEFAULT NULL COMMENT '任务id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务用户',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '任务完成时间',
  `status` char(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '完成状态',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='processtask_step_task_user';

-- ----------------------------
-- Table structure for processtask_step_task_user_agent
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_task_user_agent`;
CREATE TABLE `processtask_step_task_user_agent` (
  `processtask_step_task_user_id` bigint NOT NULL COMMENT '步骤任务用户ID',
  `processtask_step_task_id` bigint DEFAULT NULL COMMENT '步骤任务ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户uuid',
  `agent_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '代理人uuid',
  PRIMARY KEY (`processtask_step_task_user_id`) USING BTREE,
  KEY `idx_processtask_step_task_id` (`processtask_step_task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤任务代理表';

-- ----------------------------
-- Table structure for processtask_step_task_user_content
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_task_user_content`;
CREATE TABLE `processtask_step_task_user_content` (
  `id` bigint NOT NULL COMMENT 'id',
  `processtask_step_task_id` bigint DEFAULT NULL COMMENT '步骤任务id',
  `processtask_step_task_user_id` bigint DEFAULT NULL COMMENT '步骤任务用户id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户uuid',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '回复内容hash',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '回复时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改回复时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`processtask_step_task_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='processtask_step_task_user_content';

-- ----------------------------
-- Table structure for processtask_step_task_user_file
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_task_user_file`;
CREATE TABLE `processtask_step_task_user_file` (
  `processtask_step_task_id` bigint NOT NULL COMMENT '步骤任务id',
  `processtask_step_task_user_id` bigint NOT NULL COMMENT '步骤任务用户id',
  `file_id` bigint NOT NULL COMMENT '附件id',
  `fcd` timestamp NOT NULL COMMENT '上传时间',
  PRIMARY KEY (`processtask_step_task_user_id`,`file_id`) USING BTREE,
  KEY `idx_file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='processtask_step_task_user_content';

-- ----------------------------
-- Table structure for processtask_step_timeaudit
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_timeaudit`;
CREATE TABLE `processtask_step_timeaudit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `processtask_step_id` bigint DEFAULT NULL COMMENT '工单ID',
  `active_time` timestamp(3) NULL DEFAULT NULL COMMENT '激活时间',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `abort_time` timestamp(3) NULL DEFAULT NULL COMMENT '放弃时间',
  `complete_time` timestamp(3) NULL DEFAULT NULL COMMENT '包含成功或失败',
  `back_time` timestamp(3) NULL DEFAULT NULL COMMENT '回退时间',
  `pause_time` timestamp(3) NULL DEFAULT NULL COMMENT '挂起时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_processtask_step_id` (`processtask_step_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13410 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤操作时间审计表';

-- ----------------------------
-- Table structure for processtask_step_timer
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_timer`;
CREATE TABLE `processtask_step_timer` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤id',
  `trigger_time` timestamp NULL DEFAULT NULL COMMENT '触发时间',
  PRIMARY KEY (`processtask_step_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤定时';

-- ----------------------------
-- Table structure for processtask_step_user
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_user`;
CREATE TABLE `processtask_step_user` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理人uuid',
  `user_type` enum('major','minor') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'major用户必须处理',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理人名称',
  `status` enum('doing','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '动作',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `active_time` timestamp(3) NULL DEFAULT NULL COMMENT '激活时间',
  PRIMARY KEY (`processtask_step_id`,`user_uuid`,`user_type`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE,
  KEY `idx_action` (`action`) USING BTREE,
  KEY `idx_type` (`user_type`) USING BTREE,
  KEY `idx_useruuid` (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤处理人表';

-- ----------------------------
-- Table structure for processtask_step_worker
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_worker`;
CREATE TABLE `processtask_step_worker` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `type` enum('user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理人uuid',
  `user_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '处理人类型，用于区分步骤处理人，子任务处理人',
  PRIMARY KEY (`processtask_id`,`processtask_step_id`,`uuid`,`user_type`) USING BTREE,
  KEY `idx_processtask_step_id` (`processtask_step_id`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE,
  KEY `idx_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='记录当前流程谁可以处理';

-- ----------------------------
-- Table structure for processtask_step_worker_policy
-- ----------------------------
DROP TABLE IF EXISTS `processtask_step_worker_policy`;
CREATE TABLE `processtask_step_worker_policy` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `processtask_step_id` bigint NOT NULL COMMENT '步骤ID',
  `process_step_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '步骤uuid',
  `policy` enum('manual','automatic','assign','copy','fromer','form','attribute','prestepassign') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '策略',
  `sort` int DEFAULT NULL COMMENT '排序',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '策略配置，一段json',
  PRIMARY KEY (`processtask_id`,`processtask_step_id`,`policy`) USING BTREE,
  KEY `idx_processtask_id` (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单步骤分配策略表';

-- ----------------------------
-- Table structure for processtask_tag
-- ----------------------------
DROP TABLE IF EXISTS `processtask_tag`;
CREATE TABLE `processtask_tag` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `tag_id` bigint NOT NULL COMMENT '标签id',
  PRIMARY KEY (`processtask_id`,`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单打标签表';

-- ----------------------------
-- Table structure for processtask_time_cost
-- ----------------------------
DROP TABLE IF EXISTS `processtask_time_cost`;
CREATE TABLE `processtask_time_cost` (
  `processtask_id` bigint NOT NULL COMMENT '工单id',
  `time_cost` bigint NOT NULL COMMENT '耗时，毫秒，根据工作日历计算',
  `realtime_cost` bigint NOT NULL COMMENT '耗时，毫秒，直接计算',
  PRIMARY KEY (`processtask_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单耗时表';

-- ----------------------------
-- Table structure for processtask_tranfer_report
-- ----------------------------
DROP TABLE IF EXISTS `processtask_tranfer_report`;
CREATE TABLE `processtask_tranfer_report` (
  `id` bigint NOT NULL COMMENT 'id',
  `channel_type_relation_id` bigint NOT NULL COMMENT '服务类型关系id',
  `from_processtask_id` bigint NOT NULL COMMENT '源工单ID',
  `to_processtask_id` bigint NOT NULL COMMENT '目标工单ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_from_processtask_id` (`from_processtask_id`) USING BTREE,
  KEY `idx_to_processtask_id` (`to_processtask_id`) USING BTREE,
  KEY `idx_channel_type_relation_id` (`channel_type_relation_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='工单转报关系表';

-- ----------------------------
-- Table structure for processtask_urge
-- ----------------------------
DROP TABLE IF EXISTS `processtask_urge`;
CREATE TABLE `processtask_urge` (
  `processtask_id` bigint NOT NULL COMMENT '工单ID',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '催办用户',
  `lcd` timestamp(3) NOT NULL COMMENT '催办时间',
  PRIMARY KEY (`processtask_id`,`lcu`,`lcd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app`;
CREATE TABLE `rdm_app` (
  `id` bigint NOT NULL COMMENT '对象id',
  `app_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标题',
  `project_id` bigint DEFAULT NULL COMMENT '项目id',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app_attr
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app_attr`;
CREATE TABLE `rdm_app_attr` (
  `id` bigint NOT NULL COMMENT 'id',
  `app_id` bigint NOT NULL COMMENT '引用rdm_object的id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '值类型',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '英文名',
  `label` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '录入时的label名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `validator_id` bigint DEFAULT '0' COMMENT '验证器组件id，需要在代码中实现验证器',
  `is_required` tinyint NOT NULL COMMENT '是否必填',
  `sort` int NOT NULL DEFAULT '1' COMMENT '排序',
  `is_private` tinyint(1) DEFAULT NULL COMMENT '私有属性，系统出厂自带不允许删除',
  `config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '属性设置',
  `is_active` tinyint DEFAULT NULL COMMENT '是否激活',
  `show_type` enum('none','all','list','detail') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '显示方式',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`app_id`,`name`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app_catalog
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app_catalog`;
CREATE TABLE `rdm_app_catalog` (
  `id` bigint NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `app_id` bigint DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL,
  `lft` int DEFAULT NULL,
  `rht` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_app_id` (`app_id`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app_priority
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app_priority`;
CREATE TABLE `rdm_app_priority` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `app_id` bigint DEFAULT NULL COMMENT '对象id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app_status
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app_status`;
CREATE TABLE `rdm_app_status` (
  `id` bigint NOT NULL COMMENT '主键',
  `app_id` bigint DEFAULT NULL COMMENT '对象id',
  `is_start` tinyint DEFAULT '0',
  `is_end` tinyint DEFAULT '0',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '唯一标识',
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `sort` int DEFAULT NULL COMMENT '排序',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '说明',
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_obejct_id` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app_status_rel
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app_status_rel`;
CREATE TABLE `rdm_app_status_rel` (
  `id` bigint DEFAULT NULL,
  `from_status_id` bigint NOT NULL,
  `to_status_id` bigint NOT NULL,
  `app_id` bigint NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '属性设置\n',
  PRIMARY KEY (`from_status_id`,`to_status_id`) USING BTREE,
  UNIQUE KEY `uk_id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_app_usersetting
-- ----------------------------
DROP TABLE IF EXISTS `rdm_app_usersetting`;
CREATE TABLE `rdm_app_usersetting` (
  `user_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `app_id` bigint NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`user_id`,`app_id`) USING BTREE,
  KEY `idx_app_id` (`app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue`;
CREATE TABLE `rdm_issue` (
  `id` bigint NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `app_id` bigint DEFAULT NULL COMMENT '应用id',
  `create_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建者',
  `priority` bigint DEFAULT NULL COMMENT '优先级id',
  `status` bigint DEFAULT NULL COMMENT '状态id',
  `create_date` datetime(3) DEFAULT NULL COMMENT '创建日期',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '描述',
  `catalog` bigint DEFAULT NULL COMMENT '目录id',
  `parent_id` bigint DEFAULT NULL COMMENT '父issue id',
  `iteration` bigint DEFAULT NULL COMMENT '迭代',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_objectid` (`app_id`) USING BTREE,
  KEY `idx_createdate` (`create_date`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  KEY `idx_iteration` (`iteration`) USING BTREE,
  KEY `idx_catalog` (`catalog`) USING BTREE,
  KEY `idx_user_id` (`create_user`) USING BTREE,
  KEY `idx_create_date` (`create_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue_audit
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue_audit`;
CREATE TABLE `rdm_issue_audit` (
  `id` bigint NOT NULL,
  `issue_id` bigint DEFAULT NULL,
  `attr_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `attr_id` bigint DEFAULT NULL,
  `old_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `new_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `input_from` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `input_time` datetime(3) DEFAULT NULL,
  `input_user` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_issue_id` (`issue_id`) USING BTREE,
  KEY `idx_input_user` (`input_user`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue_comment
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue_comment`;
CREATE TABLE `rdm_issue_comment` (
  `id` bigint NOT NULL,
  `issue_id` bigint DEFAULT NULL COMMENT '任务id',
  `status` bigint DEFAULT NULL COMMENT '回复时所在状态',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fcd` datetime(3) DEFAULT NULL,
  `lcd` datetime(3) DEFAULT NULL,
  `parent_id` bigint DEFAULT NULL COMMENT '回复评论id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_issue_id` (`issue_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue_file
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue_file`;
CREATE TABLE `rdm_issue_file` (
  `issue_id` bigint NOT NULL,
  `file_id` bigint NOT NULL,
  PRIMARY KEY (`issue_id`,`file_id`) USING BTREE,
  KEY `idx_file_id` (`file_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue_rel
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue_rel`;
CREATE TABLE `rdm_issue_rel` (
  `from_issue_id` bigint NOT NULL,
  `to_issue_id` bigint NOT NULL,
  `from_app_id` bigint DEFAULT NULL,
  `to_app_id` bigint DEFAULT NULL,
  `rel_type` enum('extend','relative','repeat') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '关系，从属关系是extend，关联是relative，相同是repeat',
  PRIMARY KEY (`from_issue_id`,`to_issue_id`) USING BTREE,
  KEY `idx_to_issue_id` (`to_issue_id`) USING BTREE,
  KEY `idx_to_app_id` (`to_app_id`) USING BTREE,
  KEY `idx_from_app_id` (`from_app_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue_tag
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue_tag`;
CREATE TABLE `rdm_issue_tag` (
  `issue_id` bigint NOT NULL,
  `tag_id` bigint NOT NULL,
  PRIMARY KEY (`issue_id`,`tag_id`) USING BTREE,
  KEY `idx_tag_id` (`tag_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_issue_user
-- ----------------------------
DROP TABLE IF EXISTS `rdm_issue_user`;
CREATE TABLE `rdm_issue_user` (
  `issue_id` bigint NOT NULL,
  `user_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`issue_id`,`user_id`) USING BTREE,
  KEY `idx_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_priority
-- ----------------------------
DROP TABLE IF EXISTS `rdm_priority`;
CREATE TABLE `rdm_priority` (
  `id` bigint NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `color` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sort` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_project
-- ----------------------------
DROP TABLE IF EXISTS `rdm_project`;
CREATE TABLE `rdm_project` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '说明',
  `start_date` date DEFAULT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目类型',
  `color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '颜色标识',
  `template_id` bigint DEFAULT NULL COMMENT '模板',
  `fcd` timestamp(3) NULL DEFAULT NULL,
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `lcd` timestamp(3) NULL DEFAULT NULL,
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_project_status
-- ----------------------------
DROP TABLE IF EXISTS `rdm_project_status`;
CREATE TABLE `rdm_project_status` (
  `id` bigint NOT NULL,
  `project_id` bigint DEFAULT NULL,
  `is_start` tinyint(1) DEFAULT '0',
  `is_end` tinyint DEFAULT '0',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `label` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sort` int DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_project_status_rel
-- ----------------------------
DROP TABLE IF EXISTS `rdm_project_status_rel`;
CREATE TABLE `rdm_project_status_rel` (
  `id` bigint NOT NULL,
  `from_status_id` bigint NOT NULL,
  `to_status_id` bigint NOT NULL,
  `project_id` bigint NOT NULL,
  PRIMARY KEY (`from_status_id`,`to_status_id`) USING BTREE,
  UNIQUE KEY `uk_idx` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_project_template
-- ----------------------------
DROP TABLE IF EXISTS `rdm_project_template`;
CREATE TABLE `rdm_project_template` (
  `id` bigint NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '模板名称',
  `is_active` tinyint DEFAULT NULL COMMENT '是否激活',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_project_template_apptype
-- ----------------------------
DROP TABLE IF EXISTS `rdm_project_template_apptype`;
CREATE TABLE `rdm_project_template_apptype` (
  `template_id` bigint NOT NULL COMMENT '模板id',
  `app_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '应用类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`template_id`,`app_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_project_user
-- ----------------------------
DROP TABLE IF EXISTS `rdm_project_user`;
CREATE TABLE `rdm_project_user` (
  `project_id` bigint DEFAULT NULL,
  `user_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_type` enum('member','leader') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for rdm_tag
-- ----------------------------
DROP TABLE IF EXISTS `rdm_tag`;
CREATE TABLE `rdm_tag` (
  `id` bigint NOT NULL,
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_tag` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `sql` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'sql配置',
  `condition` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '条件模板',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容模板',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否激活',
  `visit_count` int DEFAULT '0' COMMENT '使用次数',
  `fcu` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcu` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表模版表';

-- ----------------------------
-- Table structure for report_auth
-- ----------------------------
DROP TABLE IF EXISTS `report_auth`;
CREATE TABLE `report_auth` (
  `report_id` bigint NOT NULL COMMENT '报表模版ID',
  `type` enum('user','role','team') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'user：用户,role：角色,team：分组',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  PRIMARY KEY (`report_id`,`type`,`auth_uuid`) USING BTREE,
  KEY `idx_uuid` (`auth_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表模版授权表';

-- ----------------------------
-- Table structure for report_blackwhitelist
-- ----------------------------
DROP TABLE IF EXISTS `report_blackwhitelist`;
CREATE TABLE `report_blackwhitelist` (
  `id` bigint NOT NULL COMMENT 'id',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '说明',
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '表名或字段名，支持*作为模糊匹配，如果是字段名且带.，代表精确管理某张表的字段',
  `item_type` enum('table','column') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '对象类型',
  `type` enum('whitelist','blacklist') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '先根据白名单开放，再根据黑名单排除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk` (`item_name`,`item_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表黑白名单表';

-- ----------------------------
-- Table structure for report_china_country
-- ----------------------------
DROP TABLE IF EXISTS `report_china_country`;
CREATE TABLE `report_china_country` (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '国家名称',
  `adcode` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区号',
  `level` enum('district') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '水平',
  `x` float DEFAULT NULL COMMENT 'x轴',
  `y` float DEFAULT NULL COMMENT 'y轴',
  PRIMARY KEY (`adcode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表国家配置';

-- ----------------------------
-- Table structure for report_param
-- ----------------------------
DROP TABLE IF EXISTS `report_param`;
CREATE TABLE `report_param` (
  `report_id` bigint NOT NULL COMMENT '报表id',
  `id` bigint DEFAULT NULL COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `type` enum('forminput','formselect','formcheckbox','formradio','formdate','formdaterange','formselects') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '类型',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签',
  `sort` int DEFAULT NULL COMMENT '排序',
  `width` int DEFAULT NULL COMMENT '宽度',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  PRIMARY KEY (`report_id`,`name`) USING BTREE,
  KEY `idx_id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表模版参数表';

-- ----------------------------
-- Table structure for report_receiver
-- ----------------------------
DROP TABLE IF EXISTS `report_receiver`;
CREATE TABLE `report_receiver` (
  `report_send_job_id` bigint NOT NULL COMMENT '报表发送计划ID',
  `receiver` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '接收人UUID或邮箱地址',
  `type` enum('to','cc') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'to：收件人；cc：抄送人',
  PRIMARY KEY (`report_send_job_id`,`receiver`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表发送接收人表';

-- ----------------------------
-- Table structure for report_send_job
-- ----------------------------
DROP TABLE IF EXISTS `report_send_job`;
CREATE TABLE `report_send_job` (
  `id` bigint NOT NULL COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `email_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '邮件标题',
  `email_content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '邮件正文',
  `cron` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'cron表达式',
  `is_active` tinyint NOT NULL COMMENT '1：启用；0：禁用',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表发送计划表';

-- ----------------------------
-- Table structure for report_send_job_relation
-- ----------------------------
DROP TABLE IF EXISTS `report_send_job_relation`;
CREATE TABLE `report_send_job_relation` (
  `report_send_job_id` bigint NOT NULL COMMENT '报表发送计划ID',
  `report_id` bigint NOT NULL COMMENT '报表ID',
  `condition` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '条件',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`report_send_job_id`,`report_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表发送计划-报表关联表';

-- ----------------------------
-- Table structure for report_statement
-- ----------------------------
DROP TABLE IF EXISTS `report_statement`;
CREATE TABLE `report_statement` (
  `id` bigint DEFAULT NULL COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '画布额外配置',
  `widget_list` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '组件列表,json数组格式',
  `width` int DEFAULT NULL COMMENT '宽度',
  `height` int DEFAULT NULL COMMENT '高度',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '首次创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '首次创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最近修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最近修改人'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表配置';

-- ----------------------------
-- Table structure for reportinstance
-- ----------------------------
DROP TABLE IF EXISTS `reportinstance`;
CREATE TABLE `reportinstance` (
  `id` bigint NOT NULL COMMENT 'id',
  `report_id` bigint DEFAULT NULL COMMENT '报表id',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '报表名称',
  `visit_count` int DEFAULT NULL COMMENT '浏览次数',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置json格式',
  `fcu` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcu` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表实例表';

-- ----------------------------
-- Table structure for reportinstance_auth
-- ----------------------------
DROP TABLE IF EXISTS `reportinstance_auth`;
CREATE TABLE `reportinstance_auth` (
  `reportinstance_id` bigint NOT NULL COMMENT '报表实例ID',
  `type` enum('user','role','team','common') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'user：用户,role：角色,team：分组',
  `auth_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  PRIMARY KEY (`reportinstance_id`,`type`,`auth_uuid`) USING BTREE,
  KEY `idx_uuid` (`auth_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表实例授权表';

-- ----------------------------
-- Table structure for reportinstance_table_column
-- ----------------------------
DROP TABLE IF EXISTS `reportinstance_table_column`;
CREATE TABLE `reportinstance_table_column` (
  `reportinstance_id` bigint NOT NULL COMMENT '报表实例ID',
  `table_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '表格ID',
  `column` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段名',
  `sort` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`reportinstance_id`,`table_id`,`column`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='报表实例中含有的表格列表';

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` bigint NOT NULL COMMENT '自增ID',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '角色描述',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色表';

-- ----------------------------
-- Table structure for role_authority
-- ----------------------------
DROP TABLE IF EXISTS `role_authority`;
CREATE TABLE `role_authority` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `role_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
  `auth_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限组',
  `auth` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_role_auth` (`role_uuid`,`auth_group`,`auth`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `idx_auth` (`auth`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1058 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色授权表';

-- ----------------------------
-- Table structure for runner
-- ----------------------------
DROP TABLE IF EXISTS `runner`;
CREATE TABLE `runner` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `host` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ip',
  `port` int NOT NULL COMMENT '端口',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'url',
  `access_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权key',
  `access_secret` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权密码',
  `auth_type` enum('basic','hmac') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '授权类型',
  `public_key` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ssh公钥',
  `private_key` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ssh私钥',
  `group_id` bigint DEFAULT NULL COMMENT '代理分组id',
  `netty_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '\r\nnettyIp',
  `netty_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'netty端口',
  `is_delete` tinyint NOT NULL DEFAULT '0' COMMENT '是否已删除（0：未删除，1：已删除）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_host_ip` (`host`,`port`) USING BTREE,
  UNIQUE KEY `uniq_name` (`name`) USING BTREE,
  KEY `idx_group_id` (`group_id`) USING BTREE,
  KEY `idx_is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=843973320826893 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='autoexec_runner';

-- ----------------------------
-- Table structure for runner_map
-- ----------------------------
DROP TABLE IF EXISTS `runner_map`;
CREATE TABLE `runner_map` (
  `id` bigint NOT NULL COMMENT '抽象id',
  `runner_id` bigint NOT NULL COMMENT 'runnerId',
  PRIMARY KEY (`id`,`runner_id`) USING BTREE,
  KEY `idx_runner_id` (`runner_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='autoexec_runner_map';

-- ----------------------------
-- Table structure for runnergroup
-- ----------------------------
DROP TABLE IF EXISTS `runnergroup`;
CREATE TABLE `runnergroup` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=848394243072001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='runner组';

-- ----------------------------
-- Table structure for runnergroup_network
-- ----------------------------
DROP TABLE IF EXISTS `runnergroup_network`;
CREATE TABLE `runnergroup_network` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` bigint DEFAULT NULL COMMENT '组id',
  `network_ip` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ip',
  `mask` tinyint DEFAULT NULL COMMENT '子网掩码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=848394243072002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='autoexec_runnergroup_network';

-- ----------------------------
-- Table structure for runnergroup_runner
-- ----------------------------
DROP TABLE IF EXISTS `runnergroup_runner`;
CREATE TABLE `runnergroup_runner` (
  `runnergroup_id` bigint DEFAULT NULL COMMENT 'runner组id',
  `runner_id` bigint DEFAULT NULL COMMENT 'runnerId'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='runner组和runner关系表';

-- ----------------------------
-- Table structure for schedule_job
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job`;
CREATE TABLE `schedule_job` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '名称',
  `handler` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器',
  `begin_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `cron` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'corn表达式',
  `is_active` tinyint(1) DEFAULT '0' COMMENT '0:禁用，1:激活',
  `need_audit` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0:不保存，1:保存',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业信息表';

-- ----------------------------
-- Table structure for schedule_job_audit
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_audit`;
CREATE TABLE `schedule_job_audit` (
  `id` bigint NOT NULL COMMENT 'id',
  `job_uuid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '引用schedule_job的uuid',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '结束时间',
  `content_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内容hash',
  `status` enum('running','succeed','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'running' COMMENT 'success:成功；error异常；processing:进行中',
  `server_id` int NOT NULL COMMENT 'server id',
  `cron` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'cron表达式',
  `next_fire_time` timestamp(3) NULL DEFAULT NULL COMMENT '下次激活时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_job_uuid` (`job_uuid`) USING BTREE,
  KEY `idx_end_time` (`end_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业日志表';

-- ----------------------------
-- Table structure for schedule_job_audit_detail
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_audit_detail`;
CREATE TABLE `schedule_job_audit_detail` (
  `hash` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'hash',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '内容',
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业日志详情表';

-- ----------------------------
-- Table structure for schedule_job_load_time
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_load_time`;
CREATE TABLE `schedule_job_load_time` (
  `job_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'schedule_job表的uuid',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'job组',
  `cron` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'cron表达式',
  `load_time` timestamp(3) NULL DEFAULT NULL COMMENT '加载时间',
  PRIMARY KEY (`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业锁表';

-- ----------------------------
-- Table structure for schedule_job_lock
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_lock`;
CREATE TABLE `schedule_job_lock` (
  `job_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'schedule_job表的uuid',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'job组',
  `job_handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器',
  `lock` enum('running','waiting') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'waiting' COMMENT '定时作业锁',
  `server_id` int NOT NULL COMMENT 'server id',
  PRIMARY KEY (`job_name`,`job_group`) USING BTREE,
  KEY `idx_server_id` (`server_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业锁表';

-- ----------------------------
-- Table structure for schedule_job_prop
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_prop`;
CREATE TABLE `schedule_job_prop` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `job_uuid` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '引用schedule_job的uuid',
  `prop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性名称',
  `prop_value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '属性值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_jobuuid` (`job_uuid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业参数表';

-- ----------------------------
-- Table structure for schedule_job_status
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_status`;
CREATE TABLE `schedule_job_status` (
  `job_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'job uuid',
  `job_group` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'job组',
  `handler` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '处理器',
  `next_fire_time` timestamp(3) NULL DEFAULT NULL COMMENT '下一次被唤醒时间',
  `last_fire_time` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次被唤醒时间',
  `last_finish_time` timestamp(3) NULL DEFAULT NULL COMMENT '最后一次完成时间',
  `exec_count` int NOT NULL DEFAULT '0' COMMENT '执行次数',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后更新时间',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='定时作业状态表';

-- ----------------------------
-- Table structure for score_template
-- ----------------------------
DROP TABLE IF EXISTS `score_template`;
CREATE TABLE `score_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评分模版名称',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '评分模版说明',
  `is_active` tinyint DEFAULT NULL COMMENT '是否启用',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人ID',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '更新人ID',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=573816916729857 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='评分模版表';

-- ----------------------------
-- Table structure for score_template_dimension
-- ----------------------------
DROP TABLE IF EXISTS `score_template_dimension`;
CREATE TABLE `score_template_dimension` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `score_template_id` bigint NOT NULL COMMENT '评分模版ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评分维度名称',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '评分维度说明',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=573817185165313 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='评分模版维度表';

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS `system_notice`;
CREATE TABLE `system_notice` (
  `id` bigint NOT NULL COMMENT 'id',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `start_time` timestamp(3) NULL DEFAULT NULL COMMENT '生效时间',
  `end_time` timestamp(3) NULL DEFAULT NULL COMMENT '失效时间',
  `status` enum('not_issued','issued','stopped') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'not_issued' COMMENT 'not_issued:未下发;issued:已下发;stopped:停用',
  `pop_up` enum('longshow','close') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'close' COMMENT 'longshow:持续弹窗;close:不弹窗',
  `ignore_read` tinyint(1) DEFAULT '-1' COMMENT '是否忽略已读，1:是;0:否:-1:不设置',
  `issue_time` timestamp(3) NULL DEFAULT NULL COMMENT '最近一次下发时间',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_issue_time` (`issue_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统公告表';

-- ----------------------------
-- Table structure for system_notice_recipient
-- ----------------------------
DROP TABLE IF EXISTS `system_notice_recipient`;
CREATE TABLE `system_notice_recipient` (
  `system_notice_id` bigint NOT NULL COMMENT '系统公告ID',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '通知对象uuid',
  `type` enum('common','user','team','role') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型(common,user,team,role)',
  PRIMARY KEY (`system_notice_id`,`uuid`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统公告通知对象表';

-- ----------------------------
-- Table structure for system_notice_user
-- ----------------------------
DROP TABLE IF EXISTS `system_notice_user`;
CREATE TABLE `system_notice_user` (
  `system_notice_id` bigint NOT NULL COMMENT '系统公告ID',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `is_read` tinyint(1) NOT NULL COMMENT '1:已读;0:未读',
  PRIMARY KEY (`system_notice_id`,`user_uuid`) USING BTREE,
  KEY `idx_system_notice_id` (`system_notice_id`) USING BTREE,
  KEY `idx_user_uuid` (`user_uuid`) USING BTREE,
  KEY `idx_notice_id_and_user_uuid` (`system_notice_id`,`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='系统公告用户接收表';

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '标签名',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='标签表';

-- ----------------------------
-- Table structure for tagent
-- ----------------------------
DROP TABLE IF EXISTS `tagent`;
CREATE TABLE `tagent` (
  `id` bigint unsigned NOT NULL COMMENT 'tagent Id',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'tagentIP',
  `port` int NOT NULL COMMENT 'tagent注册端口',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tagent名称',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tagent版本',
  `os_id` bigint DEFAULT NULL COMMENT 'osId',
  `os_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '系统类型',
  `os_version` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '系统版本',
  `osbit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '操作系统位数',
  `account_id` bigint DEFAULT NULL COMMENT '账号id',
  `runner_id` bigint DEFAULT NULL COMMENT 'proxy_id',
  `runner_group_id` bigint DEFAULT NULL COMMENT 'proxy组id',
  `runner_ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'proxy ip',
  `runner_port` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'proxy netty端口',
  `user` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tagent用户',
  `pcpu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'cpu占用',
  `mem` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '内存占用',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tagent状态',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `disconnect_reason` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '连接失败原因',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_ip_port` (`ip`,`port`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent信息表';

-- ----------------------------
-- Table structure for tagent_account
-- ----------------------------
DROP TABLE IF EXISTS `tagent_account`;
CREATE TABLE `tagent_account` (
  `id` bigint NOT NULL COMMENT '主键id',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '密码',
  `protocol_id` bigint NOT NULL COMMENT 'tgent协议id',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '修改人',
  `lcd` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent账号表';

-- ----------------------------
-- Table structure for tagent_account_ip
-- ----------------------------
DROP TABLE IF EXISTS `tagent_account_ip`;
CREATE TABLE `tagent_account_ip` (
  `account_id` bigint NOT NULL COMMENT '账号id',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号对应的ip',
  PRIMARY KEY (`account_id`,`ip`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent账号ip表';

-- ----------------------------
-- Table structure for tagent_ip
-- ----------------------------
DROP TABLE IF EXISTS `tagent_ip`;
CREATE TABLE `tagent_ip` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `tagent_id` bigint NOT NULL COMMENT 'tagentId',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '目标主机的网卡IP',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_id_ip` (`tagent_id`,`ip`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2230355 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent ip表（多网卡）';

-- ----------------------------
-- Table structure for tagent_os
-- ----------------------------
DROP TABLE IF EXISTS `tagent_os`;
CREATE TABLE `tagent_os` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作系统名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=788 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent os';

-- ----------------------------
-- Table structure for tagent_osbit
-- ----------------------------
DROP TABLE IF EXISTS `tagent_osbit`;
CREATE TABLE `tagent_osbit` (
  `osbit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'tagent cpu架构',
  PRIMARY KEY (`osbit`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent cpu架构表';

-- ----------------------------
-- Table structure for tagent_upgrade_audit
-- ----------------------------
DROP TABLE IF EXISTS `tagent_upgrade_audit`;
CREATE TABLE `tagent_upgrade_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `count` bigint DEFAULT NULL COMMENT '升级个数',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '时间',
  `network` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '网段信息',
  `fcu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '升级操作用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=735473471119361 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent升级';

-- ----------------------------
-- Table structure for tagent_upgrade_detail
-- ----------------------------
DROP TABLE IF EXISTS `tagent_upgrade_detail`;
CREATE TABLE `tagent_upgrade_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `audit_id` bigint DEFAULT NULL COMMENT '记录id,关联 flow_tagent_upgrade_audit表',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tagent ip',
  `port` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'tagent port',
  `source_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '原版本',
  `target_version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目标版本',
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '结果',
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '异常',
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=735473471119365 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent升级';

-- ----------------------------
-- Table structure for tagent_version
-- ----------------------------
DROP TABLE IF EXISTS `tagent_version`;
CREATE TABLE `tagent_version` (
  `id` bigint NOT NULL COMMENT '主键',
  `os_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'os类型',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '版本',
  `osbit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'CPU架构\r\n\r\nCPU框架',
  `ignore_file` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '忽略目录或文件',
  `file_id` bigint NOT NULL COMMENT '关联file表，用于下载安装包',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='tagent版本';

-- ----------------------------
-- Table structure for task_config
-- ----------------------------
DROP TABLE IF EXISTS `task_config`;
CREATE TABLE `task_config` (
  `id` bigint NOT NULL COMMENT '自增id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '任务名称',
  `num` int DEFAULT NULL COMMENT '参与人数。-1：不做限制。',
  `policy` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '其中一个人完成即可：any,所有人完成：all',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置信息',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  `fcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '创建人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '修改时间',
  `lcu` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修改人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uniq_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='task_config';

-- ----------------------------
-- Table structure for team
-- ----------------------------
DROP TABLE IF EXISTS `team`;
CREATE TABLE `team` (
  `id` bigint NOT NULL COMMENT 'id',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '领域组上报描述',
  `parent_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '父节点id',
  `lft` int DEFAULT NULL COMMENT '左编码',
  `rht` int DEFAULT NULL COMMENT '右编码',
  `level` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '级别，如公司，部门',
  `is_delete` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已删除',
  `upward_uuid_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '向上uuid路径',
  `upward_name_path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '向上名称路径',
  `source` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'web' COMMENT '数据来源',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后更新时间',
  PRIMARY KEY (`uuid`) USING BTREE,
  KEY `idx_lft_rht` (`lft`,`rht`) USING BTREE,
  KEY `idx_rht_lft` (`rht`,`lft`) USING BTREE,
  KEY `idx_parent_uuid` (`parent_uuid`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分组信息表';

-- ----------------------------
-- Table structure for team_role
-- ----------------------------
DROP TABLE IF EXISTS `team_role`;
CREATE TABLE `team_role` (
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '引用team的uuid',
  `role_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '引用role的uuid',
  `checked_children` tinyint NOT NULL COMMENT '是否穿透选择子节点',
  PRIMARY KEY (`team_uuid`,`role_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分组与角色关系表';

-- ----------------------------
-- Table structure for team_user_title
-- ----------------------------
DROP TABLE IF EXISTS `team_user_title`;
CREATE TABLE `team_user_title` (
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组uuid',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `title_id` bigint NOT NULL COMMENT '头衔id',
  PRIMARY KEY (`team_uuid`,`user_uuid`,`title_id`) USING BTREE,
  KEY `idx` (`title_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分组领导职务关系表';

-- ----------------------------
-- Table structure for test
-- ----------------------------
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test` (
  `A` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `B` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `C` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `D` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `E` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Table structure for theme
-- ----------------------------
DROP TABLE IF EXISTS `theme`;
CREATE TABLE `theme` (
  `id` bigint NOT NULL COMMENT '主键 id',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '主题配置',
  `fcu` varbinary(32) DEFAULT NULL COMMENT '创建人',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='主题配置表';

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL COMMENT 'ID',
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '全局唯一id，跨环境导入用',
  `user_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户Id',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户名',
  `email` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '电话',
  `pinyin` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '拼音',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '是否激活(1：激活，0：未激活)',
  `user_info` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '额外属性',
  `vip_level` tinyint DEFAULT '0' COMMENT 'VIP等级(0,1,2,3,4,5)',
  `is_delete` tinyint(1) DEFAULT '0' COMMENT '是否已删除',
  `token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '随机生成的令牌，用于hmac认证方式签名',
  `is_super_admin` tinyint(1) DEFAULT NULL COMMENT '是否超级管理员',
  PRIMARY KEY (`uuid`) USING BTREE,
  UNIQUE KEY `user_id_idx` (`user_id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户信息表';

-- ----------------------------
-- Table structure for user_agent
-- ----------------------------
DROP TABLE IF EXISTS `user_agent`;
CREATE TABLE `user_agent` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `agent_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代理人uuid',
  `func` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '功能',
  PRIMARY KEY (`user_uuid`,`agent_uuid`,`func`) USING BTREE,
  KEY `idx_agent_uuid` (`agent_uuid`) USING BTREE,
  KEY `idx_user_uuid` (`user_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户授权代理表';

-- ----------------------------
-- Table structure for user_authority
-- ----------------------------
DROP TABLE IF EXISTS `user_authority`;
CREATE TABLE `user_authority` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户ID',
  `auth_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限组',
  `auth` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '权限',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_user_auth` (`user_uuid`,`auth_group`,`auth`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `idx_auth` (`auth`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12486 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户授权表';

-- ----------------------------
-- Table structure for user_data
-- ----------------------------
DROP TABLE IF EXISTS `user_data`;
CREATE TABLE `user_data` (
  `user_uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '数据',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '功能类型',
  PRIMARY KEY (`user_uuid`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户数据';

-- ----------------------------
-- Table structure for user_password
-- ----------------------------
DROP TABLE IF EXISTS `user_password`;
CREATE TABLE `user_password` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户密码',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '有效性',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8443 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户密码表';

-- ----------------------------
-- Table structure for user_profile
-- ----------------------------
DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `module_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模块id',
  `config` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '个性化 json',
  PRIMARY KEY (`user_uuid`,`module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户个性化配置';

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `role_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '引用role的uuid',
  PRIMARY KEY (`user_uuid`,`role_uuid`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `idx_role_uuid` (`role_uuid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37486 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色成员关系表';

-- ----------------------------
-- Table structure for user_session
-- ----------------------------
DROP TABLE IF EXISTS `user_session`;
CREATE TABLE `user_session` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户uuid',
  `visit_time` timestamp(3) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`user_uuid`) USING HASH
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户session表';

-- ----------------------------
-- Table structure for user_team
-- ----------------------------
DROP TABLE IF EXISTS `user_team`;
CREATE TABLE `user_team` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `team_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '引用flow_team的uuid',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '引用flow_user的uuid',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头衔，如组长，副组长',
  PRIMARY KEY (`team_uuid`,`user_uuid`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `idx_flow_user_team` (`user_uuid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8664 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='分组成员关系表';

-- ----------------------------
-- Table structure for user_title
-- ----------------------------
DROP TABLE IF EXISTS `user_title`;
CREATE TABLE `user_title` (
  `id` bigint NOT NULL COMMENT '唯一id',
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头衔名，如果不被引用则自动删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_name` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户职务表';

-- ----------------------------
-- Table structure for worktime
-- ----------------------------
DROP TABLE IF EXISTS `worktime`;
CREATE TABLE `worktime` (
  `uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `is_active` int NOT NULL DEFAULT '1' COMMENT '是否激活，1：激活，0：禁用',
  `lcu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改人',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '最后修改时间',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '每周的工作时段定义',
  `is_delete` tinyint(1) DEFAULT NULL COMMENT '是否已删除',
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务窗口';

-- ----------------------------
-- Table structure for worktime_range
-- ----------------------------
DROP TABLE IF EXISTS `worktime_range`;
CREATE TABLE `worktime_range` (
  `worktime_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'worktime表的uuid',
  `year` int NOT NULL COMMENT '年份',
  `date` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日期',
  `start_time` bigint NOT NULL COMMENT '开始时间戳',
  `end_time` bigint NOT NULL COMMENT '结束时间戳',
  PRIMARY KEY (`worktime_uuid`,`start_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务窗口时间段范围表';

SET FOREIGN_KEY_CHECKS = 1;
