
## Problem Statement

The website has been live for 8 months, and CEO wants to present the company's performance metrics to the board, hence metrics need to be created showing how the company is growing and how that growth is being generated.

## Proposed Solution
Based on the CEO's request, we shall follow the following approach :
1. We will be presenting monthly trends for all website channels and orders
2. Next, we will show the orders earned from landing page test
3. Then, we show the conversion funnel from two landing pages to orders
4. Then, we analyze the impact of billing test in terms of revenue per billing page session.

## Summarized Findings 

The results indicate increasing conversion rates over time, higher conversion rates for desktop sessions compared to mobile sessions, increasing brand orders and a significant lift in revenue per billing page session due to the billing test. The overall impact of the new billing page for the last month was estimated at $10,152.43.
   
## CEO's Request on Nov 27, 2012

From previous results, it is clear that majority traffic is coming from gsearch source. 
1. Find monthly trends for gsearch sessions and orders so that we can showcase the growth there.

```sql

SELECT
YEAR(website_sessions.created_at) AS yr,
MONTH(website_sessions.created_at) AS month,
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conversion_rate
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
AND website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;
```
**Results:**

| yr   | month | sessions | orders | conversion_rate |
|------|-------|----------|--------|------------------|
| 2012 | 3     | 1860     | 60     | 0.0323           |
| 2012 | 4     | 3574     | 92     | 0.0257           |
| 2012 | 5     | 3410     | 97     | 0.0284           |
| 2012 | 6     | 3578     | 121    | 0.0338           |
| 2012 | 7     | 3811     | 145    | 0.0380           |
| 2012 | 8     | 4877     | 184    | 0.0377           |
| 2012 | 9     | 4491     | 188    | 0.0419           |
| 2012 | 10    | 5534     | 234    | 0.0423           |
| 2012 | 11    | 8889     | 373    | 0.0420           |

We can clearly observe from above results that conversion rate is growing with time. <br>

2. Next, it would be great to see the monthly trend of gsearch split by brand and nonbrand to find out if brand is picking up at all.

```sql

SELECT
YEAR(website_sessions.created_at) AS yr,
MONTH(website_sessions.created_at) AS month,
COUNT(CASE WHEN website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as nonbrand_sessions,
COUNT(CASE WHEN website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS brand_sessions,
COUNT(CASE WHEN website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) AS nonbrand_orders,
COUNT(CASE WHEN website_sessions.utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) AS brand_orders
FROM
website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
AND website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;

```
**Results:**

| yr   | month | nonbrand_sessions | brand_sessions | nonbrand_orders | brand_orders |
|------|-------|-------------------|----------------|------------------|--------------|
| 2012 | 3     | 1852              | 8              | 60               | 0            |
| 2012 | 4     | 3509              | 65             | 86               | 6            |
| 2012 | 5     | 3295              | 115            | 91               | 6            |
| 2012 | 6     | 3439              | 139            | 114              | 7            |
| 2012 | 7     | 3660              | 151            | 136              | 9            |
| 2012 | 8     | 4673              | 204            | 174              | 10           |
| 2012 | 9     | 4227              | 264            | 172              | 16           |
| 2012 | 10    | 5197              | 337            | 219              | 15           |
| 2012 | 11    | 8506              | 383            | 356              | 17           |

Brand orders have also increased over time which is a good sign for its performance. <br>

3. For gsearch nonbrand category, pull monthly sessions and orders split by device type.

```sql
--First, we will find the distinct device type using below query

SELECT
distinct device_type
FROM website_sessions;

--The above query gives us results as 'desktop and mobile'
-- Next, we will find out 
SELECT
YEAR(website_sessions.created_at) AS yr,
MONTH(website_sessions.created_at) AS month,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) as mobile_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS desktop_sessions,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders,
COUNT(CASE WHEN website_sessions.device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
COUNT(CASE WHEN website_sessions.device_type = 'mobile' THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS conversion_rate_mobile,
COUNT(CASE WHEN website_sessions.device_type = 'desktop' THEN orders.order_id ELSE NULL END)/COUNT(CASE WHEN website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) AS conversion_rate_desktop
FROM
website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
AND website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;

```
**Results:**

| yr   | month | mobile_sessions | desktop_sessions | mobile_orders | desktop_orders | conversion_rate_mobile | conversion_rate_desktop |
|------|-------|------------------|-------------------|---------------|-----------------|------------------------|--------------------------|
| 2012 | 3     | 727              | 1133              | 10            | 50              | 0.0138                 | 0.0441                   |
| 2012 | 4     | 1393             | 2181              | 12            | 80              | 0.0086                 | 0.0367                   |
| 2012 | 5     | 1062             | 2348              | 10            | 87              | 0.0094                 | 0.0371                   |
| 2012 | 6     | 817              | 2761              | 8             | 113             | 0.0098                 | 0.0409                   |
| 2012 | 7     | 955              | 2856              | 15            | 130             | 0.0157                 | 0.0455                   |
| 2012 | 8     | 1238             | 3639              | 10            | 174             | 0.0081                 | 0.0478                   |
| 2012 | 9     | 1166             | 3325              | 19            | 169             | 0.0163                 | 0.0508                   |
| 2012 | 10    | 1386             | 4148              | 21            | 213             | 0.0152                 | 0.0514                   |
| 2012 | 11    | 2211             | 6678              | 37            | 336             | 0.0167                 | 0.0503                   |

It is clear from the above result that conversion rate is higher for desktop. However, the overal trend for both mobile and desktop is increasing over the 8 months period.

4. Also, apart from gsearch show monthly trend for each of other website channels <br>
  For this one we would first need to find the various channels that can be used to reach the website
**QUERY:**

```sql

SELECT
DISTINCT utm_source as traffic source,
utm_campaign as campaign,
utm_content,
http_referer
FROM website_sessions
WHERE created_at < '2012-11-27';

-- From the above query, we learn that there are four categories of channels as under:
-- 1. gsearch paid
-- 2. bsearch paid
-- 3. direct_type_in
-- 4. organic_search

-- Next we will find out the monthly trend for each of the above channels

SELECT
YEAR(website_sessions.created_at) AS yr,
MONTH(website_sessions.created_at) AS month,
COUNT(CASE WHEN website_sessions.utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS gsearch_paid_sessions,
COUNT(CASE WHEN website_sessions.utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS bsearch_paid_sessions,
COUNT(CASE WHEN website_sessions.utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_type_in_sessions,
COUNT(CASE WHEN website_sessions.utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_search_sessions
FROM
website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE 
website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;

```
**Result:**

| yr   | month | gsearch_paid_sessions | bsearch_paid_sessions | direct_type_in_sessions | organic_search_sessions |
|------|-------|------------------------|------------------------|--------------------------|--------------------------|
| 2012 | 3     | 1860                   | 2                      | 9                        | 8                        |
| 2012 | 4     | 3574                   | 11                     | 71                       | 78                       |
| 2012 | 5     | 3410                   | 25                     | 151                      | 150                      |
| 2012 | 6     | 3578                   | 25                     | 170                      | 190                      |
| 2012 | 7     | 3811                   | 44                     | 187                      | 207                      |
| 2012 | 8     | 4877                   | 705                    | 250                      | 265                      |
| 2012 | 9     | 4491                   | 1439                   | 285                      | 331                      |
| 2012 | 10    | 5534                   | 1781                   | 440                      | 428                      |
| 2012 | 11    | 8889                   | 2840                   | 485                      | 536                      |

The paid sessions are higher as compared to the unpaid search. However, they come with Customer Acquisition Cost (CAC) 

5. find session to order conversion rate by month

**QUERY:** <br>

```sql

SELECT
YEAR(website_sessions.created_at) AS yr,
MONTH(website_sessions.created_at) AS mnth,
COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
COUNT(DISTINCT orders.order_id) AS orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM 
website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;

```
**Results:**

| yr   | mnth | sessions | orders | conv_rate |
|------|------|----------|--------|-----------|
| 2012 | 3    | 1879     | 60     | 0.0319    |
| 2012 | 4    | 3734     | 99     | 0.0265    |
| 2012 | 5    | 3736     | 108    | 0.0289    |
| 2012 | 6    | 3963     | 140    | 0.0353    |
| 2012 | 7    | 4249     | 169    | 0.0398    |
| 2012 | 8    | 6097     | 228    | 0.0374    |
| 2012 | 9    | 6546     | 287    | 0.0438    |
| 2012 | 10   | 8183     | 371    | 0.0453    |
| 2012 | 11   | 12750    | 561    | 0.0440    |


6. For gsearch lander test, please **estimate the orders that test earned us**

```sql

SELECT 
MIN(website_pageview_id) as pageview_id,
MIN(created_at)
FROM 
website_pageviews
WHERE pageview_url = '/lander-1';

-- the first pageview_id is 23504 and date is June 19,2012
-- The below query would give us the first pageview id for each website_session. This is required to get the pageview_id of the landing page and we are filtering the same by date, first time the /lander-1 page was launched, gsearch and nonbrand category. We shall save the results in a temporary table named session_wise_first_pageview

CREATE TEMPORARY TABLE session_wise_first_pageview
SELECT website_pageviews.website_session_id,
MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM
website_pageviews
INNER JOIN website_sessions
ON website_pageviews.website_session_id = website_sessions.website_session_id
AND website_sessions.created_at < '2012-07-28' -- based on the period for which the test was run
AND website_pageviews.website_pageview_id > 23504
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;
```
**Result:**

| Session ID | Pageview ID |
|------------|-------------|
| 11684      | 23505       |
| 11685      | 23506       |
| 11686      | 23507       |
| 11687      | 23509       |
| 11688      | 23510       |
| 11689      | 23511       |
| 11690      | 23514       |
| 11691      | 23515       |
| 11692      | 23517       |
| 11693      | 23518       |
| 11694      | 23521       |
| 11696      | 23526       |
| 11697      | 23527       |
| 11698      | 23528       |
| 11699      | 23529       |
| 11700      | 23531       |

The above data actually contains 4576 rows, however i have included only first few and last few rows due to limitation on uploading the entire data on github. 

```sql

-- next, we will get the urls for the above pageview ids limiting it to '/lander-1' and '/home' and save it in a temp table named 'test_session_with_landing_page'

CREATE TEMPORARY TABLE test_session_with_landing_page
SELECT 
session_wise_first_pageview.website_session_id,
website_pageviews.pageview_url as landing_page
FROM 
session_wise_first_pageview
	LEFT JOIN website_pageviews
    ON session_wise_first_pageview.min_pageview_id = website_pageviews.website_pageview_id
    WHERE website_pageviews.pageview_url IN ('/home', '/lander-1');

```

**Result:**

| website_session_id | landing_page |
|--------------------|--------------|
| 11684              | /home        |
| 11685              | /lander-1    |
| 11686              | /lander-1    |
| 11687              | /home        |
| 11688              | /home        |
| 11689              | /lander-1    |
| 11690              | /home        |
| 11691              | /lander-1    |
| 11692              | /lander-1    |
| 11693              | /lander-1    |
| 11694              | /lander-1    |
| 11696              | /home        |
| 11697              | /lander-1    |
| 11698              | /lander-1    |
| 11699              | /lander-1    |
| 11700              | /home        |
| 11701              | /lander-1    |
| 11702              | /lander-1    |
| 11704              | /lander-1    |
| 11705              | /home        |
| 11706              | /home        |
| 11707              | /lander-1    |
| 11708              | /lander-1    |
| 11710              | /lander-1    |
| 11711              | /lander-1    |
| 11713              | /lander-1    |
| 11714              | /lander-1    |
| 11715              | /lander-1    |
| 11716              | /home        |
| 11717              | /home        |
| 11718              | /lander-1    |
| 11720              | /home        |
| 11723              | /home        |
| 16968              | /home        |
| 16969              | /home        |
| 16971              | /home        |
| 16972              | /lander-1    |
| 16974              | /home        |
| 16975              | /home        |
| 16977              | /lander-1    |
| 16978              | /lander-1    |
| 16979              | /lander-1    |
| 16980              | /lander-1    |
| 16981              | /lander-1    |
| 16982              | /lander-1    |
| 16983              | /home        |
| 16984              | /home        |
| 16985              | /home        |
| 16986              | /lander-1    |
| 16987              | /lander-1    |
| 16988              | /lander-1    |
| 16989              | /lander-1    |
| 16990              | /home        |
| 16991              | /lander-1    |

The above result returned 4576 rows, however I have restricted it to only first few and last few rows.

```sql

-- next we will get the order_ids for these pageview urls and save it in a temp table named 'test_session_with_orders'

CREATE TEMPORARY TABLE test_session_with_orders
SELECT 
session_wise_first_pageview.website_session_id,
website_pageviews.pageview_url as landing_page
FROM 
session_wise_first_pageview
	LEFT JOIN website_pageviews
    ON session_wise_first_pageview.min_pageview_id = website_pageviews.website_pageview_id
    WHERE website_pageviews.pageview_url IN ('/home', '/lander-1');

```

**Result:**

| website_session_id | landing_page | order_id |
|--------------------|--------------|----------|
| 11684              | /home        | NULL     |
| 11685              | /lander-1    | NULL     |
| 11686              | /lander-1    | NULL     |
| 11687              | /home        | NULL     |
| 11688              | /home        | NULL     |
| 11689              | /lander-1    | NULL     |
| 11690              | /home        | NULL     |
| 11691              | /lander-1    | NULL     |
| 11692              | /lander-1    | NULL     |
| 11693              | /lander-1    | NULL     |
| 11694              | /lander-1    | NULL     |
| 11696              | /home        | NULL     |
| 11697              | /lander-1    | NULL     |
| 11698              | /lander-1    | NULL     |
| 11699              | /lander-1    | NULL     |
| 11700              | /home        | NULL     |
| 11701              | /lander-1    | NULL     |
| 11702              | /lander-1    | NULL     |
| 11704              | /lander-1    | NULL     |
| 11705              | /home        | NULL     |
| 11706              | /home        | NULL     |
| 11707              | /lander-1    | NULL     |
| 11708              | /lander-1    | NULL     |
| 11710              | /lander-1    | NULL     |
| 11711              | /lander-1    | NULL     |
| 11713              | /lander-1    | NULL     |
| 11714              | /lander-1    | NULL     |
| 11715              | /lander-1    | NULL     |
| 11716              | /home        | NULL     |
| 11717              | /home        | NULL     |
| 11718              | /lander-1    | NULL     |
| 11720              | /home        | NULL     |
| 11723              | /home        | NULL     |
| 11724              | /lander-1    | NULL     |
| 11725              | /lander-1    | NULL     |
| 11727              | /home        | NULL     |
| 11728              | /home        | NULL     |
| 11729              | /lander-1    | 350      |
| 11730              | /home        | NULL     |
| 11731              | /home        | NULL     |
| 11732              | /lander-1    | NULL     |
| 16958              | /home        | NULL     |
| 16959              | /lander-1    | NULL     |
| 16960              | /lander-1    | NULL     |
| 16961              | /home        | NULL     |
| 16962              | /home        | NULL     |
| 16964              | /home        | NULL     |
| 16965              | /home        | NULL     |
| 16967              | /home        | NULL     |
| 16968              | /home        | NULL     |
| 16969              | /home        | NULL     |
| 16971              | /home        | 557      |
| 16972              | /lander-1    | NULL     |
| 16974              | /home        | NULL     |
| 16975              | /home        | NULL     |
| 16977              | /lander-1    | NULL     |
| 16978              | /lander-1    | NULL     |
| 16979              | /lander-1    | NULL     |
| 16980              | /lander-1    | NULL     |
| 16981              | /lander-1    | NULL     |
| 16982              | /lander-1    | NULL     |
| 16983              | /home        | NULL     |
| 16984              | /home        | NULL     |
| 16985              | /home        | NULL     |
| 16986              | /lander-1    | NULL     |
| 16987              | /lander-1    | NULL     |
| 16988              | /lander-1    | NULL     |
| 16989              | /lander-1    | NULL     |
| 16990              | /home        | NULL     |
| 16991              | /lander-1    | NULL     |

The above result returned 4576 rows, however I have restricted it to only first few and last few rows.

```sql
-- next we will find the conversion rate for each /home and /lander-1 page to orders

SELECT 
landing_page,
COUNT(DISTINCT website_session_id) AS sessions,
COUNT(DISTINCT order_id) AS orders,
COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS conversion_rate
FROM
test_session_with_orders
GROUP BY 1;

```
**Result** <br>

| landing_page | sessions | orders | conversion_rate |
|--------------|----------|--------|------------------|
| /home        | 2261     | 72     | 0.0318           |
| /lander-1    | 2315     | 94     | 0.0406           |

CTR for /home is 0.0318 and /lander-1 is 0.0406. The difference bw these two landing pages is .0088

```sql

-- find the most recent pageview id for gsearch nonbrand category where traffic was sent to '/home'
SELECT 
MAX(website_pageviews.website_session_id) AS recent_home_ws_id
FROM
website_sessions
LEFT JOIN website_pageviews
ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
AND website_sessions.utm_campaign = 'nonbrand'
AND website_pageviews.pageview_url = '/home'
AND website_sessions.created_at < '2012-11-27';

-- the most recent website_session_id for /home page in gsearch nonbrand category is 17145
-- next, we find the total sessions after the last test

SELECT 
COUNT(website_session_id)
FROM website_sessions
WHERE created_at < '2012-11-27'
AND website_session_id > 17145
AND utm_source = 'gsearch'
AND utm_campaign = 'nonbrand';

-- There are total 22972 website sessions after the test. When we multiply the same by 0.0088 to get incremental conversion 
-- 22927 X .0088 = 201.76 since July 29,2012. From August 2012 to November 2012 (4 months), there are 202 extra orders i.e. 50 orders per month.The test earned us 50 extra orders per month.

```

7. for landing page test, show **full conversion funnel from each of the two pages to orders** (from june 19 to July 28)
For this part, we will first understand what are the pages for each funnel stage.

a. Landing Page ('/lander-1' and '/home'):
The journey begins on the homepage, where users explore a variety of products and get a sense of what the ecommerce platform has to offer. 
For this problem we are using two landing pages - '/lander-1' and '/home'. 

b. Product Listings (/products):
From landing page, Users navigate to the product listings, where they can browse through different categories, view product details, and find items of interest.

c. Product Details (/the-original-mr-fuzzy):
Upon finding a specific product, users click to view more details, including images, specifications, and customer reviews.

d. Shopping Cart (/cart):
The chosen products are added to the shopping cart, creating a virtual basket that holds the selected items for purchase.

e. Shipping Information (/shipping):
Users proceed to enter shipping information, providing details such as delivery address and preferred shipping method.

f. Billing Details (/billing):
Next, users enter billing information, ensuring a smooth and secure transaction process.

g. Order Confirmation (/thankyou-for-your-order):
The final stage involves a confirmation page, expressing gratitude for the order and providing essential details such as order number and estimated delivery date.

Then, we calculate the CTR for each of the above webpages.

```sql

SELECT 
CASE WHEN homepage_seen = 1 THEN 'homepage_seen'
WHEN lander1_seen = 1 THEN 'lander-1_seen'
ELSE 'oh.. wrong logic'
END AS landing_segment,
COUNT(DISTINCT CASE WHEN products_seen = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS landing_CTR,
COUNT(DISTINCT CASE WHEN fuzzy_seen = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN products_seen = 1 THEN website_session_id ELSE NULL END) AS products_CTR,
COUNT(DISTINCT CASE WHEN cart_seen = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN fuzzy_seen = 1 THEN website_session_id ELSE NULL END) AS fuzzy_CTR,
COUNT(DISTINCT CASE WHEN shipping_seen = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_seen = 1 THEN website_session_id ELSE NULL END) AS cart_CTR,
COUNT(DISTINCT CASE WHEN billing_seen = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_seen = 1 THEN website_session_id ELSE NULL END) AS shipping_CTR,
COUNT(DISTINCT CASE WHEN thankyou_seen = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_seen = 1 THEN website_session_id ELSE NULL END) AS billing_CTR
FROM flagged_session_stage
GROUP BY 1;

```

**Result:**

| Landing_segment | landing_CTR | products_CTR | fuzzy_CTR | cart_CTR | shipping_CTR | billing_CTR |
|----------------|-------------|--------------|-----------|----------|--------------|-------------|
| homepage_seen  | 0.4166      | 0.7261       | 0.4327    | 0.6757   | 0.8400       | 0.4286      |
| lander-1_seen  | 0.4676      | 0.7128       | 0.4508    | 0.6638   | 0.8528       | 0.4772      |


8. Quantify the impact of billing test. Analyze lift generated from the billing test(Sep 10 - Nov 10), in terms of **revenue per billing page session**, and then pull the billing page sessions for the past month to understand monthly impact.

```sql

SELECT
billing_version_seen,
COUNT(DISTINCT website_session_id) AS sessions,
SUM(price_usd)/COUNT(DISTINCT website_session_id) AS revenue_per_billing_page_seen
FROM
(SELECT website_pageviews.website_session_id,
website_pageviews.pageview_url as billing_version_seen,
orders.order_id,
orders.price_usd
FROM website_pageviews
LEFT JOIN orders 
ON website_pageviews.website_session_id = orders.website_session_id
WHERE website_pageviews.pageview_url IN ('/billing','/billing-2') 
AND website_pageviews.created_at > '2012-09-10' AND website_pageviews.created_at < '2012-11-10'
) AS billing_pageviews_order_data
GROUP BY 1;

```
| billing_version_seen | sessions | revenue_per_billing_page_seen |
|-----------------------|----------|-------------------------------|
| /billing              | 657      | 22.826484                     |
| /billing-2            | 654      | 31.339297                     |

There is a major lift in the revenue_per_billing from USD 22.83 to USD 31.34 from old billing to the new billing page which approx USD 8.51 lift.

-- next we find out the billing sessions in the last month and its impact

```sql

SELECT COUNT(website_session_id) AS billing_sessions_past_month
FROM website_pageviews 
WHERE website_pageviews.pageview_url IN ('/billing', '/billing-2')
AND created_at BETWEEN '2012-10-27' AND '2012-11-27'; -- past month

```

**Result** <br>

There are total 1193 sessions in the past one month and we know that each session has increased the revenues by USD 8 with the new billing page. Hence, overall impact of the new billing page is USD 1193 X 8.51 i.e. USD 10152.43 for the last month.



