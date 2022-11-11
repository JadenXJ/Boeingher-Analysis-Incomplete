use BoeingOrderDelivery

SELECT * 
From dbo.BoeingHistOrdersDeliveries
WHERE Order_Year = 'All'

--How many countries did Boeing service?

SELECT COUNT (Distinct(Country)) AS #ofCountries
From dbo.BoeingHistOrdersDeliveries;

--What customer ordered the most at a given time and when was that?

--1st Way
SELECT Customer_Name, Order_Total, Order_Year, Order_Month
FROM dbo.BoeingHistOrdersDeliveries
WHERE Order_Total = (SELECT MAX(Order_Total) 
					 FROM dbo.BoeingHistOrdersDeliveries);

--2nd Way
SELECT Customer_Name, MAX(Order_Total) AS Highest_Order
FROM dbo.BoeingHistOrdersDeliveries
GROUP BY Customer_Name
ORDER BY MAX(Order_Total) DESC
	OFFSET 0 ROWS
	FETCH NEXT 1 ROWS ONLY;

SELECT Distinct(Customer_Name), Count(Order_Total) AS How_Many_Orders, MAX(Order_Total)
FROM dbo.BoeingHistOrdersDeliveries
GROUP BY Customer_Name;


--How many of those orders went through for SpiceJet?

SELECT Customer_Name, Delivery_Total, Delivery_Year, Unfilled_Orders
FROM dbo.BoeingHistOrdersDeliveries
WHERE Customer_Name = (SELECT Customer_Name
							FROM dbo.BoeingHistOrdersDeliveries
							GROUP BY Customer_Name
							ORDER BY MAX(Order_Total) DESC
								OFFSET 0 ROWS
								FETCH NEXT 1 ROWS ONLY)


--What is the ratio of orders to delieveries?
SELECT Customer_Name, Order_Year, Order_Month, Delivery_Year, Order_Total/Delivery_Total AS DeliveryRatio
FROM dbo.BoeingHistOrdersDeliveries

--Doesn't work for characters, need to cast
SELECT Customer_Name, Order_Year, Order_Month, Delivery_Year, CAST(Order_Year AS int) AS DeliveryRatio
FROM dbo.BoeingHistOrdersDeliveries
WHERE Order_Year != ALL(
		SELECT TOP 2 Order_Year
		From dbo.BoeingHistOrdersDeliveries
		WHERE Order_Year = 'Dec' OR Order_Year = 'Nov'
		GROUP BY Order_Year
		)

--Problem with cast because there are chars ALL route, delete that row.

DELETE 
From dbo.BoeingHistOrdersDeliveries
WHERE Order_Year = 'All'

SELECT Customer_Name, Order_Year, Order_Month, Delivery_Year, (CAST(Order_Year AS int)/CAST(Delivery_Year AS int)) AS DeliveryRatio
FROM dbo.BoeingHistOrdersDeliveries
WHERE Order_Year != ALL(
		SELECT TOP 2 Order_Year
		From dbo.BoeingHistOrdersDeliveries
		WHERE Order_Year = 'Dec' OR Order_Year = 'Nov'
		GROUP BY Order_Year
		)

--First I have to change the data type but that aint working. Ill comment it out
--ALTER TABLE [BoeingHistOrder&Deliveries]
--ALTER COLUMN Order_Total int

--What is the time between the deliveries of orders?
SELECT Order_Year, Delivery_Year, Order_Year - Order_Month AS Delivery_Time
FROM dbo.BoeingHistOrdersDeliveries

--How many times did the company order from Boeing compared to others? Would include rank, but it is not working as well I would like.

GO
CREATE VIEW 
dbo.ReturningCustomerTable AS
SELECT Distinct(Customer_Name), COUNT(Customer_Name) AS ReturningCustomer--,RANK() (OVER ReturningCustomer ORDER BY Returning Customer)
FROM dbo.BoeingHistOrdersDeliveries
Group By Customer_Name
ORDER BY ReturningCustomer DESC
GO

GO
CREATE VIEW 
dbo.Spice_Jet AS
SELECT Distinct(Customer_Name), COUNT(Customer_Name) AS ReturningCustomer
FROM dbo.BoeingHistOrdersDeliveries
WHERE Customer_Name= 'SpiceJet'
Group By Customer_Name;

--DROP View Spice_Jet
GO
Select *
FROM Spice_Jet;

--Now I am curious about the engine and Model Series used?
SELECT *
FROM dbo.BoeingHistOrdersDeliveries
WHERE Customer_Name = 'SpiceJet'

--So There are unfulfilled orders exist However they still Place orders. Order by time
SELECT *
FROM dbo.BoeingHistOrdersDeliveries
WHERE Customer_Name = 'SpiceJet'
ORDER BY Model_Series

--All Unfilled Orders are 737 Max Model Series and large quantites of them. This is odd business. ALso I am assuming there was at least
--6 deliveries in 2013. Speaking of that maybe 2010 737-800 Model Series was not deliveried and Unfilled orders column was left unfilled.

--A few questions could be asked such as if there is a disportionate fullfillment rate between Model Series in general?
--if there is a disporportionate fullfillment rate between countries and/or region? And most importantly why? I will investigate that

SELECT Model_Series, Delivery_Total, Order_Total, Unfilled_Orders, COUNT(Model_Series) AS NumberOfModels
FROM dbo.BoeingHistOrdersDeliveries
Group By Model_Series