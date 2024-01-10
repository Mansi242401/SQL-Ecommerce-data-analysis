
## Problem Statement

The website has been live for 8 months, and CEO wants to present the company's performance metrics to the board, hence metrics need to be created showing how to company is growing and how that growth is being generated.

## CEO's Request on Nov 27, 2012

From previous results, it is clear that majority traffic is coming from gsearch nonbrand source. 
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
AND wesbite_sessions.created_at < '2012-11-27'
GROUP BY 1,2;
```

2. Next, it would be great to see the monthly trend of gsearch split by brand and nonbrand to find out if brand is picking up at all.
4. For gsearch nonbrand category, pull monthly sessions and orders split by device type.
5. Also, apart from gsearch show monthly trend for each of other website channels
6. find session to order conversion rate by month
7. For gsearch lander test, please **estimate the revenue that test earned us**
8. for landing page test, show **full conversion funnel from each of the two pages to orders** (from june 19 to July 28)
9. Quantify the impact of billing test. Analyze lift generated from the billing test(Sep 10 - Nov 10), in terms of **revenue per billing page session**, and then pull the billing page sessions for the past month to understand monthly impact.
