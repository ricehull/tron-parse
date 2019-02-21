-- MySQL dump 10.13  Distrib 8.0.12, for osx10.13 (x86_64)
--
-- Host: localhost    Database: tron_ext
-- ------------------------------------------------------
-- Server version	8.0.12

/*!DROP DATABASE IF EXISTS tron_ext */;
/*!CREATE DATABASE tron_ext */;
/*!use tron_ext */;
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `exchange_kgraph_day`
--

CREATE SCHEMA `tron_ext` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin ;

DROP TABLE IF EXISTS `exchange_kgraph_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `exchange_kgraph_day` (
  `time` bigint(20) NOT NULL DEFAULT '0' COMMENT 'time of some day k graph, usually 00:00:00 of a day',
  `exchange_id` bigint(20) NOT NULL DEFAULT '0',
  `open` bigint(20) NOT NULL DEFAULT '0' COMMENT 'price of open, multiply 1E6 for store, same for high low close',
  `high` bigint(20) NOT NULL DEFAULT '0',
  `low` bigint(20) NOT NULL DEFAULT '0',
  `close` bigint(20) NOT NULL DEFAULT '0',
  `volume` bigint(20) NOT NULL DEFAULT '0' COMMENT 'volume of day one day transactions',
  PRIMARY KEY (time,exchange_id),
  KEY `exchange_id_index` (`exchange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ext_kgraph_min_data`
--

DROP TABLE IF EXISTS `exchange_kgraph_min`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `exchange_kgraph_min` (

  `time` bigint(20) NOT NULL DEFAULT '0',
  `exchange_id` bigint(20) NOT NULL DEFAULT '0',
  `open` bigint(20) NOT NULL DEFAULT '0' COMMENT 'price of open, multiply 1E6 for store, same for high low close',
  `high` bigint(20) NOT NULL DEFAULT '0',
  `low` bigint(20) NOT NULL DEFAULT '0',
  `close` bigint(20) NOT NULL DEFAULT '0',
  `volume` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (time,exchange_id),
  KEY `exchange_id_index` (`exchange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exchange_transaction_detail`
--
DROP TABLE IF EXISTS `exchange_transaction_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `exchange_transaction_detail` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `exchange_id` bigint(20) NOT NULL DEFAULT '0',
  `first_token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `first_quant` bigint NOT NULL DEFAULT '0',
  `second_token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `second_quant` bigint NOT NULL DEFAULT '0',
  `price` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`create_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exchange_pairs`
--
DROP TABLE IF EXISTS `exchange_pairs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `exchange_pairs` (
  `exchange_id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'id of an exchange pair',
  `exchange_name` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'name of an exchange pair eg. IGG/MEETONE',
  `creator_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'owners address',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT 'time of this exchange pair created, time stamp in milisecond',
  `first_token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'the first token name',
  `first_token_balance` bigint NOT NULL DEFAULT '0' COMMENT 'the first token balance, if TRX, the unit is SUN',
  `second_token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'the second token name',
  `second_token_balance` bigint NOT NULL DEFAULT '0' COMMENT 'the second token balance, if TRX, the unit is SUN',
  PRIMARY KEY (`exchange_id`),
  KEY `idx_exchange_id` (`exchange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exchange_auth`
--
CREATE TABLE `tron_ext`.`exchange_auth` (
  `id` BIGINT(20) NOT NULL,
  `creator_address` VARCHAR(100) NULL,
  `first_token_id` VARCHAR(45) NULL,
  `second_token_id` VARCHAR(45) NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  INDEX `idx_address` (`creator_address` ASC));



DROP TABLE IF EXISTS `trc20_tokens`;
--
-- Table structure for table `trc20_tokens`
--
  CREATE TABLE `tron_ext`.`trc20_tokens` (
  `contract_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'trc-20 token contract address',
  `name` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'trc-20 token name',
  `symbol` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'trc-20 token symbol',
  `total_supply` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'total supply of token',
  `decimals` BIGINT(20) NOT NULL DEFAULT '0' COMMENT 'total supply of token',
  `icon_url` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `token_desc` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `home_page` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `white_paper` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `social_media` varchar(5000) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `git_hub` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `issue_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `issuer_addr` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`contract_address`),
  INDEX `idx_name` (`name` ASC));

  DROP TABLE IF EXISTS `trc20_holders`;
CREATE TABLE `trc20_holders` (
  `id`               SERIAL      PRIMARY KEY,
  `holder_address`   varchar(42) NOT NULL DEFAULT '' COMMENT 'trc20 token holder’s address',
  `balance`          BIGINT(20)  UNSIGNED NOT NULL DEFAULT '0',
  `contract_address` varchar(42) NOT NULL DEFAULT '' COMMENT 'trc20 token contract address',
  UNIQUE KEY `compositeUnique` (`holder_address`,`contract_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `trc20_transfer`;
CREATE TABLE `trc20_transfer` (
  `id`               SERIAL      PRIMARY KEY,
  `block_number`     BIGINT(20)  NOT NULL DEFAULT 0 COMMENT 'block height number',
  `block_timestamp`  BIGINT(20)  NOT NULL DEFAULT 0 COMMENT 'block generate time',
  `transaction_id`   VARCHAR(64) UNIQUE NOT NULL DEFAULT '' COMMENT 'transaction id',
  `contract_address` VARCHAR(42) NOT NULL DEFAULT '' COMMENT 'trc20 token contract address',
  `from_address`     VARCHAR(42) NOT NULL DEFAULT '' COMMENT 'trc20 token transfer from address',
  `to_address`       VARCHAR(42) NOT NULL DEFAULT '' COMMENT 'trc20 token transfer to address',
  `quantity`         BIGINT(20)  UNSIGNED NOT NULL DEFAULT 0,
  INDEX `idx_contract_addr` (`contract_address`),
  INDEX `idx_block_ts` (`block_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `runtime_vars`;
CREATE TABLE `runtime_vars` (
  `id`               SERIAL      PRIMARY KEY,
  `var_name`         varchar(500) UNIQUE COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `var_value`        varchar(1000) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  INDEX `idx_var_name` (`var_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- add by fuxuanqi for tronscan new function
DROP TABLE IF EXISTS `wlcy_announcement`;
CREATE TABLE `wlcy_announcement` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '公告id',
  `title_en` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题：英文',
  `title_cn` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题：中文',
  `context_en` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告内容：英文',
  `context_cn` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告内容：中文',
  `type` int(4) NOT NULL DEFAULT '1' COMMENT '公告类型：1，trc10公告；2，trc20公告',
  `status` int(4) NOT NULL DEFAULT '0' COMMENT '公告状态：0，上架；1，下架',
  `user` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ext_info` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '额外信息',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `exchange_pairs_auth` (
  `exchange_id` int(11) NOT NULL COMMENT '???id??????id???????id',
  `status` int(11) DEFAULT NULL,
  PRIMARY KEY (`exchange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `exchange_zero_price` (
  `ts` timestamp NOT NULL COMMENT '??',
  `exchange_id` int(11) DEFAULT NULL COMMENT '???id',
  `first_token_id` varchar(45) DEFAULT NULL COMMENT '???token',
  `first_token_balance` bigint(20) DEFAULT NULL COMMENT '???token??',
  `second_token_id` varchar(45) DEFAULT NULL COMMENT '???token',
  `second_token_balance` bigint(20) DEFAULT NULL COMMENT '???token??',
  `price` bigint(20) DEFAULT NULL COMMENT '????? ???????????',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `idx_exchange` (`exchange_id`),
  KEY `idx_union` (`ts`,`exchange_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
