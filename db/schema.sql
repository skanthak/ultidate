CREATE TABLE `events` (
  `id` int(11) NOT NULL auto_increment,
  `date` date NOT NULL default '0000-00-00',
  `title` varchar(100) NOT NULL default '',
  `description` text NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `date` (`date`)
) TYPE=MyISAM;

CREATE TABLE `participants` (
  `id` int(11) NOT NULL auto_increment,
  `event_id` int(11) NOT NULL default '0',
  `name` varchar(100) NOT NULL default '',
  `email` varchar(100),
  `comments` text NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=MyISAM;

