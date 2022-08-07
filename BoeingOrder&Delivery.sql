SELECT * 
From [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries];

--How many countries did Boeing service?

SELECT COUNT (Distinct(Country)) AS #ofCountries
From [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries];

--What customer ordered the most and when was that?

SELECT [Customer Name], [Order Total], [Order Year], [Order Month]
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
WHERE [Order Total] = (SELECT MAX([Order Total]) 
					 FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries])

--How many of those orders went through for SpiceJet?

SELECT [Customer Name], [Delivery Total], [Delivery Year ], [Unfilled Orders]
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
WHERE [Order Total] = (SELECT MAX([Order Total]) 
					 FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries])


--What is the ratio of orders to delieveries?
SELECT [Customer Name], [Order Year], [Order Month], [Delivery Year ], [Order Total]/[Delivery Total] AS DeliveryRatio
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
--First I have to change the data type but that aint working. Ill comment it out
--ALTER TABLE [BoeingHistOrder&Deliveries]
--ALTER COLUMN [Order Total] int

--What is the time between the deliveries of orders?
SELECT [Order Year], [Delivery Year ], [Order Year] - [Order Month] AS Delivery_Time
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]

--How many times did the company order from Boeing compared to others? Would include rank, but it is not working as well I would like.
--I would also like it to be a view but that is not working the way I want too. I'll comment it out for now.

--CREATE VIEW ReturningCustomerTable AS
SELECT Distinct([Customer Name]), COUNT([CUSTOMER NAME]) AS ReturningCustomer--,RANK() (OVER ReturningCustomer ORDER BY Returning Customer)
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
Group By [Customer Name]
ORDER BY ReturningCustomer DESC

--CREATE VIEW SpiceJet AS
SELECT Distinct([Customer Name]), COUNT([CUSTOMER NAME]) AS ReturningCustomer
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
WHERE [Customer Name]= 'SpiceJet'
Group By [Customer Name]

--Now I am curious about the engine and Model Series used?
SELECT *
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
WHERE [Customer Name] = 'SpiceJet'

--So There are unfulfilled orders exist However they still Place orders. Order by time
SELECT *
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
WHERE [Customer Name] = 'SpiceJet'
ORDER BY [Model Series]

--All Unfilled Orders are 737 Max Model Series and large quantites of them. This is odd business. ALso I am assuming there was at least
--6 deliveries in 2013. Speaking of that maybe 2010 737-800 Model Series was not deliveried and Unfilled orders column was left unfilled.

--A few questions could be asked such as if there is a disportionate fullfillment rate between Model Series in general?
--if there is a disporportionate fullfillment rate between countries and/or region? And most importantly why? I will investigate that

SELECT [Model Series], [Delivery Total], [Order Total], [Unfilled Orders] COUNT([Model Series]) AS NumberOfModels
FROM [BoeingOrder&Delivery]..[BoeingHistOrders&Deliveries]
Group By [Model Series]