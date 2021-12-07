-- MySQL dump 10.13  Distrib 8.0.21, for Win64 (x86_64)
--
-- Host: localhost    Database: twittersample
-- ------------------------------------------------------
-- Server version	8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tweets`
--

DROP TABLE IF EXISTS `tweets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tweets` (
  `keyword` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tweet_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `polarity` int NOT NULL,
  `subjectivity` int NOT NULL,
  `location` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `country_code` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `cleaned_text` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `hash_tag_str` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `favorite_count` int DEFAULT NULL,
  `retweet_count` int DEFAULT NULL,
  `lang` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `user_mentions_str` varchar(4096) COLLATE utf8mb4_cs_0900_as_cs DEFAULT NULL,
  KEY `keyword_index` (`keyword`) /*!80000 INVISIBLE */
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_cs_0900_as_cs;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'twittersample'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_init_chart_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_init_chart_data`(IN `keyword` VARCHAR(256), IN `starttime` DATETIME, IN `starttime_mili` BIGINT, IN `interval_minute` INT, IN `pre_minute` INT)
BEGIN
    SET @query = CONCAT(
        "(SELECT ", starttime_mili-60000*59, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 59 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*60 + pre_minute," MINUTE)) UNION ",
        "(SELECT ", starttime_mili-60000*58, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 58 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*59 + pre_minute," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*57, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 57 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*58 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*56, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 56 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*57 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*55, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 55 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*56 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*54, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 54 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*55 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*53, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 53 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*54 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*52, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 52 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*53 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*51, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 51 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*52 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*50, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 50 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*51 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*49, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 49 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*50 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*48, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 48 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*49 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*47, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 47 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*48 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*46, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 46 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*47 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*45, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 45 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*46 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*44, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 44 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*45 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*43, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 43 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*44 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*42, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 42 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*43 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*41, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 41 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*42 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*40, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 40 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*41 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*39, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 39 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*40 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*38, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 38 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*39 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*37, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 37 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*38 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*36, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 36 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*37 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*35, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 35 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*36 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*34, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 34 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*35 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*33, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 33 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*34 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*32, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 32 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*33 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*31, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 31 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*32 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*30, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 30 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*31 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*29, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 29 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*30 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*28, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 28 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*29 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*27, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 27 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*28 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*26, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 26 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*27 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*25, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 25 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*26 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*24, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 24 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*25 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*23, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 23 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*24 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*22, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 22 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*23 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*21, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 21 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*22 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*20, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 20 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*21 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*19, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 19 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*20 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*18, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 18 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*19 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*17, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 17 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*18 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*16, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 16 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*17 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*15, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 15 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*16 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*14, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 14 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*15 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*13, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 13 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*14 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*12, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 12 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*13 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*11, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 11 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*12 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*10, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 10 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*11 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*9, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 9 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*10 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*8, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 8 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*9 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*7, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 7 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*8 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*6, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 6 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*7 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*5, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 5 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*6 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*4, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 4 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*5 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*3, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 3 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*4 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*2, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 2 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*3 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*1, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 1 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*2 + pre_minute ," MINUTE)) UNION",
        "(SELECT ", starttime_mili-60000*0, " as sec, IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", starttime, "',INTERVAL ", interval_minute * 0 + pre_minute , " MINUTE) AND created_at>=date_sub('", starttime, "', INTERVAL ",  interval_minute*1 + pre_minute ," MINUTE))"
        
    );
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SET @query2 = CONCAT("SELECT UPPER(country_code), COUNT(tweet_id) cc FROM tweets WHERE keyword='", keyword, "' AND created_at<date_sub('", starttime, "', INTERVAL ", pre_minute, " MINUTE) GROUP BY country_code ORDER BY cc");
    PREPARE stmt2 FROM @query2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_realtime_chart_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_realtime_chart_data`(IN `keyword` VARCHAR(256), IN `nexttime` DATETIME, IN `interval_minute` INT, IN `pre_minute` INT)
BEGIN
    SET @query = CONCAT("(SELECT IFNULL(SUM(IF(polarity=-1, 1, 0)), 0) AS ng, IFNULL(SUM(IF(polarity=0, 1, 0)), 0) AS ne, IFNULL(SUM(IF(polarity=1, 1, 0)), 0) AS po FROM tweets WHERE keyword='", keyword, "' AND created_at < date_sub('", nexttime, "', INTERVAL ", pre_minute, " MINUTE) AND created_at>=date_sub('", nexttime, "', INTERVAL ", interval_minute+pre_minute, " MINUTE))");    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query2 = CONCAT("SELECT UPPER(country_code), COUNT(tweet_id) cc FROM tweets WHERE keyword='", keyword, "' AND created_at<date_sub('", nexttime, "', INTERVAL ", pre_minute, " MINUTE) GROUP BY country_code ORDER BY cc");
    PREPARE stmt2 FROM @query2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-12  9:12:41
