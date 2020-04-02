-- MySQL dump 10.13  Distrib 5.5.21, for Win32 (x86)
--
-- Host: localhost    Database: znajomi
-- ------------------------------------------------------
-- Server version	5.5.21-log

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
-- Table structure for table `osoby`
--

create database znajomi;
use znajomi;

DROP TABLE IF EXISTS `osoby`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `osoby` (
  `id_o` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `imie` char(12) COLLATE utf8_unicode_ci NOT NULL,
  `nazwisko` char(18) COLLATE utf8_unicode_ci NOT NULL,
  `wiek` tinyint(4) DEFAULT NULL,
  `miasto` char(22) COLLATE utf8_unicode_ci DEFAULT 'gliwice',
  PRIMARY KEY (`id_o`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `osoby`
--

LOCK TABLES `osoby` WRITE;
/*!40000 ALTER TABLE `osoby` DISABLE KEYS */;
INSERT INTO `osoby` VALUES (1,'Jan','Lis',0,'gliwice'),(2,'Ola','Nowak',56,'gliwice'),(3,'Ela','Maj',21,'gliwice'),(4,'Ala','Guz',87,'gliwice'),(5,'Iza','Kot',38,'gliwice'),(6,'Marek','Reks',30,'Zabrze'),(7,'imie','nazwisko',25,'zabrze'),(8,'Ela','Nowak',17,'Nowa Sól'),(9,'www','onet',90,'gliwice');
/*!40000 ALTER TABLE `osoby` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pol`
--

DROP TABLE IF EXISTS `pol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pol` (
  `id_p` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `id_o` tinyint(3) unsigned NOT NULL,
  `id_t` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id_p`),
  KEY `id_o` (`id_o`),
  KEY `id_t` (`id_t`),
  CONSTRAINT `pol_ibfk_1` FOREIGN KEY (`id_o`) REFERENCES `osoby` (`id_o`),
  CONSTRAINT `pol_ibfk_2` FOREIGN KEY (`id_t`) REFERENCES `telefony` (`id_t`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pol`
--

LOCK TABLES `pol` WRITE;
/*!40000 ALTER TABLE `pol` DISABLE KEYS */;
INSERT INTO `pol` VALUES (1,2,8),(2,2,1),(3,3,8),(4,1,5),(5,2,7),(6,2,6);
/*!40000 ALTER TABLE `pol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telefony`
--

DROP TABLE IF EXISTS `telefony`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telefony` (
  `id_t` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `numer` char(9) COLLATE utf8_unicode_ci NOT NULL,
  `typ` enum('stacjonarny','komórka') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'komórka',
  `operator` enum('era','heyah','tp','orange','play','tu_biedronka') COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_t`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telefony`
--

LOCK TABLES `telefony` WRITE;
/*!40000 ALTER TABLE `telefony` DISABLE KEYS */;
INSERT INTO `telefony` VALUES (1,'565432789','komórka','era'),(2,'609784512','komórka','tp'),(5,'588890789','stacjonarny','tp'),(6,'565490789','komórka','orange'),(7,'565490789','komórka','orange'),(8,'512342789','komórka','heyah'),(9,'777444111','komórka','heyah');
/*!40000 ALTER TABLE `telefony` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-19  9:23:29
