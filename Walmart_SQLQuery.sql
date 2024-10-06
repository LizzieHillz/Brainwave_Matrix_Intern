SELECT *
FROM Walmart_Sales

--Question 1 (Which store made the highest sales?) Answer - Store 20 made the highest sales
SELECT Store,
	SUM(Weekly_Sales) AS Total_Sales_Over_Years
FROM Walmart_Sales
GROUP BY Store
ORDER BY Total_Sales_Over_Years DESC;


--Question 2 (Which month/year had the highest sales?) Answer - The highest number of sales was made in 2010-12-24
SELECT SUM(Weekly_Sales) AS Total_Sales,
	CAST(Date AS DATE) AS Sales_Date
FROM Walmart_Sales
GROUP BY CAST(Date AS DATE)
ORDER BY Total_Sales DESC;


--Question 3 (Calculate annual sales) Answer - The query shows that there was more sales in the year 2011
WITH Sales_Per_Year AS (
    SELECT YEAR(CAST(Date AS DATE)) AS Year, SUM(Weekly_Sales) AS Yearly_Sales
    FROM Walmart_Sales
    GROUP BY YEAR(CAST(Date AS DATE))
)
SELECT a.Year AS Current_Year, a.Yearly_Sales AS Current_Year_Sales,
       b.Year AS Previous_Year, b.Yearly_Sales AS Previous_Year_Sales,
       ((a.Yearly_Sales - b.Yearly_Sales) / b.Yearly_Sales) * 100 AS YoY_Growth_Percentage
FROM Sales_Per_Year a
JOIN Sales_Per_Year b
ON  a.Year = b.Year + 1
ORDER BY a.Year;


--Question 4 (Does holiday have impact on sales?) Answer - Yes, more sales was recorded during holiday period
SELECT Holiday_Flag, AVG(Weekly_Sales) AS Avg_Sales
FROM Walmart_Sales
GROUP BY Holiday_Flag;


--Question 5 (Which store made more sales during the holiday period?) Answer - Store 20 made the highest sales during holiday period.
SELECT TOP 10 Store,
	Holiday_Flag, AVG(Weekly_Sales) AS Avg_Sales
FROM Walmart_Sales
WHERE Holiday_Flag = 1
GROUP BY Store, Holiday_Flag
ORDER BY Avg_Sales DESC;


--Question 6 (Is there a relationship between sales and external factors?) Answer - There isn't relationship between these external factors and sales
SELECT Temperature, Fuel_Price, CPI, Unemployment, 
       AVG(Weekly_Sales) AS Avg_Sales
FROM Walmart_Sales
GROUP BY Temperature, Fuel_Price, CPI, Unemployment
ORDER BY Avg_Sales DESC;


--Comparing sales from one year to the next for each store to identify growth patterns.
WITH Sales_Per_Year AS (
    SELECT Store, YEAR(CAST(Date AS DATE)) AS Year, SUM(Weekly_Sales) AS Yearly_Sales
    FROM Walmart_Sales
    GROUP BY Store, YEAR(CAST(Date AS DATE))
)
SELECT a.Store, a.Year AS Current_Year, a.Yearly_Sales AS Current_Year_Sales,
       b.Year AS Previous_Year, b.Yearly_Sales AS Previous_Year_Sales,
       ((a.Yearly_Sales - b.Yearly_Sales) / b.Yearly_Sales) * 100 AS YoY_Growth_Percentage
FROM Sales_Per_Year a
JOIN Sales_Per_Year b
ON a.Store = b.Store AND a.Year = b.Year + 1
ORDER BY a.Store, a.Year;


--This query looks at holiday week sales over the years to see if there is growth during holiday periods.
WITH Holiday_Sales AS (
    SELECT Store, YEAR(CAST(Date AS DATE)) AS Year, Holiday_Flag, SUM(Weekly_Sales) AS Total_Holiday_Sales
    FROM Walmart_Sales
    WHERE Holiday_Flag = 1
    GROUP BY Store, YEAR(CAST(Date AS DATE)), Holiday_Flag
)
SELECT a.Store, a.Year AS Current_Year, a.Total_Holiday_Sales AS Current_Year_Holiday_Sales,
       b.Year AS Previous_Year, b.Total_Holiday_Sales AS Previous_Year_Holiday_Sales,
       ((a.Total_Holiday_Sales - b.Total_Holiday_Sales) / b.Total_Holiday_Sales) * 100 AS Holiday_Sales_Growth
FROM Holiday_Sales a
JOIN Holiday_Sales b
ON a.Store = b.Store AND a.Year = b.Year + 1
ORDER BY a.Store, a.Year;

