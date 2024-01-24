## Channel Portfolio Management

Analyzing a portfolio of marketing channels is about **bidding efficiently and using data to maximize the effectiveness of your marketing budget.**

when business run paid marketing campaign, they obsess over performance and measure everything: how much they spend, how well traffic converts to sales.

**Paid traffic is tagged with tracking parameters which are appended to the URLs and allow us to tie website activity back to the specific traffic sources and campaigns**

Apart from analyzing where our website traffic is coming from, we can also understand user characteristics and behaviors

<b>For example</b>: we can see if a user is new to our website or a repeat visitor,
which types of device they used during the session(mobile or desktop)


## Stakeholder requests

1. By : Marketing Director <br>
   Date : Nov 29, 2012

With gsearch doing well and site performing better, **we launched a second paid search channel - bsearch** around August 22 can you pull weekly trended session volume since then and compare it to gsearch nonbrand so that we can understand how important it will be for the business <br>

```sql
   
   SELECT 
MIN(DATE(created_at)) AS first_day_of_week,
COUNT(CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
COUNT(CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-08-22' AND '2012-11-29'
AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);

```

**Results:** <br>

| first_day_of_week | gsearch_sessions | bsearch_sessions |
|-------------------|------------------|------------------|
| 2012-08-22        | 590              | 197              |
| 2012-08-26        | 1056             | 343              |
| 2012-09-02        | 925              | 290              |
| 2012-09-09        | 951              | 329              |
| 2012-09-16        | 1151             | 365              |
| 2012-09-23        | 1050             | 321              |
| 2012-09-30        | 999              | 316              |
| 2012-10-07        | 1002             | 330              |
| 2012-10-14        | 1257             | 420              |
| 2012-10-21        | 1302             | 431              |
| 2012-10-28        | 1211             | 384              |
| 2012-11-04        | 1350             | 429              |
| 2012-11-11        | 1246             | 438              |
| 2012-11-18        | 3508             | 1093             |
| 2012-11-25        | 2286             | 774              |


2. By: Marketing Director <br>
   Date : Nov 30, 2012

I would like to learn more about the **bsearch nonbrand** campaign. Could you pull **percentage of traffic coming on mobile** and **compare that to gsearch. Aggregate data from Aug 22, 2012 is good** No trending data is required at this point.

```sql

SELECT
utm_source,
COUNT(DISTINCT website_session_id) as total_sessions,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_mobile
FROM website_sessions
WHERE created_at BETWEEN '2012-08-22' AND '2012-11-30'
AND utm_campaign = 'nonbrand'
GROUP BY 1;

   ```
**Results:**

| utm_source | total_sessions | mobile_sessions | pct_mobile |
|------------|-----------------|------------------|------------|
| gsearch    | 20073           | 4921             | 0.2452     |
| bsearch    | 6522            | 562              | 0.0862     |

25% of the the total sessions are coming from mobile sessions for gsearch nonbrand segment and only 8.6 % is routing from mobile for bsearch nonbrand segment.
clearly gsearch moble traffic is higher.
   

3. By: Marketing Director <br>
   Date: Dec 1, 2012

I am wondering if bsearch nonbrand should have the same bids as gsearch. Could you pull **nonbrand conversion rates from sessions to orders for both gsearch and bsearch and slice the data by device type**. <br>
Please analyze data from aug 22 to Sep 18. We ran a special pre-holiday campaign for gsearch starting on september 19, so the data after that is not a fair game.

```sql

-- the very first thing to do here would be to find what are the different device types using the below query :

SELECT DISTINCT device_type FROM website_sessions;

-- above query returns -'mobile' and 'desktop'

-- next we will find the total session for nonbrand gsearch and bsearch and further break it by device type

SELECT
website_sessions.utm_source,
website_sessions.device_type,
COUNT(DISTINCT website_sessions.website_session_id) as total_sessions,
COUNT(DISTINCT orders.order_id) as total_orders,
COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) as cnv_rate
FROM website_sessions
LEFT JOIN orders ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-09-18'
AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2;

```

**Result:**

| utm_source | device_type | total_sessions | total_orders | cnv_rate |
|------------|-------------|-----------------|--------------|----------|
| bsearch    | desktop     | 1162            | 44           | 0.0379   |
| bsearch    | mobile      | 130             | 1            | 0.0077   |
| gsearch    | desktop     | 3011            | 136          | 0.0452   |
| gsearch    | mobile      | 1015            | 13           | 0.0128   |

we can see from the above results that conversion rates are higher for gsearch in both mobile and dekstop category as compared to bsearch. Hence, the ad spend on bsearch is not that effective as compared to gsearch. After sharing the above results with the Marketing Director, we get following response.

**Marketing Director's Response:**

As i suspected, the channels don't perform identically so we should **differentiate our bids** in order to optimize our overall paid marketing budget.
**I will bid down bsearch based on its underperformance.**

4. By: Marketing Director <br>
   Date: Decemeber 22, 2012 <br>
   
   Based on your last analysis, we bid down bsearch nonbrand on December 2.

   Can you pull weekly session volume for gsearch and bsearch nonbrand, broken down by device, since Nov 4th?
   If you can include a comparison metric to show bsearch as a percentage of gsearch for each device, that would be great too.


```sql
   
SELECT 
MIN(DATE(created_at)) as first_day_of_wk,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS gsearch_desktop_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS gsearch_mobile_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS bsearch_desktop_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS bsearch_mobile_sessions,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS bsearch_perc_desktop,
COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS bsearch_perc_mobile
FROM website_sessions
WHERE utm_campaign = 'nonbrand'
AND created_at BETWEEN '2012-11-04' AND '2012-12-23'
GROUP BY YEARWEEK(created_at);

```
**Results:**



| first_day_of_wk | gsearch_desktop_sessions | gsearch_mobile_sessions | bsearch_desktop_sessions | bsearch_mobile_sessions | bsearch_perc_desktop | bsearch_perc_mobile |
|------------------|--------------------------|--------------------------|---------------------------|--------------------------|-----------------------|-----------------------|
| 2012-11-04       | 1027                     | 323                      | 400                       | 29                       | 0.3895                | 0.0898                |
| 2012-11-11       | 956                      | 290                      | 401                       | 37                       | 0.4195                | 0.1276                |
| 2012-11-18       | 2655                     | 853                      | 1008                      | 85                       | 0.3797                | 0.0996                |
| 2012-11-25       | 2058                     | 692                      | 843                       | 62                       | 0.4096                | 0.0896                |
| 2012-12-02       | 1326                     | 396                      | 517                       | 31                       | 0.3899                | 0.0783                |
| 2012-12-09       | 1277                     | 424                      | 293                       | 46                       | 0.2294                | 0.1085                |
| 2012-12-16       | 1270                     | 376                      | 348                       | 41                       | 0.2740                | 0.1090                |




