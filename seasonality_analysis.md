## Analyzing Seasonality and Business Pattern

Seasonality and business patterns in the context of an e-commerce business refer to recurring trends, fluctuations, and behaviors that are influenced by specific seasons, events, or time periods throughout the year. These patterns often impact various aspects of an e-commerce operation, including sales, customer behavior, and marketing strategies. 
Here's a breakdown of the concept:

<br>1. Sales Fluctuations:<br>

* Holiday Seasons: E-commerce businesses often experience peaks in sales during holiday seasons such as Christmas, Thanksgiving, or Black Friday. Consumers tend to make more purchases during these periods due to promotions and festive offers.
* Back-to-School Season: For businesses that sell products related to education, there might be a surge in sales during back-to-school seasons.
* Seasonal Events: Products related to specific seasons (e.g., winter clothing, summer sports equipment) may witness varying demand throughout the year.

<br>2. Customer Behavior:<br>

* Buying Patterns: Consumer behavior can change based on seasons. For instance, customers may be more inclined to buy warm clothing in winter and swimwear in summer.
* Search Trends: The products customers search for can be influenced by seasons. For example, searches for sunscreen may increase in the summer.

<br>3. Marketing Strategies:<br>

* Promotions: E-commerce businesses often tailor their marketing campaigns to align with seasonal trends. This could include holiday-themed promotions, seasonal discounts, or special offers.
* Content Marketing: Content strategies may be adjusted to cater to seasonal interests and needs. For example, creating content around holiday gift guides.

<br> 4. Inventory Management:<br>

* Stock Planning: Businesses need to plan their inventory to meet the demands of different seasons. This involves anticipating which products will be popular during specific times of the year.
* Clearance Sales: Businesses may implement clearance sales at the end of a season to clear out remaining stock and make room for new seasonal items.

<br> 5. Customer Engagement:<br>

* Email Campaigns: E-commerce businesses may use email marketing to engage with customers based on seasonal events, sending out newsletters with relevant promotions or information.
* Personalization: Utilizing data on customer preferences and past purchases to personalize recommendations and offers in alignment with seasonal trends.

Understanding and adapting to these seasonal patterns is crucial for e-commerce businesses to optimize their operations, maximize sales opportunities, and enhance the overall customer experience. 

## Stakeholder's Request

### 1. Seasonality
By: CEO <br>
Date: January 2, 2013

2012 was a great year for us. As we continue to grow, we should **take a look at 2012's monthly and weekly volume patterns, to see if we can find any seasonal trends we should plan for in 2013.**

**If you can pull session volume and order volume**, that would be excellent. <br>

The below query is used to understand the seasonality for the year 2012.

   ```sql

   --monthly pattern of sessions and orders in 2012

   SELECT
   YEAR(ws.created_at) AS yr,
   MONTH(ws.created_at) AS mth,
   COUNT(DISTINCT ws.website_session_id) AS sessions,
   COUNT(DISTINCT o.website_session_id) AS orders
   FROM website_sessions ws
   LEFT JOIN orders o
   ON ws.website_session_id = orders.ws_id
   WHERE YEAR(ws.created_at) = '2012'
   GROUP BY 1,2;
   
   ```

**Results:**

| yr   | mth | sessions | orders |
|------|-----|----------|--------|
| 2012 | 3   | 1879     | 60     |
| 2012 | 4   | 3734     | 99     |
| 2012 | 5   | 3736     | 108    |
| 2012 | 6   | 3963     | 140    |
| 2012 | 7   | 4249     | 169    |
| 2012 | 8   | 6097     | 228    |
| 2012 | 9   | 6546     | 287    |
| 2012 | 10  | 8183     | 371    |
| 2012 | 11  | 14011    | 618    |
| 2012 | 12  | 10072    | 506    |


```sql

--weekly trend of total sessions and orders in 2012

  SELECT 
   MIN(DATE(ws.created_at)) AS week_start_date,
   COUNT(DISTINCT ws.website_session_id) AS sessions,
   COUNT(DISTINCT o.website_session_id) AS orders
   FROM website_sessions ws
   LEFT JOIN orders o
   ON ws.website_session_id = o.website_session_id
   WHERE YEAR(ws.created_at) = '2012'
   GROUP BY YEAR(ws.created_at), WEEK(ws.created_at);

```

**Results:**

| week_start_date | sessions | orders |
|-----------------|----------|--------|
| 2012-03-19      | 896      | 25     |
| 2012-03-25      | 983      | 35     |
| 2012-04-01      | 1193     | 29     |
| 2012-04-08      | 1029     | 28     |
| 2012-04-15      | 679      | 22     |
| 2012-04-22      | 655      | 18     |
| 2012-04-29      | 770      | 19     |
| 2012-05-06      | 798      | 17     |
| 2012-05-13      | 706      | 23     |
| 2012-05-20      | 965      | 28     |
| 2012-05-27      | 875      | 31     |
| 2012-06-03      | 920      | 34     |
| 2012-06-10      | 994      | 29     |
| 2012-06-17      | 966      | 37     |
| 2012-06-24      | 883      | 32     |
| 2012-07-01      | 892      | 30     |
| 2012-07-08      | 925      | 36     |
| 2012-07-15      | 987      | 47     |
| 2012-07-22      | 954      | 41     |
| 2012-07-29      | 1172     | 55     |
| 2012-08-05      | 1235     | 48     |
| 2012-08-12      | 1181     | 39     |
| 2012-08-19      | 1522     | 55     |
| 2012-08-26      | 1593     | 52     |
| 2012-09-02      | 1418     | 56     |
| 2012-09-09      | 1488     | 72     |
| 2012-09-16      | 1776     | 76     |
| 2012-09-23      | 1624     | 70     |
| 2012-09-30      | 1553     | 67     |
| 2012-10-07      | 1632     | 73     |
| 2012-10-14      | 1955     | 93     |
| 2012-10-21      | 2042     | 95     |
| 2012-10-28      | 1923     | 82     |
| 2012-11-04      | 2086     | 91     |
| 2012-11-11      | 1973     | 101    |
| 2012-11-18      | 5130     | 223    |
| 2012-11-25      | 4172     | 179    |
| 2012-12-02      | 2727     | 145    |
| 2012-12-09      | 2489     | 123    |
| 2012-12-16      | 2718     | 135    |
| 2012-12-23      | 1682     | 74     |
| 2012-12-30      | 309      | 21     |

**CEO's response**

By : CEO <br>
Date : January 2, 2012

This is great to see. Looks like we grew pretty steadily all year and saw significant volume around the holiday months(especially the weeks of black Friday and Cyber Monday)

We will want to keep this in mind in 2013 as we think about customer support and inventory management.


### 2. Business Pattern : Data for customer service
   By : CEO <br>
   Date : January 5, 2013

   We are considering adding live chat support to the website to improve our customer experience. Could you **analyze the avg website session volume, by hour of day and by day week,** so that we can staff appropriately.

   Let's avoid the holiday time period and use a date range of **Sep 15,2012 - Nov 15,2012**
   
```sql

   SELECT 
   hour(created_at) as hr,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 0 THEN website_session_id ELSE NULL END) as monday,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 1 THEN website_session_id ELSE NULL END) as tuesday,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 2 THEN website_session_id ELSE NULL END) as wednesday,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 3 THEN website_session_id ELSE NULL END) as thursday,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 4 THEN website_session_id ELSE NULL END) as friday,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 5 THEN website_session_id ELSE NULL END) as saturday,
   COUNT(DISTINCT CASE WHEN weekday(created_at) = 6 THEN website_session_id ELSE NULL END) as sunday
   FROM website_sessions
   WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
   GROUP BY 1;
```

**Results:**

| hr | monday | tuesday | wednesday | thursday | friday | saturday | sunday |
|----|--------|---------|-----------|----------|--------|----------|--------|
| 0  | 78     | 69      | 57        | 59       | 54     | 45       | 45     |
| 1  | 59     | 60      | 48        | 39       | 57     | 45       | 24     |
| 2  | 55     | 40      | 40        | 49       | 37     | 33       | 24     |
| 3  | 51     | 36      | 42        | 32       | 29     | 35       | 27     |
| 4  | 47     | 57      | 54        | 32       | 43     | 22       | 22     |
| 5  | 45     | 49      | 46        | 43       | 37     | 39       | 35     |
| 6  | 49     | 50      | 43        | 48       | 54     | 36       | 23     |
| 7  | 66     | 70      | 67        | 85       | 56     | 51       | 43     |
| 8  | 111    | 110     | 117       | 132      | 84     | 34       | 37     |
| 9  | 158    | 141     | 176       | 154      | 140    | 68       | 54     |
| 10 | 166    | 159     | 189       | 147      | 152    | 75       | 57     |
| 11 | 162    | 172     | 224       | 173      | 167    | 65       | 69     |
| 12 | 190    | 210     | 205       | 193      | 152    | 77       | 55     |
| 13 | 160    | 207     | 187       | 165      | 173    | 73       | 76     |
| 14 | 161    | 194     | 201       | 148      | 156    | 78       | 60     |
| 15 | 194    | 154     | 228       | 188      | 170    | 62       | 64     |
| 16 | 190    | 213     | 213       | 157      | 167    | 61       | 59     |
| 17 | 175    | 143     | 182       | 158      | 103    | 58       | 68     |
| 18 | 114    | 135     | 133       | 122      | 87     | 48       | 61     |
| 19 | 112    | 127     | 120       | 93       | 114    | 64       | 58     |
| 20 | 109    | 112     | 128       | 85       | 82     | 51       | 76     |
| 21 | 82     | 113     | 103       | 75       | 58     | 51       | 92     |
| 22 | 82     | 90      | 88        | 97       | 48     | 51       | 92     |
| 23 | 79     | 77      | 86        | 85       | 61     | 48       | 75     |




