## Top page Analysis

Top page analysis in website performance analysis involves identifying and analyzing the key pages on a website that significantly contribute to overall performance and user engagement. It helps businesses and website owners understand which pages are most visited, have the highest conversion rates, or contribute the most to user interactions. This analysis is crucial for optimizing user experience, marketing strategies, and overall website performance

## Stakeholder Requests

### 1. Top Website Pages <br>
By:  Website Manager <br>
Date : June 09, 2012

Could you help me get my head around the website by pulling the most-viewed website pages, ranked by session volume?

**QUERY:**


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

**QUERY:**

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

| lending_page_url | sessions_hitting_page |
|------------------|-----------------------|
| /home            | 10714                 |

Looks like our traffic all comes through our homepage right now.

**2.b) Website Manager's Response**

Wow, looks like our traffic all comes in through the homepage right now.
Seems pretty obvious where we should focus on making any improvements.
I will likely have some follow up requests to look into performance for the home page - stay tuned.



