/*
 Navicat Premium Data Transfer

 Source Server         : mysql-localhost
 Source Server Type    : MySQL
 Source Server Version : 80027 (8.0.27)
 Source Host           : localhost:3306
 Source Schema         : moolahgo

 Target Server Type    : MySQL
 Target Server Version : 80027 (8.0.27)
 File Encoding         : 65001

 Date: 22/10/2022 20:34:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for incoming_transaction
-- ----------------------------
DROP TABLE IF EXISTS `incoming_transaction`;
CREATE TABLE `incoming_transaction`  (
  `bank_in_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `bank_in_transaction_date` datetime NULL DEFAULT NULL,
  `bank_in_amount` decimal(15, 2) NULL DEFAULT NULL,
  `bank_in_currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_in_beneficiary_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_in_beneficiary_account` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_in_sender_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_in_transaction_reference` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `bank_in_status` enum('pending','unmatched','matched') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending',
  PRIMARY KEY (`bank_in_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of incoming_transaction
-- ----------------------------
INSERT INTO `incoming_transaction` VALUES (1, '2022-10-22 15:38:03', 1500.00, 'IDR', NULL, NULL, NULL, '1', 'pending');
INSERT INTO `incoming_transaction` VALUES (2, '2022-10-22 15:48:58', 2400.00, 'IDR', NULL, NULL, NULL, '4', 'pending');

-- ----------------------------
-- Table structure for remit_transaction
-- ----------------------------
DROP TABLE IF EXISTS `remit_transaction`;
CREATE TABLE `remit_transaction`  (
  `transaction_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `transaction_source_amount` decimal(15, 2) NULL DEFAULT NULL,
  `transaction_source_currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `transaction_fee_amount` decimal(15, 2) NULL DEFAULT NULL,
  `transaction_fee_currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `transaction_destination_amount` decimal(15, 2) NULL DEFAULT NULL,
  `transaction_destination_currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `transaction_financial_status` enum('unpaid','paid','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'unpaid',
  `transaction_processing_status` enum('pending','active_origin','active_destination','completed','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'pending',
  `transaction_sender_id` int UNSIGNED NULL DEFAULT NULL,
  `transaction_beneficiary_id` int UNSIGNED NULL DEFAULT NULL,
  `transaction_reference_number` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` datetime NULL DEFAULT NULL,
  `transaction_expected_amount` decimal(15, 2) NULL DEFAULT NULL,
  `transaction_expected_currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`transaction_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of remit_transaction
-- ----------------------------
INSERT INTO `remit_transaction` VALUES (1, 1000.00, 'IDR', 200.00, 'IDR', 1000.00, 'IDR', 'unpaid', 'pending', 1, 1, '1', NULL, NULL, 1500.00, 'IDR');
INSERT INTO `remit_transaction` VALUES (2, 2000.00, 'IDR', 200.00, 'IDR', 2000.00, 'IDR', 'unpaid', 'pending', 1, 1, '2', NULL, NULL, 3000.00, 'IDR');
INSERT INTO `remit_transaction` VALUES (3, 3000.00, 'IDR', 200.00, 'IDR', 3000.00, 'IDR', 'unpaid', 'pending', 1, 1, '3', NULL, NULL, 1200.00, 'IDR');
INSERT INTO `remit_transaction` VALUES (4, 2400.00, 'IDR', 200.00, 'IDR', 2400.00, 'IDR', 'unpaid', 'pending', 1, 1, '4', NULL, NULL, 2400.00, 'IDR');

SET FOREIGN_KEY_CHECKS = 1;
