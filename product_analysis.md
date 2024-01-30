
# Product Analysis

Product Analysis help you to understand :

#### 1. How each product contributes to your business ?
#### 2. How product launches impact the overall portfolio ?

* Analyze Sales and Revenue by Product
* Monitoring the impact of adding a new product to your product portfolio
* Watching product sales trend to understand overall health of your business

KPIS used to understand the product performance:

1. Orders
2. Revenue
3. Margin
4. Average Order Value

## Stakeholder's Request

1. By: CEO <br>
   Date : Jan 4, 2013

   We are about to launch a new product and I would like to deep dive into our current flagship products.
   Can you please pull monthly trends till date for **number of sales, total revenue and total margin generated** for the business ?

   
```sql

   SELECT 
   YEAR(created_at) as yr,
   MONTH(created_at) as mnth, 
   COUNT(DISTINCT order_id) as number_of_sales,
   SUM(price_usd) as total_revenue,
   SUM(price_usd - cogs_usd) as total_margin
   FROM orders
   WHERE created_at < '2013-01-04'
   GROUP BY 1,2;

```

**Result:**

| yr   | mnth | number_of_sales | total_revenue | total_margin |
|------|------|------------------|---------------|--------------|
| 2012 | 3    | 60               | 2999.40       | 1830.00      |
| 2012 | 4    | 99               | 4949.01       | 3019.50      |
| 2012 | 5    | 108              | 5398.92       | 3294.00      |
| 2012 | 6    | 140              | 6998.60       | 4270.00      |
| 2012 | 7    | 169              | 8448.31       | 5154.50      |
| 2012 | 8    | 228              | 11397.72      | 6954.00      |
| 2012 | 9    | 287              | 14347.13      | 8753.50      |
| 2012 | 10   | 371              | 18546.29      | 11315.50     |
| 2012 | 11   | 618              | 30893.82      | 18849.00     |
| 2012 | 12   | 506              | 25294.94      | 15433.00     |
| 2013 | 1    | 42               | 2099.58       | 1281.00      |


2. By: CEO <br>
   Date: April 5, 2013

   We launched our second product back on Jan 6, 2013. Can you pull together some trended analysis?

   I'd like to **monthly order volume, overall conversion rates, revenue per session** and a **breakdown of sales by product** all for the time period **since April 1, 2012**

   ```sql

      SELECT 
   YEAR(ws.created_at) AS yr,
   MONTH(ws.created_at) AS mnth,
   COUNT(DISTINCT ws.website_session_id) AS sessions,
   COUNT(DISTINCT o.order_id) AS orders,
   COUNT(DISTINCT o.order_id)/ COUNT(DISTINCT ws.website_session_id) AS conv_rate,
   SUM(o.price_usd)/COUNT(DISTINCT ws.website_session_id) AS revenue_per_session,
   COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_one_orders,
   COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_two_orders
   FROM website_sessions ws
   LEFT JOIN orders o
   ON ws.website_session_id = o.website_session_id
   WHERE ws.created_at BETWEEN '2012-04-01' AND '2013-04-05'
   GROUP BY 1, 2;

   ```

   **Results:**

| yr   | mnth | sessions | orders | conv_rate | revenue_per_session  | product_one_orders  | product_two_orders  |
|------|------|----------|--------|-----------|----------------------|---------------------|---------------------|
| 2012 | 4    | 3734     | 99     | 0.0265    | 1.325391             | 99                  | 0                   |
| 2012 | 5    | 3736     | 108    | 0.0289    | 1.445107             | 108                 | 0                   |
| 2012 | 6    | 3963     | 140    | 0.0353    | 1.765985             | 140                 | 0                   |
| 2012 | 7    | 4249     | 169    | 0.0398    | 1.988305             | 169                 | 0                   |
| 2012 | 8    | 6097     | 228    | 0.0374    | 1.869398             | 228                 | 0                   |
| 2012 | 9    | 6546     | 287    | 0.0438    | 2.191740             | 287                 | 0                   |
| 2012 | 10   | 8183     | 371    | 0.0453    | 2.266441             | 371                 | 0                   |
| 2012 | 11   | 14011    | 618    | 0.0441    | 2.204969             | 618                 | 0                   |
| 2012 | 12   | 10072    | 506    | 0.0502    | 2.511412             | 506                 | 0                   |
| 2013 | 1    | 6401     | 391    | 0.0611    | 3.127025             | 344                 | 47                  |
| 2013 | 2    | 7168     | 497    | 0.0693    | 3.692108             | 335                 | 162                 |
| 2013 | 3    | 6264     | 385    | 0.0615    | 3.176269             | 320                 | 65                  |
| 2013 | 4    | 1209     | 96     | 0.0794    | 4.085227             | 82                  | 14                  |

From the above data, it is clear that the overall revenue is increasing per session. The CEO has following response on the above results

**CEO's Response:**

This confirms that our conversion rate and revenue per session are improving over time, which is great. I am having a hard time understanding if the growth since January is **due to our new product launch or just a continuation of our overall business improvements.** I will connect with Tom about digging into this some more.

### Product-level Website Analysis

Product_focused website analysis is about **learning how customers interact with each of your products, and how well each product converts customers.**

This type of analysis helps to understand:

1. Which product(s) generate the most on multi-product showcase pages.
2. the impact on website conversion rate when you add a new product.
3. if some products are converting better than others through product specific conversion funnel analysis.

## Stakeholder's Request:

1. By: Website Manager <br>
   Date: April 6, 2013

   Now that we have a new product, I am thinking about our user path and conversion funnel. Let's look at the sessions that hit the **`/products` Page and see where they went next.** <br>
   Could you please pull **Click Through Rates from `/products` since the new product launch on January 6, 2013 by product and compare to the 3 months leading upto launch as a baseline** ?

For the above problem, we will first find the records in the date range of October 6, 2012 (3 months before new product launch on Jan 6, 2013) to April 6, 2013(3 months after product launch) and tag each row as pre product launch or post product launch.


   ```sql

   -- product pathing analysis
   
   -- Step 1: Find relevant /products pageviews with website_session_id
   -- Step 2: Find the next pageview_id that occurs AFTER the product pageview
   -- Step 3: Find the pageview url applicable to next pageview id 
   -- Step 4: Summarize the data and analyze pre and post periods

-- Step 1: From website_pageviews table extract the session_id, pageview_id, date and divide the time period between pre and post the launch of product 2, restrict the data for only 6 months ranging from 3 months before the launch of product 2 and 3 months after the launch of product 2 and url ending in `/products`

   CREATE TEMPORARY TABLE product_pageviews
   SELECT
   website_session_id,
   website_pageview_id,
   DATE(created_at) as dte,
   CASE 
	WHEN created_at < '2013-01-06' THEN 'A.Pre_product_2'
    WHEN created_at >= '2013-01-06' THEN 'B.Post_product_2'
    ELSE 'check logic'
    END as time_period
   FROM website_pageviews
   WHERE created_at BETWEEN '2012-10-06' AND '2013-04-06'
   AND pageview_url = '/products';

   ```
If we run the above query, it returns 26405 rows with 4 columns - website_session_id, website_pageview_id, dte and time_period
Next, we will find the pageview ids that come after /products page for all sessions in product_pageviews temporary table








