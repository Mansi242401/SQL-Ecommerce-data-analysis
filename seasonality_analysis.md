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
   hr,
   ROUND(AVG(CASE WHEN wkday = 0 THEN website_sessions ELSE NULL END),1) AS monday,
   ROUND(AVG(CASE WHEN wkday = 1 THEN website_sessions ELSE NULL END),1) AS tuesday,
   ROUND(AVG(CASE WHEN wkday = 2 THEN website_sessions ELSE NULL END),1) AS wednesday,
   ROUND(AVG(CASE WHEN wkday = 3 THEN website_sessions ELSE NULL END),1) AS thursday,
   ROUND(AVG(CASE WHEN wkday = 4 THEN website_sessions ELSE NULL END),1) AS friday,
   ROUND(AVG(CASE WHEN wkday = 5 THEN website_sessions ELSE NULL END),1) AS saturday,
   ROUND(AVG(CASE WHEN wkday = 6 THEN website_sessions ELSE NULL END),1) AS sunday
   FROM
   (SELECT 
   date(created_at) as created_date,
   weekday(created_at) as wkday,
   hour(created_at) as hr,
   count(DISTINCT website_session_id) as website_sessions
   FROM website_sessions
   WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
   GROUP BY 1,2,3) AS daily_hourly_sessions
   GROUP BY 1;
```

**Results:**

| hr  | monday | tuesday | wednesday | thursday | friday | saturday | sunday |
|-----|--------|---------|-----------|----------|--------|----------|--------|
| 0   | 8.7    | 7.7     | 6.3       | 7.4      | 6.8    | 5.0      | 5.0    |
| 1   | 6.6    | 6.7     | 5.3       | 4.9      | 7.1    | 5.0      | 3.0    |
| 2   | 6.1    | 4.4     | 4.4       | 6.1      | 4.6    | 3.7      | 3.0    |
| 3   | 5.7    | 4.0     | 4.7       | 4.6      | 3.6    | 3.9      | 3.4    |
| 4   | 5.9    | 6.3     | 6.0       | 4.0      | 6.1    | 2.8      | 2.4    |
| 5   | 5.0    | 5.4     | 5.1       | 5.4      | 4.6    | 4.3      | 3.9    |
| 6   | 5.4    | 5.6     | 4.8       | 6.0      | 6.8    | 4.0      | 2.6    |
| 7   | 7.3    | 7.8     | 7.4       | 10.6     | 7.0    | 5.7      | 4.8    |
| 8   | 12.3   | 12.2    | 13.0      | 16.5     | 10.5   | 4.3      | 4.1    |
| 9   | 17.6   | 15.7    | 19.6      | 19.3     | 17.5   | 7.6      | 6.0    |
| 10  | 18.4   | 17.7    | 21.0      | 18.4     | 19.0   | 8.3      | 6.3    |
| 11  | 18.0   | 19.1    | 24.9      | 21.6     | 20.9   | 7.2      | 7.7    |
| 12  | 21.1   | 23.3    | 22.8      | 24.1     | 19.0   | 8.6      | 6.1    |
| 13  | 17.8   | 23.0    | 20.8      | 20.6     | 21.6   | 8.1      | 8.4    |
| 14  | 17.9   | 21.6    | 22.3      | 18.5     | 19.5   | 8.7      | 6.7    |
| 15  | 21.6   | 17.1    | 25.3      | 23.5     | 21.3   | 6.9      | 7.1    |
| 16  | 21.1   | 23.7    | 23.7      | 19.6     | 20.9   | 7.6      | 6.6    |
| 17  | 19.4   | 15.9    | 20.2      | 19.8     | 12.9   | 6.4      | 7.6    |
| 18  | 12.7   | 15.0    | 14.8      | 15.3     | 10.9   | 5.3      | 6.8    |
| 19  | 12.4   | 14.1    | 13.3      | 11.6     | 14.3   | 7.1      | 6.4    |
| 20  | 12.1   | 12.4    | 14.2      | 10.6     | 10.3   | 5.7      | 8.4    |
| 21  | 9.1    | 12.6    | 11.4      | 9.4      | 7.3    | 5.7      | 10.2   |
| 22  | 9.1    | 10.0    | 9.8       | 12.1     | 6.0    | 5.7      | 10.2   |
| 23  | 8.8    | 8.6     | 9.6       | 10.6     | 7.6    | 5.3      | 8.3    |

We can clearly observe that sessions are higher on weekdays between 8 am - 5 pm. Based on the above results the management can decide the staff requirements.
Let us see now what the CEO has to say about the above results

**CEO's Response:**



