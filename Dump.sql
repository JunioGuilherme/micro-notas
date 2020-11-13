/*
SQLyog Community v10.0 
MySQL - 5.7.10-log : Database - micronotas
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`micronotas` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `micronotas`;

/*Table structure for table `faixas` */

DROP TABLE IF EXISTS `faixas`;

CREATE TABLE `faixas` (
  `idFaixa` varchar(10) NOT NULL,
  `faixaInicio` decimal(20,2) NOT NULL,
  `faixaFim` decimal(20,2) NOT NULL,
  `vistos` int(15) NOT NULL,
  `aprovacoes` int(15) NOT NULL,
  PRIMARY KEY (`idFaixa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `faixas` */

insert  into `faixas`(`idFaixa`,`faixaInicio`,`faixaFim`,`vistos`,`aprovacoes`) values ('_5WK196ROE','0.00','1000.00',1,0),('_5WK197MNS','1000.01','10000.00',1,1),('_5WK1998MM','10000.01','50000.00',2,1),('_5WK19A45Q','50000.01','999999.00',2,2);

/*Table structure for table `historico` */

DROP TABLE IF EXISTS `historico`;

CREATE TABLE `historico` (
  `idHistorico` varchar(10) NOT NULL,
  `idNota` varchar(10) NOT NULL,
  `idUsuario` varchar(10) NOT NULL,
  `data` date NOT NULL,
  `operacao` varchar(10) NOT NULL,
  PRIMARY KEY (`idHistorico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `historico` */

insert  into `historico`(`idHistorico`,`idNota`,`idUsuario`,`data`,`operacao`) values ('_5WP1CYGGR','_5WP1CPNXW','_5WP18PIWP','2020-11-12','visto'),('_5WP1DKHOZ','_5WP1CPNXW','_5WP1CUKTR','2020-11-12','aprovacao'),('_5WP1E1YPY','_5WP1DN2SC','_5WP18PIWP','2020-11-12','visto'),('_5WP1E3DW9','_5WP1DN2SC','_5WP1CUKTR','2020-11-12','aprovacao'),('_5WP1F0YW3','_5WP1EST76','_5WP18PIWP','2020-11-12','visto'),('_5WP1F2203','_5WP1EST76','_5WP1EQJ2S','2020-11-12','visto'),('_5WP1F62IV','_5WP1EST76','_5WP1CUKTR','2020-11-12','aprovacao'),('_5WQ0005PS','_5WP1FCW4C','_5WP1EQJ2S','2020-11-13','visto'),('_5WQ0012BV','_5WP1FCW4C','_5WP18PIWP','2020-11-13','visto'),('_5WQ001U8I','_5WP1FCW4C','_5WP1CUKTR','2020-11-13','aprovacao'),('_5WQ002PM5','_5WP1FCW4C','_5WP1FBH61','2020-11-13','aprovacao'),('_5WQ04M1GY','_5WQ044IBQ','_5WP18PIWP','2020-11-13','visto'),('_5WQ04MH6K','_5WQ040N05','_5WP1EQJ2S','2020-11-13','visto');

/*Table structure for table `notas` */

DROP TABLE IF EXISTS `notas`;

CREATE TABLE `notas` (
  `codigo` int(15) NOT NULL AUTO_INCREMENT,
  `idNota` varchar(10) NOT NULL,
  `idFaixa` varchar(10) NOT NULL,
  `valorMercadoria` decimal(20,2) NOT NULL,
  `valorDesconto` decimal(20,2) NOT NULL,
  `valorFrete` decimal(20,2) NOT NULL,
  `valorTotal` decimal(20,2) NOT NULL,
  `status` tinyint(1) NOT NULL,
  `dataEmissao` date NOT NULL,
  `dataModi` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `qtdVistos` int(15) NOT NULL,
  `qtdAprovacoes` int(15) NOT NULL,
  PRIMARY KEY (`idNota`),
  KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

/*Data for the table `notas` */

insert  into `notas`(`codigo`,`idNota`,`idFaixa`,`valorMercadoria`,`valorDesconto`,`valorFrete`,`valorTotal`,`status`,`dataEmissao`,`dataModi`,`qtdVistos`,`qtdAprovacoes`) values (15,'_5WP1CPNXW','_5WK197MNS','900.00','0.00','230.00','1130.00',1,'2020-11-12','2020-11-12 22:43:38',1,1),(16,'_5WP1DN2SC','_5WK197MNS','900.00','0.00','230.00','1130.00',1,'2020-11-07','2020-11-12 23:09:37',1,1),(17,'_5WP1EST76','_5WK1998MM','12000.00','0.00','0.00','12000.00',1,'2020-11-08','2020-11-12 23:42:05',2,1),(18,'_5WP1FCW4C','_5WK19A45Q','60000.30','0.00','0.00','60000.30',1,'2020-11-15','2020-11-12 23:57:41',2,2),(19,'_5WQ03ZWM6','_5WK197MNS','1515.00','2.00','30.00','1543.00',0,'2020-11-18','2020-11-13 01:51:54',0,0),(20,'_5WQ040N05','_5WK1998MM','25599.00','1000.50','100.00','24698.50',0,'2020-11-09','2020-11-13 01:52:28',1,0),(21,'_5WQ041X62','_5WK196ROE','80.80','0.00','0.00','80.80',0,'2020-11-10','2020-11-13 01:53:28',0,0),(22,'_5WQ042G89','_5WK1998MM','10150.00','300.00','250.00','10100.00',0,'2020-11-11','2020-11-13 01:54:14',0,0),(23,'_5WQ044IBQ','_5WK196ROE','80.90','0.00','15.00','95.90',1,'2020-11-12','2020-11-13 01:55:28',1,0),(24,'_5WQ0455J9','_5WK197MNS','1050.00','200.00','300.00','1150.00',0,'2020-11-13','2020-11-13 01:55:58',0,0);

/*Table structure for table `usuarios` */

DROP TABLE IF EXISTS `usuarios`;

CREATE TABLE `usuarios` (
  `codigo` int(15) NOT NULL AUTO_INCREMENT,
  `idUsuario` varchar(10) NOT NULL,
  `admin` int(1) NOT NULL,
  `nome` varchar(40) NOT NULL,
  `papel` varchar(10) NOT NULL,
  `valorMin` decimal(20,2) NOT NULL,
  `valorMax` decimal(20,2) NOT NULL,
  `dataCria` datetime NOT NULL,
  `dataModi` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `senha` varchar(30) NOT NULL,
  PRIMARY KEY (`idUsuario`),
  KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

/*Data for the table `usuarios` */

insert  into `usuarios`(`codigo`,`idUsuario`,`admin`,`nome`,`papel`,`valorMin`,`valorMax`,`dataCria`,`dataModi`,`senha`) values (1,'_5WK108XEZ',1,'admin','aprovacao','0.00','99999.99','2020-11-07 16:55:08','2020-11-12 19:40:01','admin'),(27,'_5WP18PIWP',0,'jose','visto','0.00','1000.00','2020-11-12 20:51:34','2020-11-12 23:54:55','10                            '),(29,'_5WP1CUKTR',0,'maria','aprovacao','1000.01','10000.00','2020-11-12 22:47:28','2020-11-12 23:55:15','10                            '),(30,'_5WP1EQJ2S',0,'joao','visto','10000.01','50000.00','2020-11-12 23:40:18','2020-11-12 23:55:38','10                            '),(31,'_5WP1FBH61',0,'pedro','aprovacao','50000.01','999999.00','2020-11-12 23:56:35','2020-11-12 23:56:35','10'),(32,'_5WQ04G82I',0,'tiago','visto','0.00','30000.00','2020-11-13 02:05:19','2020-11-13 02:05:24','10');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
