
## Problem Statement

The website has been live for 8 months, and CEO wants to present the company's performance metrics to the board, hence metrics need to be created showing how to company is growing and how that growth is being generated.

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

| yr   | month | mobile_sessions | desktop_sessions | mobile_orders | desktop_orders |
|------|-------|------------------|-------------------|---------------|-----------------|
| 2012 | 3     | 727              | 1133              | 10            | 50              |
| 2012 | 4     | 1393             | 2181              | 12            | 80              |
| 2012 | 5     | 1062             | 2348              | 10            | 87              |
| 2012 | 6     | 817              | 2761              | 8             | 113             |
| 2012 | 7     | 955              | 2856              | 15            | 130             |
| 2012 | 8     | 1238             | 3639              | 10            | 174             |
| 2012 | 9     | 1166             | 3325              | 19            | 169             |
| 2012 | 10    | 1386             | 4148              | 21            | 213             |
| 2012 | 11    | 2211             | 6678              | 37            | 336             |


5. Also, apart from gsearch show monthly trend for each of other website channels
6. find session to order conversion rate by month
7. For gsearch lander test, please **estimate the revenue that test earned us**
8. for landing page test, show **full conversion funnel from each of the two pages to orders** (from june 19 to July 28)
9. Quantify the impact of billing test. Analyze lift generated from the billing test(Sep 10 - Nov 10), in terms of **revenue per billing page session**, and then pull the billing page sessions for the past month to understand monthly impact.
