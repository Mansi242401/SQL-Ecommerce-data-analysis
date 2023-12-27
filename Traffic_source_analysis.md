# Traffic Source Analysis

Traffic source analysis refers to the process of examining and understanding the various channels through which users or visitors arrive at a particular website, application, or online platform. The goal is to identify and assess the origins of web traffic to gain insights into user behavior, marketing effectiveness, and overall performance. This analysis is crucial for optimizing digital marketing strategies, enhancing user experience, and making informed decisions to drive business objectives

However, with our analysis, we will understand the following :
1. Where our customers are coming from (Email, Social Media, Search and Direct Traffic) and
2. Which channels are driving the highest quality traffic (CVR - Conversion Rate)

## Stakeholder Requests <br>

**1.(a) Site traffic breadkdown**<br>
<br>
Date of request : April 12,2012 <br>
By: CEO <br>

We have been live for almost a month now and we are starting to generate sales. Help me understand where the bulk of our website sessions are coming from, through yesterday?
I would like to see a breakdown by **UTM source, campaign and referring domain** if possible.

**SQL QUERY**
```sql
SELECT 
utm_source, 
utm_campaign, 
http_referer, 
COUNT(DISTINCT website_session_id) as num_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12'
GROUP BY 1,2,3
ORDER BY num_of_sessions DESC;

```
**Result**
<br>
| utm_source | utm_campaign | http_referer                | num_of_sessions |
|------------|--------------|-----------------------------|------------------|
| gsearch    | nonbrand     | https://www.gsearch.com     | 3613             |
| NULL       | NULL         | NULL                        | 28               |
| NULL       | NULL         | https://www.gsearch.com     | 27               |
| gsearch    | brand        | https://www.gsearch.com     | 26               |
| NULL       | NULL         | https://www.bsearch.com     | 7                |
| bsearch    | brand        | https://www.bsearch.com     | 7                |


Based on above result, it's obvious that majority website sessions are coming from gsearch non-brand segment. On sharing these results with the stakeholder, there is a counter request as under :

**1.(b) Deep dive - Site traffic breakdown** <br> (CEO's response)
<br>
Date : April 12, 2012 <br>
By : CEO <br>

Based on your findings, it seems we should probably dig into **gsearch nonbrand** abit deeper to see what we can do to optimize there.
I will loop in stakeholder 2 tomorrow morning to get his thoughts on next steps.

**2. Gsearch Conversion Rate**  <br>
<br>
Date of request : April 14,2012  <br>
By: Marketing Director <br>

Sounds like gsearch nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Could you please calculate the **conversion rate(CVR) from session to order?**
Based on what we are paying for clicks we will need a CVR of atleast 4% to make the numbers work.

If we are much lower, we need to reduce the bids. If we are higher, we can increase bids to drive more volume.

**SQL QUERY**
```sql
SELECT 
COUNT(DISTINCT ws.website_session_id) as sessions,
COUNT(DISTINCT o.order_id) as orders,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) as session_to_order_conversion_rate 
FROM website_sessions ws
LEFT JOIN
orders o
ON ws.website_session_id = o.website_session_id
WHERE ws.utm_source = 'gsearch' AND ws.utm_campaign = 'nonbrand' and ws.created_at < '2012-04-14';

```
**Result**
<br>

| sessions | orders | session_to_order_conversion_rate |
|----------|--------|---------------------------------|
| 3895     | 112    | 0.0288                          |

Since, the conversion rate is at 2.88% which is lower than 4%, the stakeholders may reduce the bids.

###  Bid Optmization

Analyzing for bid optmization is about understanding the value of various segments of paid traffic, so that you can optiimize your marketing budget.

**3. Gsearch Volume Trends** <br>
<br>
Date of request: May 10,2012 <br>
By :  Marketing Director

Based on your conversion rate analysis, we bid down gsearch nonbrand on 2012-04-15.
Can you pull **gsearch nonbrand trended session volume, by week** to see if the bid changes has caused volume to drop at all ?

**SQL QUERY**
```sql
SELECT
YEAR(ws.created_at) as year,
WEEK(ws.created_at) as week,
MIN(ws.created_at) as first_day_of_week,
COUNT(DISTINCT ws.website_session_id) as session_volume
FROM website_sessions ws 
WHERE ws.utm_source = 'gsearch' AND ws.utm_campaign = 'nonbrand' and ws.created_at < '2012-05-10'
GROUP BY 1,2;
```
**Result**
<br>

| year | week | first_day_of_week       | session_volume |
|------|------|--------------------------|-----------------|
| 2012 | 12   | 2012-03-19 08:04:16     | 896             |
| 2012 | 13   | 2012-03-25 01:00:54     | 956             |
| 2012 | 14   | 2012-04-01 00:24:09     | 1152            |
| 2012 | 15   | 2012-04-08 00:38:30     | 983             |
| 2012 | 16   | 2012-04-15 00:07:13     | 621             |
| 2012 | 17   | 2012-04-22 00:08:47     | 594             |
| 2012 | 18   | 2012-04-29 00:50:42     | 681             |
| 2012 | 19   | 2012-05-06 01:14:30     | 399             |

We observe that the session volume weekly count is lower post bidding down gsearch nonbrand on 2012-04-15.


**3b. RE: Gsearch Volume Trends**(Marketing Director's Response)

Okay, based on this it looks like gsearch nonbrand is fairly sensitive to bid changes.

We want maximum volume, but don't want to spend more on ads than we can afford.
Let me think on this. I will follow up with some ideas.

**4.a) GSearch Device Level Performance** <br>

Date of request : May 11,2012 <br>
By :  Marketing Director <br>

I as trying to use our website on mobile the other day and the experience was not that great.
Could you pull **conversion rates from session to order** by **device type**?

If desktop performance is better than on mobile, we may be able to bid up for desktop specifically to get more volume

**SQL QUERY:**

```sql
SELECT
ws.device_type as device, 
COUNT(DISTINCT ws.website_session_id) as sessions,
COUNT(DISTINCT o.order_id) as orders,
COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) as session_to_order_conversion_rate 
FROM website_sessions ws
LEFT JOIN
orders o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-05-11'
GROUP BY 1;
```

**Results:** <br>

| device  | sessions | orders | session_to_order_conversion_rate |
|---------|----------|--------|--------------------------------- |
| desktop | 4171     | 161    | 0.0386                           |
| mobile  | 2622     | 28     | 0.0107                           |

The conversion rate is clearly higher when desktop is used to access the website.

**4.b) RE:GSearch Device Level Performance** (Marketinig Director's Response)

Date of Request : May 11, 2012 <br>
By: Marketing Director <br>

I am going to increase our bids on desktop. 
When we bid higher, we will rank higher in the auctions. So i think your insights here should lead to a sales boost.

**5. Gsearch device level trends** (Marketing Director's response)
Date : June 19,2012 <br>
By :  Marketing Director<br>

After your device-level analysis of conversion rates, we realized desktop was doing well, so we bid our **gsearch nonbrand desktop campaigns** up on 2012-05-19.

Could you pull **weekly trends for both desktop and mobile** so we can see the impact on volume?

We can use 2012-04-15 until the bid change as a baseline.

**SQL QUERY:**

```sql

SELECT
MIN(ws.created_at) as first_day_of_week,
COUNT(CASE WHEN ws.device_type = 'desktop' THEN ws.website_session_id ELSE NULL END) as dtop_sessions,
COUNT(CASE WHEN ws.device_type = 'mobile' THEN ws.website_session_id ELSE NULL END) as mob_sessions
FROM website_sessions ws
LEFT JOIN
orders o
ON ws.website_session_id = o.website_session_id
WHERE ws.created_at < '2012-06-09' AND ws.created_at > '2012-04-15'
GROUP BY YEAR(ws.created_at),WEEK(ws.created_at);

```

**Results:**

| first_day_of_week       | dtop_sessions | mob_sessions |
|--------------------------|---------------|--------------|
| 2012-04-15 00:07:13     | 418           | 261          |
| 2012-04-22 00:08:47     | 400           | 255          |
| 2012-04-29 00:50:42     | 492           | 278          |
| 2012-05-06 01:14:30     | 489           | 309          |
| 2012-05-13 00:54:12     | 453           | 253          |
| 2012-05-20 00:43:31     | 729           | 236          |
| 2012-05-27 00:05:26     | 646           | 229          |
| 2012-06-03 00:43:23     | 654           | 200          |



   
