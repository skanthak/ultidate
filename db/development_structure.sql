CREATE TABLE `events` (
  `id` int(11) NOT NULL auto_increment,
  `date` date NOT NULL default '0000-00-00',
  `title` varchar(100) NOT NULL default '',
  `description` text NOT NULL,
  `is_public` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `events_date_index` (`date`)
) TYPE=MyISAM;

CREATE TABLE `participants` (
  `id` int(11) NOT NULL auto_increment,
  `event_id` int(11) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `comments` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) TYPE=MyISAM;

CREATE TABLE `shirts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(80) default NULL,
  `size` varchar(4) default NULL,
  `gender` char(1) default NULL,
  `arms` tinyint(4) default NULL,
  `shirt_name` varchar(40) default NULL,
  `shirt_number` varchar(4) default NULL,
  `comment` text,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(80) default NULL,
  `password` varchar(40) default NULL,
  `is_admin` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

INSERT INTO schema_info (version) VALUES (2)