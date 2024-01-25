
Analyzing branded or direct traffic is about **keeping a pulse on how well your brand is doing with consumers, and how well your brand drives business.**

What is **DIRECT TRAFFIC?**

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

   By: CEO
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

**Results:**

| yr   | mnth | brand | nonbrand | brand_prc_of_nonbrand | direct | direct_perc_of_nonbrand | organic | organic_perc_of_nonbrand |
|------|------|-------|----------|-----------------------|--------|--------------------------|---------|---------------------------|
| 2012 | 3    | 10    | 1852     | 0.0054                | 9      | 0.0049                   | 8       | 0.0043                    |
| 2012 | 4    | 76    | 3509     | 0.0217                | 71     | 0.0202                   | 78      | 0.0222                    |
| 2012 | 5    | 140   | 3295     | 0.0425                | 151    | 0.0458                   | 150     | 0.0455                    |
| 2012 | 6    | 164   | 3439     | 0.0477                | 170    | 0.0494                   | 190     | 0.0552                    |
| 2012 | 7    | 195   | 3660     | 0.0533                | 187    | 0.0511                   | 207     | 0.0566                    |
| 2012 | 8    | 264   | 5318     | 0.0496                | 250    | 0.0470                   | 265     | 0.0498                    |
| 2012 | 9    | 339   | 5591     | 0.0606                | 285    | 0.0510                   | 331     | 0.0592                    |
| 2012 | 10   | 432   | 6883     | 0.0628                | 440    | 0.0639                   | 428     | 0.0622                    |
| 2012 | 11   | 556   | 12260    | 0.0454                | 571    | 0.0466                   | 624     | 0.0509                    |
| 2012 | 12   | 464   | 6643     | 0.0698                | 482    | 0.0726                   | 492     | 0.0741                    |

It can be observed that brand, organic and direct search are growing and also as a percentage of nonbrand.

**CEO's response on above results:**

Looks like not only our brand, organic and direct traffic volumes growing, but they are growing as percentage of our paid traffic volume.


   
