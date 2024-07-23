USE Bike
--Creating a view to check the loyality of customers
CREATE VIEW Loyality_Chart AS
WITH sum_quantities_per_customer AS (
SELECT  DISTINCT YEAR(o.order_date) AS'Year',
		DATEPART(QUARTER,o.order_date) AS 'Quarter',
		c.customer_id,
		c.first_name+' '+c.last_name AS 'Full Name',
		c.state,
		SUM(oi.quantity) OVER (PARTITION BY year(o.order_date),DATEPART(QUARTER,o.order_date), c.customer_id ) AS 'Quantities ordered per Quarter',
		SUM(oi.quantity) OVER(PARTITION BY c.customer_id) AS 'Sum Quantities for whole period'

FROM
	dbo.customers AS c
INNER JOIN
	dbo.orders AS o on c.customer_id=o.customer_id
INNER JOIN 
	dbo.order_items AS oi on o.order_id=oi.order_id
)
SELECT *,IIF(qc.[Quantities ordered per Quarter]>(SELECT AVG(qc.[Quantities ordered per Quarter])
													FROM sum_quantities_per_customer as qc)+1
			and qc.[Sum Quantities for whole period]>(SELECT AVG(qc.[Quantities ordered per Quarter])
													FROM sum_quantities_per_customer as qc)+1,'Loyal','Not Loyal') 
													AS 'Loyality'
FROM sum_quantities_per_customer AS qc


--Products ordered per year
CREATE VIEW Sum_Quantity_per_month AS
WITH product_ordered_by_month AS(
SELECT 
	YEAR(o.order_date) AS 'Year',
	MONTH(o.order_date) AS 'Month',
	p.product_id,
	p.product_name,
	SUM(oi.quantity) OVER (PARTITION BY YEAR(o.order_date),MONTH(o.order_date),p.product_id) AS 'Sum_Quantities'

FROM
	dbo.products as p
INNER JOIN
	dbo.order_items as oi on p.product_id=oi.product_id
INNER JOIN
	dbo.orders as o on oi.order_id=o.order_id
)

SELECT
	*,
	DENSE_RANK() OVER 
	(PARTITION BY pom.year,pom.month ORDER BY pom.Sum_Quantities DESC)
	AS 'Rank Quantities ordered'
	
FROM product_ordered_by_month AS pom

--Most Ordered Products by quantity
ALTER VIEW Top_5_products_by_quantity AS
WITH Top_5_each_month AS (
SELECT DISTINCT *
FROM Sum_Quantity_per_month as sq
WHERE sq.[Rank Quantities ordered]<=5 

)

SELECT TOP 5 p.product_id,p.product_name,count(*) AS 'How many times appears in TOP 5'
FROM 
	Top_5_each_month AS t5 
LEFT JOIN 
	dbo.products AS p on t5.product_id=p.product_id
GROUP BY
	p.product_id,
	p.product_name
ORDER BY
	count(*) DESC

--Success of Sales
CREATE VIEW Success_of_Sales as
SELECT 
	YEAR(o.order_date) AS 'Year',
	MONTH(o.order_date) AS 'Month',
	ca.category_name,
	o.store_id,
	SUM(oi.quantity) 'Quantities Ordered',
	ROUND(SUM(oi.quantity*oi.list_price*(1-oi.discount)),0) 'total profit'
FROM
	dbo.categories as ca
INNER JOIN
	dbo.products as p on p.category_id=ca.category_id
INNER JOIN
	dbo.order_items as oi on p.product_id=oi.product_id
INNER JOIN
	dbo.orders as o on oi.order_id=o.order_id
GROUP BY
	YEAR(o.order_date),
	MONTH(o.order_date),
	ca.category_name,
	o.store_id




