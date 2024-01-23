## Channel Portfolio Management

Analyzing a portfolio of marketing channels is about **bidding efficiently and using data to maximize the effectiveness of your marketing budget.**

when business run paid marketing campaign, they obsess over performance and measure everything: how much they spend, how well traffic converts to sales.

**Paid traffic is tagged with tracking parameters which are appended to the URLs and allow us to tie website activity back to the specific traffic sources and campaigns**

Apart from analyzing where our website traffic is coming from, we can also understand user characteristics and behaviors

<b>For example</b>: we can see if a user is new to our website or a repeat visitor,
which types of device they used during the session(mobile or desktop)


## Stakeholder requests

1. By : Marketing Director
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

**Results:**

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


2. By: Marketing Director
   Date : Nov 30, 2012

   I would like to learn more about the **bsearch nonbrand** campaign. Could you pull **percentage of traffic coming on mobile** and **compare that to gsearch**
   **aggregate data from Aug 22, 2012 is good** No trending data is required at this point.

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
   


