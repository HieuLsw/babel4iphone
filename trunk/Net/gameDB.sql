-- phpMyAdmin SQL Dump
-- version 3.2.3
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generato il: 12 feb, 2010 at 04:25 PM
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
-- Struttura della tabella `character`
--

CREATE TABLE IF NOT EXISTS `character` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) collate latin1_general_cs NOT NULL,
  `race` varchar(50) collate latin1_general_cs NOT NULL,
  `atk` int(11) NOT NULL,
  `def` int(11) NOT NULL,
  `matk` int(11) NOT NULL,
  `mdef` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs AUTO_INCREMENT=3 ;

--
-- Dump dei dati per la tabella `character`
--

INSERT INTO `character` (`id`, `name`, `race`, `atk`, `def`, `matk`, `mdef`) VALUES
(1, 'Dan', 'Umano', 1000, 300, 100, 600),
(2, 'Bill', 'Umano', 700, 600, 50, 1000);

-- --------------------------------------------------------

--
-- Struttura della tabella `collection`
--

CREATE TABLE IF NOT EXISTS `collection` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` varchar(50) collate latin1_general_cs NOT NULL,
  `char_id` int(11) NOT NULL,
  `party` tinyint(1) NOT NULL default '0',
  `level` int(11) NOT NULL default '1',
  `exp` int(11) NOT NULL,
  `hp` int(11) NOT NULL default '10',
  `mp` int(11) NOT NULL default '5',
  `time` double NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs AUTO_INCREMENT=9 ;

--
-- Dump dei dati per la tabella `collection`
--

INSERT INTO `collection` (`id`, `user_id`, `char_id`, `party`, `level`, `exp`, `hp`, `mp`, `time`) VALUES
(1, 'U55555', 1, 1, 3, 0, 10, 5, 0),
(2, 'U55555', 2, 0, 1, 0, 10, 5, 0),
(3, 'U66666', 1, 1, 1, 0, 10, 5, 0),
(4, 'U66666', 2, 1, 2, 0, 10, 5, 0),
(5, '6397D24E-299F-594E-BEE1-C1BBEA6C0B9E', 1, 1, 1, 0, 10, 5, 0),
(6, '6397D24E-299F-594E-BEE1-C1BBEA6C0B9E', 2, 1, 2, 0, 10, 5, 0);

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
