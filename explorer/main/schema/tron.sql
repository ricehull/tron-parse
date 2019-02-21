-- MySQL dump 10.13  Distrib 5.7.23, for linux-glibc2.12 (x86_64)
--
-- Host: localhost    Database: tron
-- ------------------------------------------------------
-- Server version	5.7.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_asset_balance`
--

DROP TABLE IF EXISTS `account_asset_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_asset_balance` (
  `address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Base 58 encoding address for the token owner',
  `asset_name` varchar(300) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '通证名称',
  `creator_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Token creator address',
  `balance` bigint(20) NOT NULL DEFAULT '0' COMMENT '通证余额',
  KEY `idx_account_asset_balance_addr` (`address`),
  KEY `idx_asset_name` (`asset_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `account_vote_result`
--

DROP TABLE IF EXISTS `account_vote_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_vote_result` (
  `address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'voter address',
  `to_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '投票接收人',
  `vote` bigint(20) NOT NULL DEFAULT '0' COMMENT '投票数',
  KEY `idx_account_vote_result_id` (`address`,`vote`),
  KEY `idx_account_vote_result_to` (`to_address`,`vote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_issue`
--

DROP TABLE IF EXISTS `asset_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_issue` (
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `asset_name` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'asset_name',
  `asset_abbr` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'asset_abbr',
  `total_supply` bigint(20) NOT NULL DEFAULT '0' COMMENT '发行量',
  `frozen_supply` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '冻结量',
  `trx_num` bigint(20) NOT NULL DEFAULT '0' COMMENT 'price 分子',
  `num` bigint(20) NOT NULL DEFAULT '0' COMMENT 'price 分母',
  `participated` bigint(20) NOT NULL DEFAULT '0' COMMENT '已筹集资金',
  `start_time` bigint(20) NOT NULL DEFAULT '0',
  `end_time` bigint(20) NOT NULL DEFAULT '0',
  `order_num` bigint(20) NOT NULL DEFAULT '0',
  `vote_score` int(11) NOT NULL DEFAULT '0',
  `asset_desc` text COLLATE utf8mb4_bin NOT NULL COMMENT 'hexEncoding []byte, if you want display text content, hex decoding and cast to string, as there are data not coding with utf-8',
  `url` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `free_asset_net_limit` bigint(20) NOT NULL DEFAULT '0',
  `public_free_asset_net_limit` bigint(20) NOT NULL DEFAULT '0',
  `public_free_asset_net_usage` bigint(20) NOT NULL DEFAULT '0',
  `public_latest_free_net_time` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`owner_address`,`asset_name`),
  KEY `idx_owner_address` (`owner_address`),
  KEY `idx_asset_name` (`asset_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blocks`
--

DROP TABLE IF EXISTS `blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blocks` (
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID。高度',
  `block_hash` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '区块hash',
  `parent_hash` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '区块父级hash',
  `witness_address` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '代表节点地址',
  `tx_trie_hash` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '验证数根的hash值',
  `block_size` int(32) DEFAULT '0' COMMENT '区块大小',
  `transaction_num` int(32) DEFAULT '0' COMMENT '交易数',
  `confirmed` tinyint(4) DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块创建时间',
  `modified_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间',
  PRIMARY KEY (`block_id`),
  UNIQUE KEY `uniq_blocks_id` (`block_id`),
  KEY `idx_blocks_create_time` (`create_time`),
  KEY `idx_block_witaddr` (`witness_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_account_create`
--

DROP TABLE IF EXISTS `contract_account_create`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_account_create` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `block_id` bigint(20) NOT NULL DEFAULT '0',
  `contract_type` int(11) NOT NULL DEFAULT '0',
  `create_time` bigint(20) NOT NULL DEFAULT '0',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0',
  `owner_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `account_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `account_type` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_account_update`
--

DROP TABLE IF EXISTS `contract_account_update`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_account_update` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `account_name` varchar(300) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'account_name',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_ctx_acc_update_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_asset_issue`
--

DROP TABLE IF EXISTS `contract_asset_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_asset_issue` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `asset_name` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'asset_name',
  `asset_abbr` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'asset_abbr',
  `total_supply` bigint(20) NOT NULL DEFAULT '0' COMMENT '发行量',
  `frozen_supply` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '冻结量',
  `trx_num` bigint(20) NOT NULL DEFAULT '0' COMMENT 'price 分子',
  `num` bigint(20) NOT NULL DEFAULT '0' COMMENT 'price 分母',
  `start_time` bigint(20) NOT NULL DEFAULT '0',
  `end_time` bigint(20) NOT NULL DEFAULT '0',
  `order_num` bigint(20) NOT NULL DEFAULT '0',
  `vote_score` int(11) NOT NULL DEFAULT '0',
  `asset_desc` text COLLATE utf8mb4_bin NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `free_asset_net_limit` bigint(20) NOT NULL DEFAULT '0',
  `public_free_asset_net_limit` bigint(20) NOT NULL DEFAULT '0',
  `public_free_asset_net_usage` bigint(20) NOT NULL DEFAULT '0',
  `public_latest_free_net_time` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_asset_transfer`
--

DROP TABLE IF EXISTS `contract_asset_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_asset_transfer` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `to_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '接收方地址',
  `amount` bigint(20) NOT NULL DEFAULT '0' COMMENT '转账金额。单位sun',
  `asset_name` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_ctx_asset_create_time` (`block_id`,`trx_hash`,`create_time`),
  KEY `idx_ctx_asset_name` (`asset_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_create_smart`
--

DROP TABLE IF EXISTS `contract_create_smart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_create_smart` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `contract_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `abi` text COLLATE utf8mb4_bin NOT NULL,
  `byte_code` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `call_value` bigint(20) NOT NULL DEFAULT '0',
  `consume_user_resource_percent` bigint(20) NOT NULL DEFAULT '0',
  `name` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_freeze_balance`
--

DROP TABLE IF EXISTS `contract_freeze_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_freeze_balance` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `frozen_balance` bigint(20) NOT NULL DEFAULT '0',
  `frozen_duration` bigint(20) NOT NULL DEFAULT '0',
  `resource` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_participate_asset`
--

DROP TABLE IF EXISTS `contract_participate_asset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_participate_asset` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `to_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `asset_name` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'token名称',
  `amount` bigint(20) NOT NULL DEFAULT '0' COMMENT '转账金额。单位sun',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`),
  KEY `idx_asset_name` (`asset_name`),
  KEY `idx_to_address` (`to_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_set_account_id`
--

DROP TABLE IF EXISTS `contract_set_account_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_set_account_id` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `account_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'account_id',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_transfer`
--

DROP TABLE IF EXISTS `contract_transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_transfer` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `to_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '接收方地址',
  `amount` bigint(20) NOT NULL DEFAULT '0' COMMENT '转账金额。单位sun',
  `asset_name` varchar(200) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`),
  KEY `idx_trx_owner` (`owner_address`),
  KEY `idx_trx_to_addr` (`to_address`),
  KEY `idx_trx_asset_name` (`asset_name`),
  KEY `idx_trx_transfer_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_trigger_smart`
--

DROP TABLE IF EXISTS `contract_trigger_smart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_trigger_smart` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `contract_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `call_value` bigint(20) NOT NULL DEFAULT '0',
  `call_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` text COLLATE utf8mb4_bin NOT NULL COMMENT 'transaction result, include fee and result code, []Ret in json format',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_unfreeze_asset`
--

DROP TABLE IF EXISTS `contract_unfreeze_asset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_unfreeze_asset` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_unfreeze_balance`
--

DROP TABLE IF EXISTS `contract_unfreeze_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_unfreeze_balance` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `resource` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_update_asset`
--

DROP TABLE IF EXISTS `contract_update_asset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_update_asset` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `asset_desc` text COLLATE utf8mb4_bin NOT NULL,
  `url` text COLLATE utf8mb4_bin NOT NULL,
  `new_limit` bigint(20) NOT NULL DEFAULT '0',
  `new_public_limit` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_update_setting`
--

DROP TABLE IF EXISTS `contract_update_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_update_setting` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `contract_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `consume_user_resource_percent` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_vote_asset`
--

DROP TABLE IF EXISTS `contract_vote_asset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_vote_asset` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `vote_address` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '投票地址',
  `support` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'support',
  `count` bigint(20) NOT NULL DEFAULT '0' COMMENT 'count',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_vote_witness`
--

DROP TABLE IF EXISTS `contract_vote_witness`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_vote_witness` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `votes` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '投票详情，JSON',
  `support` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'support 0:false, 1:true',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`),
  KEY `idx_owner_address` (`owner_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_witness_create`
--

DROP TABLE IF EXISTS `contract_witness_create`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_witness_create` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `url` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'url',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contract_witness_update`
--

DROP TABLE IF EXISTS `contract_witness_update`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contract_witness_update` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `update_url` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nodes`
--

DROP TABLE IF EXISTS `nodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nodes` (
  `node_host` varchar(300) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'host',
  `node_port` int(11) NOT NULL DEFAULT '0' COMMENT 'port',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`node_host`,`node_port`),
  KEY `idx_node_host` (`node_host`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID，高度',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\nAccountCreateContract = 0;\r\nTransferContract = 1;\r\nTransferAssetContract = 2;\r\nVoteAssetContract = 3;\r\nVoteWitnessContract = 4;\r\nWitnessCreateContract = 5;\r\nAssetIssueContract = 6;\r\nWitnessUpdateContract = 8;\r\nParticipateAssetIssueContract = 9;\r\nAccountUpdateContract = 10;\r\nFreezeBalanceContract = 11;\r\nUnfreezeBalanceContract = 12;\r\nWithdrawBalanceContract = 13;\r\nUnfreezeAssetContract = 14;\r\nUpdateAssetContract = 15;\r\nProposalCreateContract = 16;\r\nProposalApproveContract = 17;\r\nProposalDeleteContract = 18;\r\nSetAccountIdContract = 19;\r\nCustomContract = 20;\r\n// BuyStorageContract = 21;\r\n// BuyStorageBytesContract = 22;\r\n// SellStorageContract = 23;\r\nCreateSmartContract = 30;\r\nTriggerSmartContract = 31;\r\nGetContract = 32;\r\nUpdateSettingContract = 33;\r\nExchangeCreateContract = 41;\r\nExchangeInjectContract = 42;\r\nExchangeWithdrawContract = 43;\r\nExchangeTransactionContract = 44;',
  `contract_data` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易内容数据,原始数据byte hex encoding',
  `result_data` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '交易结果对象byte hex encoding',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `to_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '接收方地址',
  `fee` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易花费 单位 sun',
  `confirmed` tinyint(4) NOT NULL DEFAULT '1',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) DEFAULT '0',
  `modified_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间',
  `real_timestamp` bigint(20) NOT NULL DEFAULT '0' COMMENT 'transaction timestamp',
  `raw_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'transaction raw data.data',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_transactions_hash_create_time` (`block_id`,`trx_hash`,`create_time`),
  KEY `idx_transactions_create_time` (`create_time`),
  KEY `idx_trx_owner` (`owner_address`),
  KEY `idx_trx_toaddr` (`to_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tron_account`
--

DROP TABLE IF EXISTS `tron_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tron_account` (
  `uuid` INT NOT NULL AUTO_INCREMENT,
  `account_name` varchar(300) COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'Account name',
  `account_type` integer not null default '0' comment 'account type, 0 for common account, 2 for contract account',
  `address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Base 58 encoding address',
  `balance` bigint(20) NOT NULL DEFAULT '0' COMMENT 'TRX balance, in sun',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '账户创建时间',
  `latest_operation_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '账户最后操作时间',
  `asset_issue_name` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `is_witness` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为wintness; 0: 不是，1:是',
  `allowance` bigint(20) NOT NULL DEFAULT '0',
  `latest_withdraw_time` bigint(20) NOT NULL DEFAULT '0',
  `latest_consume_time` bigint(20) NOT NULL DEFAULT '0',
  `latest_consume_free_time` bigint(20) NOT NULL DEFAULT '0',
  `frozen` text COLLATE utf8mb4_bin NOT NULL COMMENT '冻结信息',
  `votes` text COLLATE utf8mb4_bin NOT NULL,
  `free_net_used` bigint(20) NOT NULL DEFAULT '0',
  `free_net_limit` bigint(20) NOT NULL DEFAULT '0',
  `net_usage` bigint(20) NOT NULL DEFAULT '0' COMMENT 'bandwidth, get from frozen',
  `net_used` bigint(20) NOT NULL DEFAULT '0',
  `net_limit` bigint(20) NOT NULL DEFAULT '0',
  `total_net_limit` bigint(20) NOT NULL DEFAULT '0',
  `total_net_weight` bigint(20) NOT NULL DEFAULT '0',
  `asset_net_used` text COLLATE utf8mb4_bin NOT NULL,
  `asset_net_limit` text COLLATE utf8mb4_bin NOT NULL,
  `frozen_supply` text COLLATE utf8mb4_bin not NULL,
  `is_committee` tinyint not null default '0',
  `latest_asset_operation_time` text COLLATE utf8mb4_bin not null,
  `account_resource` text COLLATE utf8mb4_bin not null,
  `assets` text COLLATE utf8mb4_bin not null,
  `acc_res` text COLLATE utf8mb4_bin not null,
  `energy_used` bigint(20) NOT NULL DEFAULT '0',
  `energy_limit` bigint(20) NOT NULL DEFAULT '0', 
  `total_energy_limit` bigint(20) NOT NULL DEFAULT '0', 
  `total_energy_weight` bigint(20) NOT NULL DEFAULT '0', 
  `storage_used` bigint(20) NOT NULL DEFAULT '0', 
  `storage_limit` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`address`),
  UNIQUE KEY `uniq_tron_account_uuid` (`uuid` ASC),
  KEY `idx_tron_account_create_time` (`create_time`),
  KEY `idx_account_name` (`account_name`),
  KEY `idx_account_address` (`address`),
  KEY `idx_account_type` (`account_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `witness`
--

DROP TABLE IF EXISTS `witness`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `witness` (
  `address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '地址',
  `vote_count` bigint(20) NOT NULL DEFAULT '0' COMMENT '得票数',
  `public_key` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `url` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `total_produced` bigint(20) NOT NULL DEFAULT '0' COMMENT '生产块数',
  `total_missed` bigint(20) NOT NULL DEFAULT '0' COMMENT '丢失块数',
  `latest_block_num` bigint(20) NOT NULL DEFAULT '0',
  `latest_slot_num` bigint(20) NOT NULL DEFAULT '0',
  `is_job` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为超级候选人 0:false, 1:true',
  PRIMARY KEY (`address`),
  UNIQUE KEY `address_UNIQUE` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_asset_info`
--

DROP TABLE IF EXISTS `wlcy_asset_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_asset_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(200) NOT NULL,
  `token_name` varchar(500) COLLATE utf8mb4_bin  NOT NULL,
  `token_id` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `brief` text,
  `website` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `white_paper` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `github` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `credit` int(11) DEFAULT '0',
  `reddit` varchar(500) DEFAULT NULL,
  `twitter` varchar(500) DEFAULT NULL,
  `facebook` varchar(500) DEFAULT NULL,
  `telegram` varchar(500) DEFAULT NULL,
  `steam` varchar(500) DEFAULT NULL,
  `medium` varchar(500) DEFAULT NULL,
  `webchat` varchar(500) DEFAULT NULL,
  `weibo` varchar(500) DEFAULT NULL,
  `review` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_asset_logo`
--

DROP TABLE IF EXISTS `wlcy_asset_logo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_asset_logo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(100) NOT NULL,
  `logo_url` varchar(400) DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_funds_info`
--

DROP TABLE IF EXISTS `wlcy_funds_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_funds_info` (
  `id` int(32) NOT NULL DEFAULT '0' COMMENT 'ID',
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '基金会地址',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modified_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_geo_info`
--

DROP TABLE IF EXISTS `wlcy_geo_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_geo_info` (
  `ip` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'IP',
  `city` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '城市',
  `country` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '国家',
  `lat` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'ip所属经纬度',
  `lng` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'ip所属经纬度',
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_opreate_log`
--

DROP TABLE IF EXISTS `wlcy_opreate_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_opreate_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(100) DEFAULT NULL,
  `operator` varchar(50) DEFAULT NULL,
  `pic_url` varchar(500) DEFAULT NULL,
  `record` text,
  `extra` text,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_sr_account`
--

DROP TABLE IF EXISTS `wlcy_sr_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_sr_account` (
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '超级代表地址',
  `github_link` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '超级代表github',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modified_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_statistics`
--

DROP TABLE IF EXISTS `wlcy_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_statistics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` bigint(20) NOT NULL DEFAULT '0' COMMENT '时间',
  `avg_block_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块上链平均时间',
  `avg_block_size` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块平均大小',
  `new_block_seen` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块增长数',
  `new_transaction_seen` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易增长数',
  `new_address_seen` bigint(20) NOT NULL DEFAULT '0' COMMENT '地址增长数',
  `total_block_count` bigint(20) NOT NULL DEFAULT '0' COMMENT '总区块数',
  `total_transaction` bigint(20) NOT NULL DEFAULT '0' COMMENT '总交易数',
  `total_address` bigint(20) NOT NULL DEFAULT '0' COMMENT '总地址数',
  `blockchain_size` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块链总大小',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx_date` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_trx_request`
--

DROP TABLE IF EXISTS `wlcy_trx_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_trx_request` (
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求地址',
  `ip` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '请求对应的ip',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modified_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wlcy_witness_create_info`
--

DROP TABLE IF EXISTS `wlcy_witness_create_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_witness_create_info` (
  `address` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '候选人地址',
  `url` varchar(800) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '候选人主页url',
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modified_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-09-20 13:53:24


DROP TABLE IF EXISTS `transactions_index`;
CREATE TABLE `transactions_index` (
  `start_pos` bigint(20) NOT NULL DEFAULT '0',
  `block_id` bigint(20) NOT NULL DEFAULT '0',
  `inner_offset` bigint(20) NOT NULL DEFAULT '0',
  `total_record` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`start_pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `contract_transfer_index`;
CREATE TABLE `contract_transfer_index` (
  `start_pos` bigint(20) NOT NULL DEFAULT '0',
  `block_id` bigint(20) NOT NULL DEFAULT '0',
  `inner_offset` bigint(20) NOT NULL DEFAULT '0',
  `total_record` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`start_pos`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `wlcy_asset_blacklist`;
CREATE TABLE `wlcy_asset_blacklist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `asset_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '通证名字',
  `status` int(4) NOT NULL DEFAULT '2',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_address_name` (`owner_address`,`asset_name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `contract_proposal_delete` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `proposal_id` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;


CREATE TABLE `contract_proposal_create` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `proposal_parameters` text COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;


CREATE TABLE `contract_proposal_approve` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `proposal_id` bigint NOT NULL DEFAULT '0',
  `is_add_proposal` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;

CREATE TABLE `contract_exchange_transaction` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `exchange_id` bigint NOT NULL DEFAULT '0',
  `token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `quant` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;

CREATE TABLE `contract_exchange_withdraw` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `exchange_id` bigint NOT NULL DEFAULT '0',
  `token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `quant` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;

CREATE TABLE `contract_exchange_inject` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `exchange_id` bigint NOT NULL DEFAULT '0',
  `token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `quant` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;

CREATE TABLE `contract_exchange_create` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `firest_token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `first_token_balance` bigint(20) NOT NULL DEFAULT '0',
  `second_token_id` varchar(500) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `second_token_balance` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;



CREATE TABLE `contract_sell_storage` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `sell_storage_bytes` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;


CREATE TABLE `contract_buy_storage_bytes` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `buy_bytes` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;


CREATE TABLE `contract_buy_storage` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `contract_type` int(8) NOT NULL DEFAULT '0' COMMENT '交易类型\\\\nAccountCreateContract = 0;\\\\r\\\\nTransferContract = 1;\\\\r\\\\nTransferAssetContract = 2;\\\\r\\\\nVoteAssetContract = 3;\\\\r\\\\nVoteWitnessContract = 4;\\\\r\\\\nWitnessCreateContract = 5;\\\\r\\\\nAssetIssueContract = 6;\\\\r\\\\nWitnessUpdateContract = 8;\\\\r\\\\nParticipateAssetIssueContract = 9;\\\\r\\\\nAccountUpdateContract = 10;\\\\r\\\\nFreezeBalanceContract = 11;\\\\r\\\\nUnfreezeBalanceContract = 12;\\\\r\\\\nWithdrawBalanceContract = 13;\\\\r\\\\nUnfreezeAssetContract = 14;\\\\r\\\\nUpdateAssetContract = 15;\\\\r\\\\nProposalCreateContract = 16;\\\\r\\\\nProposalApproveContract = 17;\\\\r\\\\nProposalDeleteContract = 18;\\\\r\\\\nSetAccountIdContract = 19;\\\\r\\\\nCustomContract = 20;\\\\r\\\\n// BuyStorageContract = 21;\\\\r\\\\n// BuyStorageBytesContract = 22;\\\\r\\\\n// SellStorageContract = 23;\\\\r\\\\nCreateSmartContract = 30;\\\\r\\\\nTriggerSmartContract = 31;\\\\r\\\\nGetContract = 32;\\\\r\\\\nUpdateSettingContract = 33;\\\\r\\\\nExchangeCreateContract = 41;\\\\r\\\\nExchangeInjectContract = 42;\\\\r\\\\nExchangeWithdrawContract = 43;\\\\r\\\\nExchangeTransactionContract = 44;',
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '交易创建时间',
  `expire_time` bigint(20) NOT NULL DEFAULT '0',
  `confirmed` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `owner_address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '发起方地址',
  `quant` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `idx_trx_transfe_hash_create_time` (`block_id`,`trx_hash`,`create_time` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;

CREATE TABLE `wlcy_api_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '用户',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idx_username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wlcy_funds_balance` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `funds` bigint(20) NOT NULL DEFAULT '0' COMMENT 'funds排序标示',
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '基金会地址',
  `balance` bigint(20) NOT NULL DEFAULT '0' COMMENT '基金会锁定金额',
  `total` bigint(20) NOT NULL DEFAULT '0' COMMENT '基金会锁定总额',
	`extra` text COLLATE utf8mb4_unicode_ci COMMENT 'extra',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `transaction_info` (
  `trx_hash` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `block_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `id` varchar(300) NOT NULL DEFAULT '0' COMMENT 'trx info id',
  `block_num` bigint(20) NOT NULL DEFAULT '0' COMMENT 'block num return by trx info',
  `block_timestamp` bigint(20) NOT NULL DEFAULT '0' COMMENT 'block timestamp return by trx info',
  `contract_address` varchar(300) NOT NULL DEFAULT '0' COMMENT 'contract address in base58 encoding',
  `contract_result` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'contract result in json, origin type is [][]byte',
  `receipt_energy_usage`  bigint(20) NOT NULL DEFAULT '0',
  `receipt_energy_fee` bigint(20) NOT NULL DEFAULT '0',
  `receipt_origin_energy_usage`  bigint(20) NOT NULL DEFAULT '0',
  `receipt_energy_usage_total`  bigint(20) NOT NULL DEFAULT '0',
  `receipt_net_usage` bigint(20) NOT NULL DEFAULT '0',
  `receipt_net_fee` bigint(20) NOT NULL DEFAULT '0',
  `log` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'trx info log in json, origin type is []*TransactionInfo_Log',
  `result` bigint(20) NOT NULL DEFAULT '0' COMMENT 'trx result, 0: success, 1: failed',
  `res_message` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'trx res_message, as string, origin is []byte',
  `withdraw_amount` bigint(20) NOT NULL DEFAULT '0',
  `unfreeze_amount` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`trx_hash`,`block_id`),
  KEY `trx_info_contract_address` (`block_id`,`trx_hash`,`contract_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
/*!50100 PARTITION BY HASH (`block_id`)
PARTITIONS 100 */;

--
-- Table structure for table `wlcy_smart_contract`
--

DROP TABLE IF EXISTS `wlcy_smart_contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wlcy_smart_contract` (
  `address` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contract_name` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '智能合约名称',
  `compiler_version` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '编译器版本',
  `is_optimized` tinyint(2) DEFAULT '0' COMMENT '是否优化。0 未优化 1 优化',
  `source_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '智能合约源代码',
  `byte_code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '智能合约编译后的二进制',
  `abi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '智能合约编译后的abi',
  `abi_encoded` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '编译abi设置',
  `contract_library` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '智能合约引用的library，json string',
  `verify_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`address`),
  KEY `idx_smart_contract_address` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wlcy_wallet_image` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片标识',
  `depict` text COLLATE utf8mb4_unicode_ci COMMENT '详情介绍',
  `image` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '图片标识',
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '确认状态。0 未确认。1 已确认',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ----------------------------
-- Table structure for wlcy_gr_witness_votes
-- ----------------------------
DROP TABLE IF EXISTS `wlcy_gr_witness_votes`;
CREATE TABLE `wlcy_gr_witness_votes` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'id',
  `block` bigint(20) NOT NULL DEFAULT '0' COMMENT '区块ID',
  `transaction` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '交易hash',
  `timestamp` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '时间',
  `voter_address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'voter_address',
  `candidate_address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'candidate_address',
  `votes` bigint(20) NOT NULL DEFAULT '0' COMMENT 'votes',
  `candidate_url` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'candidate_url',
  `candidate_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'candidate_name',
  `voter_available_votes` bigint(20) NOT NULL DEFAULT '0' COMMENT 'voter_available_votes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of wlcy_gr_witness_votes
-- ----------------------------
INSERT INTO `wlcy_gr_witness_votes` VALUES ('0d27d133-38bf-e357-9984-43406c308506', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TEVAq8dmSQyTYK7uP1ZnZpa6MBVR83GsV6', 100000004, 'http://TronGr23.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('1ad1ec8e-1d80-7023-f4cb-93a177077988', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TCf5cqLffPccEY7hcsabiFnMfdipfyryvr', 100000007, 'http://TronGr20.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('2dacc7cc-2fd2-4fe2-e0d8-c51cd290637b', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TWm3id3mrQ42guf7c4oVpYExyTYnEGy3JL', 100000018, 'http://TronGr9.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('2e2503b2-1721-b316-41ce-68023534587e', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TWKZN1JJPFydd5rMgMCV5aZTSiwmoksSZv', 100000024, 'http://TronGr3.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('31f4f718-f706-2714-9705-1e4570ce644d', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TZHvwiw9cehbMxrtTbmAexm9oPo4eFFvLS', 100000012, 'http://TronGr15.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('3e9512f8-51c7-9964-b17c-37185dfdb575', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TGqFJPFiEqdZx52ZR4QcKHz4Zr3QXA24VL', 100000020, 'http://TronGr7.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('4bf19519-e339-c358-88e9-eab5c7ce7455', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TVDmPWGYxgi5DNeW8hXrzrhY8Y6zgxPNg4', 100000025, 'http://TronGr2.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('4d684d1f-99d2-34db-837a-98cfa1b5347c', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TDarXEG2rAD57oa7JTK785Yb2Et32UzY32', 100000023, 'http://TronGr4.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('6248b749-a800-81a6-87f1-5255883ea06b', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'THKJYuUmMKKARNf7s2VT51g5uPY6KEqnat', 100000026, 'http://TronGr1.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('6f3cdc55-9075-7cf0-17c4-6dcd1d70a3ff', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TX3ZceVew6yLC5hWTXnjrUFtiFfUDGKGty', 100000009, 'http://TronGr18.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('73c86a1d-5d9f-4f07-8e10-6d9c9eea1a2b', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TK6V5Pw2UWQWpySnZyCDZaAvu1y48oRgXN', 100000021, 'http://TronGr6.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('8c4fda27-ac0a-5ceb-897e-46dd57c8bebb', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TGK6iAKgBmHeQyp5hn3imB71EDnFPkXiPR', 100000011, 'http://TronGr16.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('8d6ff0d7-677a-51ea-9213-56d3b46fd8ac', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TDbNE1VajxjpgM5p7FyGNDASt3UVoFbiD3', 100000001, 'http://TronGr26.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('936a88a0-996e-9aa7-d7d9-d8a67a7862a1', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TRMP6SKeFUt5NtMLzJv8kdpYuHRnEGjGfe', 100000002, 'http://TronGr25.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('9813b62f-bda1-b510-013a-1ef28c05d2f5', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TCvwc3FV3ssq2rD82rMmjhT4PVXYTsFcKV', 100000017, 'http://TronGr10.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('9a7398a4-58a7-3f39-8280-59b2059e09f6', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TLTDZBcPoJ8tZ6TTEeEqEvwYFk2wgotSfD', 100000000, 'http://TronGr27.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('9d79b558-8b01-1d9a-3e77-c985f499bd36', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TYednHaV9zXpnPchSywVpnseQxY9Pxw4do', 100000008, 'http://TronGr19.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('a18ceda3-c758-fbad-de44-0649080dddce', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TLaqfGrxZ3dykAFps7M2B4gETTX1yixPgN', 100000010, 'http://TronGr17.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('a5f8780e-8640-8b4b-d703-2c55c51594b8', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TBYsHxDmFaRmfCF3jZNmgeJE8sDnTNKHbz', 100000005, 'http://TronGr22.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('b57745d6-549f-e6ab-708a-bdc21db4b552', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TNGoca1VHC6Y5Jd2B1VFpFEhizVk92Rz85', 100000015, 'http://TronGr12.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('b85e2f8b-3b05-ed97-6e6f-54ed0dc32ecb', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TAa14iLEKPAetX49mzaxZmH6saRxcX7dT5', 100000006, 'http://TronGr21.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('cee6392c-fe36-fc49-b2fd-2356ccd5011a', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TEEzguTtCihbRPfjf1CvW8Euxz1kKuvtR9', 100000013, 'http://TronGr14.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('d47ae6dc-37ea-e757-ffaf-f2ef8da83513', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TRKJzrZxN34YyB8aBqqPDt7g4fv6sieemz', 100000003, 'http://TronGr24.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('e31a1a36-f380-5d29-de9f-9e67d6e05c5c', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TC1ZCj9Ne3j5v3TLx5ZCDLD55MU9g3XqQW', 100000019, 'http://TronGr8.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('e60e0be9-2aad-3981-42a5-0f1b06a3ed69', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TLCjmH6SqGK8twZ9XrBDWpBbfyvEXihhNS', 100000014, 'http://TronGr13.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('f033df54-dbde-5ec7-3fe6-4c6bf8dac02c', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TAmFfS4Tmm8yKeoqZN8x51ASwdQBdnVizt', 100000022, 'http://TronGr5.com', '', 50000000);
INSERT INTO `wlcy_gr_witness_votes` VALUES ('f21abe5d-e4ee-bda8-14e9-b20c273331bc', 0, '788b4d0ca432b3d07f895dffe80429bf58398d0e86222460b07f9db38e238803', '2018-06-25T05:03:15.000Z', 'TLLM21wteSPs4hKjbxgmH1L6poyMjeTbHm', 'TFuC2Qge4GxA2U9abKxk1pw3YZvGM5XRir', 100000016, 'http://TronGr11.com', '', 50000000);

  CREATE TABLE `wlcy_smart_report` (
  `smart_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '智能合约地址',
  `block_id` int(11) DEFAULT NULL COMMENT '当前统计数量的截止区块',
  `smart_name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '合约名称',
  `smart_balance` bigint(20) DEFAULT NULL COMMENT '合约账户余额',
  `transfer_num` bigint(20) DEFAULT NULL COMMENT '合约转账交易数量',
  `trigger_num` bigint(20) DEFAULT NULL COMMENT '合约触发交易数量',
  `tnx_total` bigint(20) DEFAULT NULL COMMENT '总交易数=transfer_num+tigger_num+create_contract（1）',
  PRIMARY KEY (`smart_address`),
  UNIQUE KEY `smart_address_UNIQUE` (`smart_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci