## Top page Analysis

Top page analysis in website performance analysis involves identifying and analyzing the key pages on a website that significantly contribute to overall performance and user engagement. It helps businesses and website owners understand which pages are most visited, have the highest conversion rates, or contribute the most to user interactions. This analysis is crucial for optimizing user experience, marketing strategies, and overall website performance

## Stakeholder Requests

### 1. Top Website Pages <br>
By:  Website Manager <br>
Date : June 09, 2012

Could you help me get my head around the website by pulling the most-viewed website pages, ranked by session volume?

**SQL QUERY:**


```sql

SELECT pageview_url, 
COUNT(DISTINCT website_pageview_id) AS session_count
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY session_count DESC;

```

**Result:**

| pageview_url                   | session_count |
|---------------------------------|---------------|
| /home                           | 10403         |
| /products                       | 4239          |
| /the-original-mr-fuzzy          | 3037          |
| /cart                           | 1306          |
| /shipping                       | 869           |
| /billing                        | 716           |
| /thank-you-for-your-order       | 306           |

**1.b) Website Manager's Response**

It definitely seems like **the homepage, the products page, and the Mr. Fuzzy page** get the bulk of our traffic. I would like to understand traffic patterns more.
I will follow up soon with a request to look at entry pages.

### 2. Top Entry Pages <br>
By: Website Manager <br>
Date: June 12, 2012

Would you be able to pull a list of top entry pages? I want to confirm where our users are hitting the site. If you could pull all entry pages and rank them on entry volume, that would be great.

**SQL QUERY:**

```sql
WITH CTE as 
(SELECT
website_pageview_id, 
website_session_id,
created_at,
RANK() OVER (PARTITION BY website_session_id ORDER BY created_at) AS session_rank, 
pageview_url 
FROM website_pageviews) 

SELECT pageview_url as landing_page,
COUNT(DISTINCT website_session_id) 
FROM CTE
WHERE CTE.session_rank = 1 AND CTE.created_at < '2012-06-12'
GROUP BY landing_page
;
```

**Result:**

| landing_page_url | sessions_hitting_page |
|------------------|-----------------------|
| /home            | 10714                 |

Looks like our traffic all comes through our homepage right now.

**2.b) Website Manager's Response**

Wow, looks like our traffic all comes in through the homepage right now.
Seems pretty obvious where we should focus on making any improvements.
I will likely have some follow up requests to look into performance for the home page - stay tuned.

## Landing Page Performance and Testing

Landing Page Analysis and Testing is about understanding the performance of your key landing page and then testing it to improve your results

### 3. Bounce Rate Analysis <br>
By : Website Manager <br>
Date : June 14, 2012

The other day you showed us that all our traffic is landing on the homepage right now.We should check how that landing page is performing.
Can you pull bounce rates for traffic landing on the homepage? I would like to see three numbers : **Sessions, Bounced Sessions and Percentage of sessions that bounced (aka Bounce Rate)**

**Solution:**
For this business ask, I have used two ways to calculate Bounce Rates : 
1. Using step by step approach. This approach breaks down the bigger problem into multiple steps. I have extensively used temp table for this

2. In the second method, i have used CTE(Common Table Expressions). This is more complex method and gets the solution in a single query.

Both solutions are valid, but Solution 1 might be more readable and easier to optimize due to its modular structure.<br>

**SQL QUERY:**
```sql
-- Method 1: 
-- finding first pageview id for relevant sessions 

CREATE TEMPORARY TABLE first_pv
SELECT website_session_id, 
MIN(website_pageview_id) AS first_pageview
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

-- identify landing page for each session
CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT website_pageviews.pageview_url AS landing_page_url,
first_pv.website_session_id AS sessions_hitting_page
FROM first_pv
LEFT JOIN website_pageviews
ON first_pv.first_pageview = website_pageviews.website_pageview_id
WHERE website_pageviews.pageview_url = '/home' ;-- since website manager asked for the only this extension, in case there are multiple landing pages we need to be specific

-- counting pageviews for each session and filtering that by condition where pageviews count is 1 for each session, meaning where users did not go to the next page after home page
CREATE TEMPORARY TABLE bounced_sessions
SELECT sessions_w_home_landing_page.sessions_hitting_page,
sessions_w_home_landing_page.landing_page_url,
COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM
sessions_w_home_landing_page
JOIN 
website_pageviews
ON sessions_w_home_landing_page.sessions_hitting_page = website_pageviews.website_session_id
GROUP BY sessions_w_home_landing_page.sessions_hitting_page, 
sessions_w_home_landing_page.landing_page_url
HAVING COUNT(website_pageviews.website_pageview_id) = 1;

-- finally, counting the total website sessions, bounced website sessions and bounce rate

SELECT 
COUNT(DISTINCT sessions_w_home_landing_page.sessions_hitting_page) as total_sessions,
COUNT(DISTINCT bounced_sessions.sessions_hitting_page) as bounced_sessions,
COUNT(DISTINCT bounced_sessions.sessions_hitting_page)/COUNT(DISTINCT sessions_w_home_landing_page.sessions_hitting_page) as bounce_rate
FROM sessions_w_home_landing_page
LEFT JOIN bounced_sessions
ON sessions_w_home_landing_page.sessions_hitting_page = bounced_sessions.sessions_hitting_page;

-- Method 2:
WITH CTE AS (
  SELECT
    website_pageview_id,
    website_session_id,
    created_at,
    RANK() OVER (PARTITION BY website_session_id ORDER BY created_at) AS session_rank,
    pageview_url 
  FROM
    website_pageviews
)

SELECT
  CTE.pageview_url AS landing_page_url,
  COUNT(DISTINCT CTE.website_session_id) AS total_sessions,
  COUNT(DISTINCT CASE WHEN CTE.session_rank = 1 AND NOT EXISTS (
    SELECT 1
    FROM CTE AS SecondPage
    WHERE SecondPage.website_session_id = CTE.website_session_id
      AND SecondPage.session_rank > 1
  ) THEN CTE.website_session_id END) AS bounced_sessions,
  ROUND(
    COUNT(DISTINCT CASE WHEN CTE.session_rank = 1 AND NOT EXISTS (
      SELECT 1
      FROM CTE AS SecondPage
      WHERE SecondPage.website_session_id = CTE.website_session_id
        AND SecondPage.session_rank > 1
    ) THEN CTE.website_session_id END) /
    COUNT(DISTINCT CTE.website_session_id) * 100,
    2
  ) AS bounce_rate
FROM
  CTE 
WHERE 
  CTE.created_at < '2012-06-14' and CTE.pageview_url = '/home'
GROUP BY
  CTE.pageview_url;

```

**Result:**
| total_sessions | bounced_sessions | bounce_rate |
| -------------- | ---------------- | ----------- |
| 11048          | 6538             | 0.5918      |


**3.b) Website Manager's Response**

Ouch, almost a 60% bounce rate. 
That's pretty high from my experience, especially for paid search, which should be high quality traffic.
I will put together a custom landing page for search, and set up an experiment to see if the new landing page does better. I will likely need your help analyzing the test once we get enough data to judge performance.

### 4. Analyze Landing Page tests <br>
By : Website Manager <br>
Date : July 28, 2012 <br>

Based on your bounce rate analysis, we ran a new custom landing page(**/lander-1**) in a  50/50 test against the homepage(**/home**) for our **gsearch non-brand** traffic.
can you **pull bounce rates for the two groups** so we can evaluate the new page? 
Make sure to look at the time period where **/lander-1** was getting the traffic so that it is a fair comparison.

**QUERY:** <br>

```sql

-- A/B Test
-- Steps:
-- 1. find out when the new page was launched
-- 2. find first_website_pageview_id for relevant sessions
-- 3. identifying the landing page for each session
-- 4. count pageviews for each session to identify bounces
-- 5. summarise total sessions and bounce rates, by landing page


-- 1. Finding the first instance of /lander-1 page to set the analysis timeframe

SELECT 
MIN(created_at) as first_created_at,
MIN(website_pageview_id) as first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1' and created_at < '2012-07-28';

-- first_pageview_id for /lander-1 is 23504

-- 2.  find first_website_pageview_id for relevant sessions and store them in a temp table - first_test_pageviews
CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
wp.website_session_id,
MIN(wp.website_pageview_id) as min_pageview_id
FROM website_pageviews wp
INNER JOIN website_sessions ws -- since we need to find for gsearch nonbrand 
ON wp.website_session_id = ws.website_session_id
WHERE ws.utm_source = 'gsearch' 
AND ws.utm_campaign = 'nonbrand'
AND ws.created_at < '2012-07-28'
AND wp.website_pageview_id > 23503
GROUP BY wp.website_session_id;
;

-- 3. Fetch the landing page url for each session and restricting it to only /home page and /lander-1 page

CREATE TEMPORARY TABLE non_brand_test_sessions_w_landing_page
SELECT ftp.website_session_id,
wp.pageview_url as landing_page
FROM first_test_pageviews ftp
LEFT JOIN website_pageviews wp
ON ftp.min_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url IN ('/home', '/lander-1');

-- 4. Count pageviews for each session and then find only the bounced sessions using 'having' clause

CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions
SELECT ts.website_session_id,
ts.landing_page,
COUNT(wp.website_pageview_id) AS count_of_pages_viewed
FROM website_pageviews wp
LEFT JOIN non_brand_test_sessions_w_landing_page ts
ON wp.website_session_id = ts.website_session_id
GROUP BY 1, 2
HAVING COUNT(wp.website_pageview_id)  = 1 ;

-- 5.Summarize total sessions, bounced sessions by landing page

SELECT 
non_brand_test_sessions_w_landing_page.landing_page,
COUNT(DISTINCT non_brand_test_sessions_w_landing_page.website_session_id
) AS total_sessions,
COUNT(DISTINCT 
nonbrand_test_bounced_sessions.website_session_id
) AS bounced_sessions,
COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id)/COUNT(DISTINCT non_brand_test_sessions_w_landing_page.website_session_id) AS bounce_rate
FROM non_brand_test_sessions_w_landing_page
LEFT JOIN nonbrand_test_bounced_sessions
ON non_brand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
GROUP BY 1
;

```
 **Results:**

 | landing_page | total_sessions | bounced_sessions | bounce_rate |
| ------------ | -------------- | ----------------- | ----------- |
| /home        | 2261           | 1319              | 0.5834      |
| /lander-1    | 2315           | 1232              | 0.5322      |

It looks like there is a slight fall in the bounce rate when lander-1 is used as a landing page. 

**4.b) Website Manager's Response:**

This is so great. It looks like custom lander has a lower bounce rate. Success!!

I will work with the Marketing Director to get campaigns updated so that all nonbrand paid traffic is pointing to the new page.

In a few weeks, i would like you to look at trends to make sure things have moved in the right direction.


### 5. Landing Page Trend Analysis <br>

By: Website Manager <br>
Date :  August 31, 2012 <br>

Could you pull the volume of **paid search nonbrand traffic landing on /home and /lander-1, trended weekly since June 1st.** I want to confirm tha traffic is all routed correctly.

Could you also **pull over overall paid search bounce rate trended weekly?** I want to make sure that lender change has improved the overall picture.

```sql

-- 1. finding the first website_pageview_id for relevant sessions alongwith the pageview counts
-- 2. identifying the sessions where landing pages are '/home' or '/lander-1'
-- 3. calculating weekly bounce rates for each landing page.

CREATE TEMPORARY TABLE first_pageview_sessionwise_w_pagecount
SELECT 
wp.website_session_id,
MIN(wp.website_pageview_id) as website_pageview_id,
COUNT(wp.website_pageview_id) as count_pageviews
FROM website_sessions ws
LEFT JOIN website_pageviews wp
ON wp.website_session_id = ws.website_session_id
WHERE wp.created_at >= '2012-06-01' and wp.created_at < '2012-08-31'
AND ws.utm_source = 'gsearch' 
AND ws.utm_campaign = 'nonbrand'
GROUP BY 1;


CREATE TEMPORARY TABLE session_count_w_lander_created_at
SELECT fps.website_session_id,
fps.website_pageview_id as first_pageview_id,
wp.pageview_url as first_pageview_url,
wp.created_at,
fps.count_pageviews
FROM first_pageview_sessionwise_w_pagecount fps
LEFT JOIN website_pageviews wp
ON fps.website_pageview_id = wp.website_pageview_id
WHERE wp.pageview_url IN ('/home', '/lander-1');


SELECT
YEAR(created_at) as s_year,
WEEK(created_at) as s_week,
MIN(DATE(created_at)) as week_start_date,
-- COUNT(DISTINCT website_session_id) As total_sessions,
-- COUNT(CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) AS bounced_sessions,
COUNT(CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) * 1.0 / COUNT(DISTINCT website_session_id) as bounce_rate,
COUNT(CASE WHEN first_pageview_url = '/home' THEN website_session_id ELSE NULL END) AS home_page_count,
COUNT(CASE WHEN first_pageview_url = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_page_count
FROM session_count_w_lander_created_at
GROUP BY 1,2;

```

**Results:**

| s_year | s_week | week_start_date | bounce_rate | home_page_count | lander_page_count |
| ------ | ------ | --------------- | ----------- | --------------- | ------------------ |
| 2012   | 22     | 2012-06-01      | 0.60571     | 175             | 0                  |
| 2012   | 23     | 2012-06-03      | 0.58712     | 792             | 0                  |
| 2012   | 24     | 2012-06-10      | 0.61600     | 875             | 0                  |
| 2012   | 25     | 2012-06-17      | 0.55819     | 492             | 350                |
| 2012   | 26     | 2012-06-24      | 0.58278     | 369             | 386                |
| 2012   | 27     | 2012-07-01      | 0.58205     | 392             | 388                |
| 2012   | 28     | 2012-07-08      | 0.56679     | 390             | 411                |
| 2012   | 29     | 2012-07-15      | 0.54235     | 429             | 421                |
| 2012   | 30     | 2012-07-22      | 0.51382     | 402             | 394                |
| 2012   | 31     | 2012-07-29      | 0.49708     | 33              | 995                |
| 2012   | 32     | 2012-08-05      | 0.53818     | 0               | 1087               |
| 2012   | 33     | 2012-08-12      | 0.51403     | 0               | 998                |
| 2012   | 34     | 2012-08-19      | 0.50099     | 0               | 1012               |
| 2012   | 35     | 2012-08-26      | 0.53902     | 0               | 833                |

As it can be observed that the bounce rates are much lower from 62% to 54% post complete paid traffic is pointing to the new landing page - '/lander-1'.
Let's see what is the response from Website Manager


**5.b) Website Manager's Response** <br>

This is great. Thank you !

Looks like both pages are getting traffic for a while and then we **fully switched over to the custom lander** , as intended and it looks like our **overall bounce rate has come down over time** nice !

I will do a full deep dive into our site and will follow up with asks.

## Analyzing and Testing Conversion Funnel

Conversion Funnel Analysis is about **understanding and optimizing each step of your user's experience on their journey toward purchasing your products**
for performing this analysis, we will look at each step in our conversion flow to see **how many customers drop off and how many continue on at each step**.
The KPI used for each page in the conversion flow is called the clickthrough rate(CTR) for that page.

### 6. Help Analyzing Conversion Funnel <br>
By: Website Manager <br>
Date: Sep 5, 2012

I would like to understand where we lose our gsearch vistors between the new /lander-1 page and placing an order. **can you build a full conversion funnel, analyzing how many customers make it to each step?**

Start with **/lander-1** and build the funnel all the way to our **thankyou page**. Please use data since **August 5th**

