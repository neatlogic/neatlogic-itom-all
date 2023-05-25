/*
 Navicat Premium Data Transfer

 Source Server         : 
 Source Server Type    : MySQL
 Source Server Version : 80027
 Source Host           : 
 Source Schema         : neatlogic

 Target Server Type    : MySQL
 Target Server Version : 80027
 File Encoding         : 65001

 Date: 25/05/2023 16:59:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for datasource
-- ----------------------------
DROP TABLE IF EXISTS `datasource`;
CREATE TABLE `datasource` (
  `tenant_id` bigint NOT NULL,
  `tenant_uuid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `driver` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `host` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `port` int DEFAULT NULL,
  PRIMARY KEY (`tenant_id`) USING BTREE,
  UNIQUE KEY `uk_tenant_uuid` (`tenant_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of datasource
-- ----------------------------
BEGIN;
INSERT INTO `datasource` VALUES (1, 'demo', 'jdbc:mysql://{host}:{port}/{dbname}?characterEncoding=UTF-8&jdbcCompliantTruncation=false&allowMultiQueries=true&useSSL=false&&serverTimeZone=Asia/Shanghai', 'root', 'Zanyue$2022', 'com.mysql.cj.jdbc.Driver', '127.0.0.1', 3306);
COMMIT;

-- ----------------------------
-- Table structure for master_user
-- ----------------------------
DROP TABLE IF EXISTS `master_user`;
CREATE TABLE `master_user` (
  `uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `pinyin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `role` enum('','MASTER_ADMIN','MASTER_MANAGER') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of master_user
-- ----------------------------
BEGIN;
INSERT INTO `master_user` VALUES ('111', 'admin', '管理员', 'admin', NULL, NULL, 1, NULL);
COMMIT;

-- ----------------------------
-- Table structure for master_user_password
-- ----------------------------
DROP TABLE IF EXISTS `master_user_password`;
CREATE TABLE `master_user_password` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户ID',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '用户密码',
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `is_active` tinyint(1) DEFAULT NULL COMMENT '有效性',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of master_user_password
-- ----------------------------
BEGIN;
INSERT INTO `master_user_password` VALUES (111, '111', 'admin', '{MD5}e10adc3949ba59abbe56e057f20f883e', NULL, 1);
COMMIT;

-- ----------------------------
-- Table structure for master_user_session
-- ----------------------------
DROP TABLE IF EXISTS `master_user_session`;
CREATE TABLE `master_user_session` (
  `user_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visit_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_uuid`) USING HASH
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of master_user_session
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for mongodb
-- ----------------------------
DROP TABLE IF EXISTS `mongodb`;
CREATE TABLE `mongodb` (
  `tenant_id` bigint NOT NULL,
  `tenant_uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `database` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `host` varchar(1025) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `option` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`tenant_id`) USING BTREE,
  UNIQUE KEY `uk_tenant_uuid` (`tenant_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of mongodb
-- ----------------------------
BEGIN;
INSERT INTO `mongodb` VALUES (1, 'demo', 'autoexec', 'autoexec', 'mongodbPwd', '127.0.0.1:27017', 'authSource=autoexec');
COMMIT;

-- ----------------------------
-- Table structure for server_counter
-- ----------------------------
DROP TABLE IF EXISTS `server_counter`;
CREATE TABLE `server_counter` (
  `from_server_id` int NOT NULL COMMENT '发送服务器id',
  `to_server_id` int NOT NULL COMMENT '目标服务器id',
  `counter` int NOT NULL COMMENT '计数器',
  PRIMARY KEY (`from_server_id`,`to_server_id`) USING HASH
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务器计数统计';

-- ----------------------------
-- Records of server_counter
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for server_status
-- ----------------------------
DROP TABLE IF EXISTS `server_status`;
CREATE TABLE `server_status` (
  `host` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '服务器ip地址',
  `server_id` int NOT NULL COMMENT 'config.properties文件的schedule.server.id',
  `status` enum('startup','stop') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'startup' COMMENT '服务器状态，启动或停机',
  PRIMARY KEY (`server_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='服务器状态';

-- ----------------------------
-- Records of server_status
-- ----------------------------
BEGIN;
INSERT INTO `server_status` VALUES ('192.168.0.104', 1, 'startup');
INSERT INTO `server_status` VALUES ('http://192.168.0.97:8282', 97, 'startup');
INSERT INTO `server_status` VALUES (NULL, 8341, 'startup');
COMMIT;

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant` (
  `id` bigint NOT NULL COMMENT 'id',
  `uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'uuid',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '租户名',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '1:启用，0:禁用',
  `status` enum('building','built','error','ddl','dml','dmldemo') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '租户状态',
  `expire_date` timestamp NULL DEFAULT NULL COMMENT '有效期',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '描述',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '创建租户异常',
  `is_need_demo` tinyint(1) DEFAULT NULL COMMENT '创建租户是否携带demo数据',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_uuid` (`uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tenant
-- ----------------------------
BEGIN;
INSERT INTO `tenant` VALUES (1, 'demo', 'demo', 1, NULL, NULL, NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for tenant_audit
-- ----------------------------
DROP TABLE IF EXISTS `tenant_audit`;
CREATE TABLE `tenant_audit` (
  `id` bigint NOT NULL,
  `group_id` bigint DEFAULT NULL COMMENT '分组id',
  `tenant_id` bigint NOT NULL COMMENT '租户id',
  `module_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `module_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模块id',
  `start_time` timestamp(3) NULL DEFAULT NULL,
  `end_time` timestamp(3) NULL DEFAULT NULL,
  `result_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `error_hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('doing','done') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sql_type` enum('ddl','dml','dmldemo') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tenant_audit
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tenant_audit_detail
-- ----------------------------
DROP TABLE IF EXISTS `tenant_audit_detail`;
CREATE TABLE `tenant_audit_detail` (
  `hash` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`hash`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tenant_audit_detail
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tenant_module
-- ----------------------------
DROP TABLE IF EXISTS `tenant_module`;
CREATE TABLE `tenant_module` (
  `tenant_id` bigint NOT NULL COMMENT '租户id',
  `module_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模块id',
  `ddl_status` tinyint(1) DEFAULT '0' COMMENT 'ddl执行状态,1:成功 0:未开始 -1 :失败',
  `dml_status` tinyint(1) DEFAULT '0' COMMENT 'dml执行状态,1:成功 0:未开始 -1:失败',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '添加日期',
  `lcd` timestamp(3) NULL DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`tenant_id`,`module_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tenant_module
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for tenant_module_dmlsql
-- ----------------------------
DROP TABLE IF EXISTS `tenant_module_dmlsql`;
CREATE TABLE `tenant_module_dmlsql` (
  `tenant_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '租户uuid',
  `module_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '模块id',
  `sql_uuid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'sql md5',
  `sql_status` tinyint(1) DEFAULT NULL COMMENT 'sql执行状态,1:已执行',
  `fcd` timestamp(3) NULL DEFAULT NULL COMMENT '执行时间',
  PRIMARY KEY (`tenant_uuid`,`module_id`,`sql_uuid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;


-- ----------------------------
-- Table structure for tenant_modulegroup
-- ----------------------------
DROP TABLE IF EXISTS `tenant_modulegroup`;
CREATE TABLE `tenant_modulegroup` (
  `tenant_id` bigint NOT NULL,
  `tenant_uuid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '需删除',
  `module_group` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`tenant_id`,`module_group`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of tenant_modulegroup
-- ----------------------------
BEGIN;
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'autoexec');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'cmdb');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'dashboard');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'deploy');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'inspect');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'knowledge');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'pbc');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'process');
INSERT INTO `tenant_modulegroup` VALUES (1, 'demo', 'report');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
