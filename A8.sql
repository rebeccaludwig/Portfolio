--REBECCA LUDWIG
--A8

--1. List the customers from California who bought red mountain bikes in September 2003. Use order date as date bought.
SELECT	C.CustomerID, C.LastName, C.FirstName, B.ModelType, ColorList, B.OrderDate, B.SaleState
FROM	Customer C INNER JOIN Bicycle B 
ON		C.CustomerID = B.CustomerID INNER JOIN Paint P 
ON		B.PaintID = P.PaintID
WHERE	B.ModelType LIKE 'MOUNTAIN%' AND 
		P.ColorList = 'RED' AND 
		YEAR(B.OrderDate) = 2003 AND
		MONTH(B.OrderDate) = 09 AND
		B.SaleState = 'CA'

--2. List the employees who sold race bikes shipped to Wisconsin without the help of a retail store in 2001.
SELECT	E.EmployeeID, E.LastName, B.SaleState, B.ModelType, B.StoreID, B.OrderDate
FROM	Employee E INNER JOIN Bicycle B 
ON		E.EmployeeID = B.EmployeeID
WHERE	B.SaleState = 'WI' AND
		B.ModelType = 'RACE' AND 
		B.StoreID < 100 AND
		YEAR(B.OrderDate) = 2001
GROUP BY E.EmployeeID, E.LastName, B.SaleState, B.ModelType, B.StoreID, B.OrderDate, B.EmployeeID

--3. List all of the (distinct) rear derailleurs installed on road bikes sold in Florida in 2002.
SELECT DISTINCT C.ComponentID, M.ManufacturerName, C.ProductNumber
FROM	Component C INNER JOIN Manufacturer M 
ON		C.ManufacturerID = M.ManufacturerID INNER JOIN City CTY
ON		M.CityID = CTY.CityID INNER JOIN Customer CUS
ON		CTY.CityID = CUS.CityID INNER JOIN Bicycle B
ON		CUS.CustomerID = B.CustomerID
WHERE	C.Category = 'REAR DERAILLEUR' AND
		C.Road = 'ROAD' AND
		B.SaleState = 'FL' AND
		YEAR(B.OrderDate) = 2002

--4. Who bought the largest (frame size) full suspension mountain bike sold in Georgia in 2004?
SELECT	C.CustomerID, C.LastName, C.FirstName, B.ModelType, B.SaleState, B.FrameSize, B.OrderDate
FROM	CUSTOMER C INNER JOIN BICYCLE B
ON		C.CustomerID = B.CustomerID
WHERE	B.ModelType = 'MOUNTAIN FULL' AND
		B.SaleState = 'GA' AND
		YEAR(B.OrderDate) = 2004 AND
		B.FrameSize >=	(
						SELECT	MAX(FrameSize)
						FROM	Bicycle
						WHERE	ModelType = 'MOUNTAIN FULL'
						)
						
--5. Which manufacturer gave us the largest discount on an order in 2003?
SELECT	M.ManufacturerID, M.ManufacturerName
FROM	Manufacturer M INNER JOIN Component CO
ON		M.ManufacturerID = CO.ManufacturerID INNER JOIN PurchaseItem PI
ON		CO.ComponentID = PI.ComponentID INNER JOIN PurchaseOrder PO
ON		PI.PurchaseID = PO.PurchaseID
WHERE	YEAR(PO.OrderDate) = 2003
GROUP BY M.ManufacturerID, M.ManufacturerName, PO.Discount
HAVING	PO.Discount = ALL	(
							SELECT TOP 1 Discount
							FROM	PurchaseOrder
							WHERE	YEAR(OrderDate) = 2003
							)

--6. What is the most expensive road bike component we stock that has a quantity on hand greater than 200 units?
SELECT	CO.ComponentID, M.ManufacturerName, CO.ProductNumber, CO.Road, CO.Category, CO.ListPrice, CO.QuantityOnHand
FROM	Manufacturer M INNER JOIN Component CO
ON		M.ManufacturerID = CO.ManufacturerID
WHERE	CO.Road = 'ROAD' AND
		CO.QuantityOnHand > 200 AND
		CO.ListPrice =	ALL	(
							SELECT	MAX(ListPrice)
							FROM Component
							WHERE Road = 'ROAD' AND
							QuantityOnHand > 200
							)

--7. Which inventory item represents the most money sitting on the shelf—based on estimated cost?
SELECT	CO.ComponentID, M.ManufacturerName, CO.ProductNumber, CO.Category, CO.Year, CO.ListPrice * CO.QuantityOnHand AS [Value]
FROM	Manufacturer M INNER JOIN Component CO
ON		M.ManufacturerID = CO.ManufacturerID
GROUP BY CO.ComponentID, M.ManufacturerName, CO.ProductNumber, CO.Category, CO.Year, CO.ListPrice, CO.QuantityOnHand
HAVING	CO.ListPrice * CO.QuantityOnHand = ALL	( 
												SELECT	MAX(QuantityOnHand * ListPrice)
												FROM	Component
												)	

--8. What is the greatest number of components ever installed in one day by one employee?
SELECT TOP 1 E.EmployeeID, E.LastName, BP.DateInstalled, COUNT(BP.ComponentID) AS [CountOfComponents]	 
FROM	BikeParts BP INNER JOIN Bicycle B 
ON		BP.SerialNumber = B.SerialNumber INNER JOIN Employee E
ON		B.EmployeeID = E.EmployeeID
WHERE	DateInstalled IS NOT NULL
GROUP BY E.EmployeeID, E.LastName, BP.DateInstalled
ORDER BY CountOfComponents DESC

--9. What was the most popular letter style on race bikes in 2003?
SELECT	LS.LetterStyle, COUNT(B.SerialNumber) AS [CountOfSerialNumber]
FROM	Bicycle B INNER JOIN LetterStyle LS
ON		B.LetterStyleID = LS.LetterStyle 
WHERE	YEAR(OrderDate) = 2003 AND 
		B.ModelType = 'RACE'
GROUP BY LS.LetterStyle				
HAVING	COUNT(B.SerialNumber) = ALL	(
									SELECT TOP 1 COUNT(B.SerialNumber)
									FROM	Bicycle B INNER JOIN LetterStyle LS
									ON		B.LetterStyleID = LS.LetterStyle 
									WHERE	YEAR(OrderDate) = 2003 AND 
											B.ModelType = 'RACE'
									GROUP BY LetterStyle
									ORDER BY COUNT(B.SerialNumber) DESC
									)
ORDER BY COUNT(B.SerialNumber) DESC

--10. Which customer spent the most money with us and how many bicycles did that person buy in 2002?
SELECT	C.CustomerID, C.LastName, C.FirstName, COUNT(C.CustomerID) AS [Number of Bikes], SUM(B.ListPrice) AS [Amount Spent]
FROM	Customer C INNER JOIN Bicycle B
ON		C.CustomerID = B.CustomerID
WHERE	YEAR(B.OrderDate) = 2002
GROUP BY C.CustomerID, C.LastName, C.FirstName, C.CustomerID, B.ListPrice
HAVING	B.ListPrice = ALL	(
								SELECT MAX(ListPrice)
								FROM	Bicycle
								WHERE	YEAR(OrderDate) = 2002
								)

--11. Have the sales of mountain bikes (full suspension or hard tail) increased or decreased from 2000 to 2004 (by count not by value)? You will list the number sold by year in descending order. 
SELECT	YEAR(OrderDate) AS [SaleYear], COUNT(SerialNumber) AS [CountOfSerialNumber]
FROM	Bicycle
WHERE	YEAR(OrderDate) BETWEEN 2000 AND 2004 AND
		ModelType = 'MOUNTAIN FULL' OR ModelType = 'HARD TAIL'
GROUP BY YEAR(OrderDate)
ORDER BY COUNT(SerialNumber) DESC

--12. Which component did the company spend the most money on in 2003?
SELECT	CO.ComponentID, M.ManufacturerName, CO.ProductNumber, CO.Category, PI.PricePaid AS [Value]
FROM	PurchaseOrder PO INNER JOIN PurchaseItem PI
ON		PO.PurchaseID = PI.PurchaseID INNER JOIN Component CO 
ON		PI.ComponentID = CO.ComponentID INNER JOIN Manufacturer M 
ON		CO.ManufacturerID = M.ManufacturerID
WHERE	YEAR(OrderDate) = 2003
		AND PI.PricePaid =	(
							SELECT	MAX(PI.PricePaid)
							FROM	PurchaseItem PI INNER JOIN PurchaseOrder PO
							ON		PI.PurchaseID = PO.PurchaseID
							WHERE	YEAR(OrderDate) = 2003
							)

--13. Which employee painted the most red race bikes in May 2003?
SELECT	E.EmployeeID, E.LastName, COUNT(E.EmployeeID) AS [Number Painted]
FROM	Employee E INNER JOIN Bicycle B
ON		E.EmployeeID = B.EmployeeID
WHERE	B.ModelType = 'RACE' AND
		YEAR(OrderDate) = 2003 AND
		MONTH(OrderDate) = 05
GROUP BY E.EmployeeID, E.LastName
HAVING	COUNT(E.EmployeeID) = ALL	(
									SELECT	MAX([Number Painted])
									FROM	(
											SELECT	E.EmployeeID, E.LastName, COUNT(E.EmployeeID) AS [Number Painted]
											FROM	Employee E INNER JOIN Bicycle B
											ON		E.EmployeeID = B.EmployeeID
											WHERE	B.ModelType = 'RACE' AND
													YEAR(OrderDate) = 2003 AND
													MONTH(OrderDate) = 05
											GROUP BY E.EmployeeID, E.LastName)
									AS [NumberPainted]
									)
									
--14. Which California bike shop helped sell the most bikes (by value) in 2003?
SELECT	RS.StoreID
FROM	RetailStore RS INNER JOIN Bicycle B 
ON		RS.StoreID = B.StoreID
WHERE	B.SaleState = 'CA' AND
		YEAR(B.OrderDate) = 2003
GROUP BY RS.StoreID, B.SaleState, B.OrderDate
HAVING	COUNT(B.SerialNumber) =	(
								SELECT TOP 1 COUNT(B.SerialNumber)
								FROM	RetailStore RS INNER JOIN Bicycle B 
								ON		RS.StoreID = B.StoreID
								WHERE	B.SaleState = 'CA' AND
								YEAR(B.OrderDate) = 2003
								)

--15. What is the total weight of the components on bicycle 11356?
SELECT	SUM(CO.Weight) AS [TotalWeight]
FROM	Component CO INNER JOIN BikeParts BP
ON		CO.ComponentID = BP.ComponentID INNER JOIN Bicycle B
ON		BP.SerialNumber = B.SerialNumber
WHERE	B.SerialNumber = '11356'
GROUP BY B.SerialNumber

--16. What is the total list price of all items in the 2002 Campy Record groupo?
SELECT	G.GroupName, SUM(B.ListPrice) AS [SumOfListPrice]
FROM	Groupo G INNER JOIN GroupComponents GC
ON		G.ComponentGroupID = GC.GroupID INNER JOIN Component CO
ON		GC.ComponentID = CO.ComponentID INNER JOIN BikeParts BP
ON		CO.ComponentID = BP.ComponentID INNER JOIN Bicycle B
ON		BP.SerialNumber = B.SerialNumber
WHERE	G.GroupName = 'CAMPY RECORD 2002'
GROUP BY G.GroupName

--17. In 2003, were more race bikes built from carbon or titanium (based on the down tube)?
SELECT	TM.Material, COUNT(B.SerialNumber) AS CountOfSerialNumber
FROM	Bicycle B INNER JOIN BicycleTubeUsage BTU
ON		B.SerialNumber = BTU.SerialNumber INNER JOIN TubeMaterial TM
ON		BTU.TubeID = TM.TubeID
WHERE	YEAR(B.OrderDate) = 2003 AND
		TM.Material IN ('CARBON FIBER','TITANIUM')
GROUP BY TM.Material

--18. What is the average price paid for the 2001 Shimano XTR rear derailleurs?
SELECT	AVG(PI.PricePaid) AS [AvgOfPricePaid]
FROM	PurchaseItem PI INNER JOIN Component CO
ON		PI.ComponentID = CO.ComponentID INNER JOIN GroupComponents GC
ON		CO.ComponentID = GC.ComponentID INNER JOIN	Groupo GG
ON		GC.GroupID = GG.ComponentGroupID
WHERE	GG.GroupName = 'SHIMANO XTR 2001'

--19. What is the average top tube length for a 54 cm (frame size) road bike built in 1999?
SELECT	AVG(TopTube) AS [AvgTopTubeLength]
FROM	Bicycle
WHERE	FrameSize = 54 AND
		ModelType = 'ROAD' AND
		YEAR(OrderDate) = 1999 AND
		YEAR(ShipDate) = 1999

--20. On average, which costs (list price) more: road tires or mountain bike tires?
SELECT	CO.Road, AVG(B.ListPrice) AS [AvgOfListPrice]
FROM	Bicycle B INNER JOIN BikeParts BP
ON		B.SerialNumber = BP.SerialNumber INNER JOIN Component CO
ON		BP.ComponentID = CO.ComponentID 
WHERE	CO.Road IN ('ROAD','MTB')
GROUP BY CO.Road

--21. In May 2003, which employees sold road bikes that they also painted?
SELECT	E.EmployeeID, E.LastName
FROM	Employee E INNER JOIN Bicycle B
ON		E.EmployeeID = B.EmployeeID
WHERE	YEAR(B.OrderDate) = 2003 AND
		MONTH(B.OrderDate) = 05 AND
		B.Painter = B.EmployeeID AND
GROUP BY E.EmployeeID, E.LastName, B.Painter, B.EmployeeID

--22. In 2002, was the Old English letter style more popular with some paint jobs?
SELECT	P.PaintID, P.ColorName, COUNT(B.SerialNumber) AS [Number of Bikes Painted]
FROM	LetterStyle LS INNER JOIN Bicycle B
ON		LS.LetterStyle = B.LetterStyleID INNER JOIN Paint P
ON		B.PaintID = P.PaintID
WHERE	YEAR(B.OrderDate) = 2002 AND 
		LS.LetterStyle = 'ENGLISH'
GROUP BY P.PaintID, P.ColorName
ORDER BY COUNT(B.SerialNumber)

--23. Which race bikes in 2003 sold for more than the average price of race bikes in 2002?
SELECT	SerialNumber, ModelType, OrderDate, SalePrice
FROM	Bicycle
WHERE	YEAR(OrderDate) = 2003 AND
		ModelType = 'RACE' AND
		SalePrice >	(
					SELECT	AVG(SalePrice)
					FROM	Bicycle
					WHERE	YEAR(OrderDate) = 2003 AND
							ModelType = 'RACE'
					)

--24. Which component that had no sales (installations) in 2004 has the highest inventory value (cost basis)?
SELECT TOP 1 M.ManufacturerName, CO.ProductNumber, CO.Category, CO.ListPrice * CO.QuantityOnHand AS [Value],	CO.ComponentID	
FROM	Manufacturer M INNER JOIN Component CO
ON		M.ManufacturerID = CO.ManufacturerID
WHERE	CO.YEAR <> 2004
GROUP BY M.ManufacturerName, CO.ProductNumber, CO.Category, CO.ListPrice, CO.QuantityOnHand, CO.ComponentID
ORDER BY Value


--25. Create a vendor contacts list of all manufacturers and retail stores in California. Include only the columns for VendorName and Phone. The retail stores should only include stores that participated in the sale of at least one bicycle in 2004
SELECT	RS.StoreName [Store Name], RS.Phone, M.ManufacturerName AS [Manufacturer Name], M.Phone
FROM	Manufacturer M INNER JOIN City CTY
ON		M.CityID = CTY.CityID INNER JOIN RetailStore RS
ON		CTY.CityID = RS.CityID INNER JOIN Bicycle B
ON		RS.StoreID = B.StoreID
WHERE	B.SaleState = 'CA' AND
		YEAR(OrderDate) = 2004
GROUP BY RS.StoreName, RS.Phone, M.ManufacturerName, M.Phone

--26. List all of the employees who report to Venetiaan.
SELECT	'Venetiaan' AS [Manager Name], EmployeeID, LastName, FirstName, Title
FROM	Employee
GROUP BY CurrentManager, EmployeeID, LastName, FirstName, Title
HAVING	CurrentManager = ALL	(
								SELECT	EmployeeID
								FROM	Employee
								WHERE	LastName = 'VENETIAAN'
								)

--27. List the components where the company purchased at least 25 percent more units than it used through June 30, 2000. An item is used if it has an install date.
SELECT	CO.ComponentID, M.ManufacturerName, CO.ProductNumber, CO.Category, PI.QuantityRecieved AS [TotalReceived], (COUNT(DateInstalled) - PI.QuantityInstalled)) * (C.ListPrice - PI.PricePaid) AS [TotalUsed], NetGain, NetPct, CO.ListPrice
FROM	Manufacturer M INNER JOIN Component CO
WHERE	

--28. In which years did the average build time for the year exceed the overall average build time for all years? The build time is the difference between order date and ship date.
SELECT TOP 1 YEAR(OrderDate) AS [Year], DAY(ShipDate) - DAY(OrderDate) AS [BuildTime]
FROM	Bicycle	
GROUP BY OrderDate, ShipDate 
HAVING	DAY(ShipDate) - DAY(OrderDate) >	(
											SELECT AVG(DAY(ShipDate) - DAY(OrderDate))
											FROM Bicycle
											)
ORDER BY BuildTime DESC