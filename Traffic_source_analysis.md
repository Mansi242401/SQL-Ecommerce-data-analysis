# Traffic Source Analysis

Traffic source analysis refers to the process of examining and understanding the various channels through which users or visitors arrive at a particular website, application, or online platform. The goal is to identify and assess the origins of web traffic to gain insights into user behavior, marketing effectiveness, and overall performance. This analysis is crucial for optimizing digital marketing strategies, enhancing user experience, and making informed decisions to drive business objectives

However, with our analysis, we will understand the following :
1. Where our customers are coming from (Email, Social Media, Search and Direct Traffic) and
2. Which channels are driving the highest quality traffic (CVR - Conversion Rate)

## Stakeholder Requests <br>

**1.(a) Site traffic breadkdown**<br>
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

**1.(b) Deep dive - Site traffic breakdown** <br>
Date : April 12, 2012 <br>
By : CEO <br>

Based on your findings, it seems we should probably dig into **gsearch nonbrand** abit deeper to see what we can do to optimize there.
I will loop in stakeholder 2 tomorrow morning to get his thoughts on next steps.

**2. Gsearch Conversion Rate**  <br>
Date of request : April 14,2012  <br>
By: Marketing Manager <br>

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


   
   
