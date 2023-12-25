# Traffc Source Analysis

Traffic source analysis refers to the process of examining and understanding the various channels through which users or visitors arrive at a particular website, application, or online platform. The goal is to identify and assess the origins of web traffic to gain insights into user behavior, marketing effectiveness, and overall performance. This analysis is crucial for optimizing digital marketing strategies, enhancing user experience, and making informed decisions to drive business objectives

However, with our analysis, we will understand the following :
1. Where our customers are coming from (Email, Social Media, Search and Direct Traffic) and
2. Which channels are driving the highest quality traffic (CVR - Conversion Rate)

## Stakeholder Request 

Date of request : April 12,2012
**1. Site traffic breadkdown**

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



   
   
