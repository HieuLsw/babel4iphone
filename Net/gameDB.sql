-- phpMyAdmin SQL Dump
-- version 3.2.3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generato il: 10 feb, 2010 at 12:29 PM
-- Versione MySQL: 5.0.88
-- Versione PHP: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `gameDB`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `arena`
--

CREATE TABLE IF NOT EXISTS `arena` (
  `id` int(11) NOT NULL auto_increment,
  `user_id1` varchar(50) collate latin1_general_cs NOT NULL,
  `user_id2` varchar(50) collate latin1_general_cs NOT NULL,
  `turn` varchar(50) collate latin1_general_cs NOT NULL,
  `time` double NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs AUTO_INCREMENT=15 ;

--
-- Dump dei dati per la tabella `arena`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `character`
--

CREATE TABLE IF NOT EXISTS `character` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) collate latin1_general_cs NOT NULL,
  `race` varchar(50) collate latin1_general_cs NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs AUTO_INCREMENT=1 ;

--
-- Dump dei dati per la tabella `character`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `collection`
--

CREATE TABLE IF NOT EXISTS `collection` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` varchar(50) collate latin1_general_cs NOT NULL,
  `char_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs AUTO_INCREMENT=1 ;

--
-- Dump dei dati per la tabella `collection`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` varchar(50) collate latin1_general_cs NOT NULL,
  `name` varchar(50) collate latin1_general_cs NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

--
-- Dump dei dati per la tabella `user`
--

INSERT INTO `user` (`id`, `name`) VALUES
('U55555', 'Vito'),
('U66666', 'Caio'),
('6397D24E-299F-594E-BEE1-C1BBEA6C0B9E', 'Pino');
