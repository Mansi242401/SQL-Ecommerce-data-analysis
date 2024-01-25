
Analyzing branded or direct traffic is about **keeping a pulse on how well your brand is doing with consumers, and how well your brand drives business.**

1. What is **DIRECT TRAFFIC?**

**Direct traffic** refers to visitors who come directly to a website by typing the website's URL into their browser's address bar or using a bookmark. It includes people who are familiar with the brand or have visited the website before and choose to return directly. Direct traffic can also encompass visitors who click on a link in an email, PDF document, or any other non-browser application that doesn't pass referrer information.

For e-commerce companies, direct traffic is valuable because it often represents a loyal customer base or users who are already aware of the brand. Understanding and analyzing direct traffic can provide insights into brand awareness, customer loyalty, and the effectiveness of offline marketing efforts.

Here are some key aspects of how e-commerce companies use and analyze direct traffic:

### 1. Brand Recognition: 
A significant portion of direct traffic is attributed to users who are familiar with the brand. Companies invest in building a strong brand to increase direct traffic as a measure of brand recognition and recall.

### 2. Marketing Effectiveness: 
Monitoring changes in direct traffic over time can help e-commerce businesses assess the impact of various marketing campaigns, both online and offline. For example, a spike in direct traffic after a television advertising campaign may indicate its success.

### 3. Customer Loyalty: 
Repeat customers often access a website directly. Analyzing direct traffic can be a way to gauge customer loyalty and the effectiveness of customer retention strategies.

### 4. Offline Engagement: 
E-commerce companies with physical stores or offline marketing activities may see an increase in direct traffic when customers visit the website after interacting with the brand offline.

### 5. Promotions and Campaigns: 
Direct traffic can also be influenced by promotions, discounts, or specific campaigns run by the e-commerce company. Users may directly visit the website to take advantage of special offers.

To leverage direct traffic effectively, e-commerce businesses often use web analytics tools to track and analyze user behavior. This helps in making informed decisions about marketing strategies, user experience improvements, and overall brand management.

From our data, to find direct traffic :

1. We will put `utm_source` in `website_sessions` table as `NULL`, because anything with a value in `utm_source` gives us paid traffic.
2. For `http_referer`, if we see that it has `NULL` value, then it is a direct type-in i.e. users are directly typing our website in browser. If it is not `NULL`, we can call it an organic search. In the context of e-commerce, organic search is crucial for attracting potential customers who are actively searching for products or information related to the business.

## Stakeholder's Request

1. By: CEO
   Date: December 23, 2012

   A potential investor is asking if we are building any momentum with our brand or if we will need to keep relying on paid traffic.

   Could you pull **organic search, direct type in and paid brand search sessions by month** and show those sessions as a % of **paid search nonbrand**

   ```sql
   
SELECT 
YEAR(dte) AS yr,
MONTH(dte) AS mnth,
COUNT(DISTINCT CASE WHEN channel_group = 'paid brand' THEN website_session_id ELSE NULL END) AS brand,
COUNT(DISTINCT CASE WHEN channel_group = 'paid nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
COUNT(DISTINCT CASE WHEN channel_group = 'paid brand' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN channel_group = 'paid nonbrand' THEN website_session_id ELSE NULL END) AS brand_prc_of_nonbrand,
COUNT(DISTINCT CASE WHEN channel_group = 'direct type in' THEN website_session_id ELSE NULL END) AS direct,
COUNT(DISTINCT CASE WHEN channel_group = 'direct type in' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN channel_group = 'paid nonbrand' THEN website_session_id ELSE NULL END) AS direct_perc_of_nonbrand,
COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END) AS organic,
COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN channel_group = 'paid nonbrand' THEN website_session_id ELSE NULL END) AS organic_perc_of_nonbrand
FROM
(SELECT
website_session_id,
DATE(created_at) as dte,
CASE 
WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
WHEN utm_campaign = 'nonbrand' THEN 'paid nonbrand'
WHEN utm_campaign = 'brand' THEN 'paid brand'
WHEN utm_campaign IS NULL AND http_referer IS NULL THEN 'direct type in'
END AS channel_group
FROM website_sessions
WHERE created_at < '2012-12-23') as sessions_channel_grp
GROUP BY 1,2;

   ```

   
