

SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
  

CREATE SCHEMA ;
USE ;


-- Creating an empty shell for the table 'website_sessions'. We will populate it later. 


CREATE TABLE website_sessions (
  website_session_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  is_repeat_session SMALLINT UNSIGNED NOT NULL, 
  utm_source VARCHAR(12), 
  utm_campaign VARCHAR(20),
  utm_content VARCHAR(15), 
  device_type VARCHAR(15), 
  http_referer VARCHAR(30),
  PRIMARY KEY (website_session_id),
  KEY website_sessions_user_id (user_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;



-- Creating an empty shell for the table 'website_pageviews'. We will populate it later. 


CREATE TABLE website_pageviews (
  website_pageview_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  website_session_id BIGINT UNSIGNED NOT NULL,
  pageview_url VARCHAR(50) NOT NULL,
  PRIMARY KEY (website_pageview_id),
  KEY website_pageviews_website_session_id (website_session_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


-- Creating an empty shell for the table 'products'. We will populate it later. 


CREATE TABLE products (
  product_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  product_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (product_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;

-- Creating an empty shell for the table 'orders'. We will populate it later. 


CREATE TABLE orders (
  order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  website_session_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  primary_product_id SMALLINT UNSIGNED NOT NULL,
  items_purchased SMALLINT UNSIGNED NOT NULL,
  price_usd DECIMAL(6,2) NOT NULL,
  cogs_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_id),
  KEY orders_website_session_id (website_session_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Creating an empty shell for the table 'order_items'. We will populate it later. 
--

CREATE TABLE order_items (
  order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id SMALLINT UNSIGNED NOT NULL,
  is_primary_item SMALLINT UNSIGNED NOT NULL,
  price_usd DECIMAL(6,2) NOT NULL,
  cogs_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_item_id),
  KEY order_items_order_id (order_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Creating an empty shell for the table 'order_item_refunds'. We will populate it later. 
--

CREATE TABLE order_item_refunds (
  order_item_refund_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  order_item_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  refund_amount_usd DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (order_item_refund_id),
  KEY order_items_order_id (order_id),
  KEY order_items_order_item_id (order_item_id)
)ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;


--
-- Inserting the data for our website_sessions table. 
--

SET AUTOCOMMIT=0;
INSERT INTO website_sessions VALUES 
(1,'2012-03-19 08:04:16',1,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(2,'2012-03-19 08:16:49',2,0,'gsearch','nonbrand','g_ad_1','desktop','https://www.gsearch.com'),
(3,'2012-03-19 08:26:55',3,0,'gsearch','nonbrand','g_ad_1','desktop','https://www.gsearch.com'),
(4,'2012-03-19 08:37:33',4,0,'gsearch','nonbrand','g_ad_1','desktop','https://www.gsearch.com'),
(5,'2012-03-19 09:00:55',5,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(6,'2012-03-19 09:05:46',6,0,'gsearch','nonbrand','g_ad_1','desktop','https://www.gsearch.com'),
(7,'2012-03-19 09:06:27',7,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(8,'2012-03-19 09:17:17',8,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(9,'2012-03-19 09:27:56',9,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(10,'2012-03-19 09:35:37',10,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(11,'2012-03-19 09:37:42',11,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(12,'2012-03-19 09:39:57',12,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(472868,'2015-03-19 07:54:36',394315,0,'bsearch','nonbrand','b_ad_1','mobile','https://www.bsearch.com'),
(472869,'2015-03-19 07:55:40',394316,0,'gsearch','nonbrand','g_ad_1','mobile','https://www.gsearch.com'),
(472870,'2015-03-19 07:56:29',394317,0,'gsearch','nonbrand','g_ad_1','desktop','https://www.gsearch.com'),
(472871,'2015-03-19 07:59:08',394318,0,NULL,NULL,NULL,'mobile',NULL);
COMMIT;

--Inserting the data for our website_pageviews
SET AUTOCOMMIT=0;
INSERT INTO website_pageviews VALUES 
(1,'2012-03-19 08:04:16',1,'/home'),
(2,'2012-03-19 08:16:49',2,'/home'),
(3,'2012-03-19 08:26:55',3,'/home'),
(4,'2012-03-19 08:37:33',4,'/home'),
(5,'2012-03-19 09:00:55',5,'/home'),
(1188114,'2015-03-19 07:54:36',472868,'/lander-3'),
(1188115,'2015-03-19 07:55:03',472866,'/cart'),
(1188116,'2015-03-19 07:55:40',472869,'/lander-3'),
(1188117,'2015-03-19 07:55:57',472868,'/products'),
(1188118,'2015-03-19 07:56:29',472870,'/lander-5'),
(1188119,'2015-03-19 07:57:22',472870,'/products'),
(1188120,'2015-03-19 07:57:32',472866,'/shipping'),
(1188121,'2015-03-19 07:58:13',472870,'/the-original-mr-fuzzy'),
(1188122,'2015-03-19 07:59:07',472866,'/billing-2'),
(1188123,'2015-03-19 07:59:08',472871,'/home'),
(1188124,'2015-03-19 07:59:32',472868,'/the-original-mr-fuzzy');
COMMIT;

-- Inserting the data for our products table. 


SET AUTOCOMMIT=0;
INSERT INTO products VALUES 
(1,'2012-03-19 08:00:00','The Original Mr. Fuzzy'),
(2,'2013-01-06 13:00:00','The Forever Love Bear'),
(3,'2013-12-12 09:00:00','The Birthday Sugar Panda'),
(4,'2014-02-05 10:00:00','The Hudson River Mini bear');
COMMIT;

-- Inserting the data for our orders table. 

SET AUTOCOMMIT=0;
INSERT INTO orders VALUES 
(1,'2012-03-19 10:42:46',20,20,1,1,49.99,19.49),
(2,'2012-03-19 19:27:37',104,104,1,1,49.99,19.49),
(3,'2012-03-20 06:44:45',147,147,1,1,49.99,19.49),
(4,'2012-03-20 09:41:45',160,160,1,1,49.99,19.49),
(5,'2012-03-20 11:28:15',177,177,1,1,49.99,19.49),
(6,'2012-03-20 16:12:47',232,232,1,1,49.99,19.49),
(7,'2012-03-20 17:03:41',241,241,1,1,49.99,19.49),
(8,'2012-03-20 23:35:27',295,295,1,1,49.99,19.49),
(9,'2012-03-21 02:35:01',304,304,1,1,49.99,19.49),
(10,'2012-03-21 06:45:58',317,317,1,1,49.99,19.49),
(11,'2012-03-21 07:28:02',321,321,1,1,49.99,19.49),
(32304,'2015-03-19 00:37:21',472730,394207,3,2,75.98,23.98),
(32305,'2015-03-19 01:04:35',472740,377958,1,1,49.99,19.49),
(32306,'2015-03-19 01:42:17',472754,365383,4,1,29.99,9.49),
(32307,'2015-03-19 01:51:39',472755,394226,3,1,45.99,14.49),
(32308,'2015-03-19 02:11:42',472761,394231,1,1,49.99,19.49),
(32309,'2015-03-19 03:58:12',472795,394255,1,1,49.99,19.49),
(32310,'2015-03-19 04:10:43',472798,394257,4,1,29.99,9.49),
(32311,'2015-03-19 05:27:28',472809,394268,2,2,89.98,31.98),
(32312,'2015-03-19 05:35:57',472814,394273,4,1,29.99,9.49),
(32313,'2015-03-19 05:38:31',472818,386000,1,1,49.99,19.49);
COMMIT;

-- Inserting the data for our order_items table. 


SET AUTOCOMMIT=0;
INSERT INTO order_items VALUES 
(1,'2012-03-19 10:42:46',1,1,1,49.99,19.49),
(2,'2012-03-19 19:27:37',2,1,1,49.99,19.49),
(3,'2012-03-20 06:44:45',3,1,1,49.99,19.49),
(4,'2012-03-20 09:41:45',4,1,1,49.99,19.49),
(5,'2012-03-20 11:28:15',5,1,1,49.99,19.49),
(6,'2012-03-20 16:12:47',6,1,1,49.99,19.49),
(7,'2012-03-20 17:03:41',7,1,1,49.99,19.49),
(40017,'2015-03-19 01:42:17',32306,4,1,29.99,9.49),
(40018,'2015-03-19 01:51:39',32307,3,1,45.99,14.49),
(40019,'2015-03-19 02:11:42',32308,1,1,49.99,19.49),
(40020,'2015-03-19 03:58:12',32309,1,1,49.99,19.49),
(40021,'2015-03-19 04:10:43',32310,4,1,29.99,9.49),
(40022,'2015-03-19 05:27:28',32311,2,1,59.99,22.49),
(40023,'2015-03-19 05:27:28',32311,4,0,29.99,9.49),
(40024,'2015-03-19 05:35:57',32312,4,1,29.99,9.49),
(40025,'2015-03-19 05:38:31',32313,1,1,49.99,19.49);

COMMIT;

-- Inserting the data for our order_item_refunds table. 


SET AUTOCOMMIT=0;
INSERT INTO order_item_refunds VALUES 
(1,'2012-04-06 11:32:43',57,57,49.99),
(2,'2012-04-13 01:09:43',74,74,49.99),
(3,'2012-04-15 07:03:48',71,71,49.99),
(1721,'2015-03-27 03:24:58',39680,32055,45.99),
(1722,'2015-03-27 10:10:53',39860,32191,49.99),
(1723,'2015-03-27 12:16:02',39674,32051,45.99),
(1724,'2015-03-28 05:34:49',39819,32156,45.99),
(1725,'2015-03-28 08:38:31',39449,31884,49.99),
(1726,'2015-03-29 23:41:36',39759,32111,49.99),
(1727,'2015-03-30 09:37:23',39950,32255,59.99),
(1728,'2015-03-30 21:33:51',39671,32049,49.99),
(1729,'2015-03-31 19:59:48',39729,32090,49.99),
(1730,'2015-04-01 03:54:48',39717,32079,59.99),
(1731,'2015-04-01 18:11:08',39947,32252,45.99);

COMMIT;
