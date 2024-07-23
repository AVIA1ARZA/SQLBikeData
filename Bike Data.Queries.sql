USE Bike
--Number of Loyal customers from each state
SELECT 
	lc1.state,
	count(*) 'Number of Total Customers',
	(SELECT count(*)
	FROM Loyality_Chart AS lc
	WHERE lc.Loyality='Loyal' and lc.state=lc1.state) AS 'Number of Loyals',
	((SELECT count(*)
	FROM Loyality_Chart AS lc
	WHERE lc.Loyality='Loyal' and lc.state=lc1.state)*100/count(*)) AS '%'
FROM 
	Loyality_Chart As lc1
GROUP BY 
	lc1.state
ORDER BY 
	'Number of Loyals' DESC
--Quantities Ordered each state per Quarter
SELECT
	lc.Quarter,
	lc.state,
	SUM(lc.[Quantities ordered per Quarter]) AS 'Sum Quantities'
FROM 
	Loyality_Chart As lc
GROUP BY
	lc.Quarter,
	lc.state

--Most Succesful stores by Sales (using a view)
WITH ranking as (
SELECT 
	ss.*,
	DENSE_RANK() OVER 
	(PARTITION BY ss.year,ss.store_id ORDER BY ss.[Quantities ordered] DESC )
	AS 'Rank store quantities',
	DENSE_RANK() OVER 
	(PARTITION BY ss.year,ss.store_id ORDER BY ss.[total profit] DESC )
	AS 'Rank store profit'
FROM 
	dbo.Success_of_Sales as ss
)


SELECT 
	*,
	IIF(r.[Rank store profit]=1,'Won at Profit',IIF(r.[Rank store quantities]=1,'Won at Quantity',IIF(r.[Rank store profit]=1 AND r.[Rank store quantities]=1,'Won Both',''))) as 'The best at...'

FROM 
	ranking as r




