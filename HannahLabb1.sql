--Om Databasen BookstoreDb inte finns, skapa den.--
IF DB_ID (N'BookstoreDb') IS NULL
	CREATE DATABASE BookstoreDb;
GO
--Använd Databasen BookstoreDb.--
USE BookstoreDb;
GO
--Om Tabellen Authors inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Authors' and xtype='U')
    CREATE TABLE Authors (
		ID integer NOT NULL,
		[First Name] nvarchar(max) NOT NULL,
		[Last Name] nvarchar(max) NOT NULL,
		[Birthdate] DATE NOT NULL,
		[Death Date] DATE,
		CONSTRAINT PK_Authors_ID PRIMARY KEY(ID)
    );
GO
--Om Tabellen Books inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Books' and xtype='U')
    CREATE TABLE Books (
		ISBN13 BIGINT NOT NULL CHECK(ISBN13 >= 1000000000000 AND ISBN13 <= 9999999999999),
		[Title] nvarchar(max) NOT NULL,
		[Language] nvarchar(max) NOT NULL,
		[Price] integer NOT NULL,
		[Release Date] DATE NOT NULL,
		[AuthorID] integer NOT NULL,
		CONSTRAINT PK_Books_ISBN13 PRIMARY KEY(ISBN13),
		CONSTRAINT FK_Books_AuthorID FOREIGN KEY (AuthorID) REFERENCES Authors(ID)
    );
GO
--Om Tabellen Shops inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Shops' and xtype='U')
    CREATE TABLE Shops (
		ID integer NOT NULL,
		[Name] nvarchar(max) NOT NULL,
		[Website] nvarchar(max) NOT NULL,
		CONSTRAINT PK_Shops_ID PRIMARY KEY(ID)
    );
GO
--Om InventoryBalance inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InventoryBalance' and xtype='U')
    CREATE TABLE InventoryBalance (
		ShopID integer NOT NULL,
		ISBN13 BIGINT NOT NULL,
		Amount integer NOT NULL,
		CONSTRAINT PK_Inventory_ID PRIMARY KEY(ShopID,ISBN13),
		CONSTRAINT FK_Inventory_ISBN13 FOREIGN KEY(ISBN13) REFERENCES Books(ISBN13),
		CONSTRAINT FK_Inventory_ShopID FOREIGN KEY(ShopID) REFERENCES Shops(ID)
    );
GO
--Om InventoryBalance inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Customers' and xtype='U')
    CREATE TABLE Customers (
		UserID integer NOT NULL,
		UserShop integer NOT NULL, --Vilken butik tillhör användaren?
		UserEmail nvarchar(max) NOT NULL, --Perfekt, användaren kan få sin email som login
		UserPassword nvarchar(max) NOT NULL, --Vad menar du att detta är en säkerhetsrisk?
		UserFirstName nvarchar(max) NOT NULL, --Användarens namn
		UserLastName nvarchar(max) NOT NULL, --Användarens efternamn
		UserCountry nvarchar(max) NOT NULL, --Användarens land
		UserCity nvarchar(max) NOT NULL, --Användarens stad
		UserState nvarchar(max) NOT NULL, --Användarens region
		UserAdress nvarchar(max) NOT NULL, --Användarens adress
		UserZipCode nvarchar(12) NOT NULL, --Detta är en nvarchar då Storbritannien, som exempel, har OX9 1AA
		CONSTRAINT PK_CustomerID PRIMARY KEY(UserID),
		CONSTRAINT FK_Customers_ShopID FOREIGN KEY(UserShop) REFERENCES Shops(ID)
    );
GO
--Om det inte finns något i tabellen Authors, lägg till.--
IF NOT EXISTS(SELECT * FROM Authors WHERE ID = 1)
BEGIN
	INSERT INTO Authors
	--ID, First Name, Last Name, Birthdate, Death date
	VALUES(1,'Karl','Marx','1818/05/05','1883/03/14'),
		(2,'Vilhelm','Moberg','1898/08/20','1973/08/08'),
		(3,'Karin','Boye','1900/10/26','1941/04/24'),
		(4,'Jo','Nesbø','1960/03/29',NULL);
END
--Om det inte finns något i tabellen Shops, lägg till.--
IF NOT EXISTS(SELECT * FROM Shops WHERE ID = 1)
BEGIN
	INSERT INTO Shops
	VALUES(1,'Adlibris','https://www.adlibris.com/se'),
		(2,'Akademibokhandeln','https://www.akademibokhandeln.se/'),
		(3,'Bokus','https://www.bokus.com/');
END
--Om det inte finns något i tabellen Books, lägg till.--
IF NOT EXISTS(SELECT * FROM Books WHERE AuthorID = 4)
BEGIN
	INSERT INTO Books
	--ISBN13, Title, Language, Price (in SEK), Release Date, AuthorID
	VALUES
		(9789174295559,'Rödhake','Swedish',75,'2016/08/10',(SELECT ID FROM Authors WHERE [First Name] = 'Jo' AND [Last Name] = 'Nesbø')),
		(9789100187804,'Kungariket','Swedish',120,'2021/03/01',(SELECT ID FROM Authors WHERE [First Name] = 'Jo' AND [Last Name] = 'Nesbø')),
		(9789174298116,'Kniv','Swedish',75,'2020/01/16',(SELECT ID FROM Authors WHERE [First Name] = 'Jo' AND [Last Name] = 'Nesbø')),
		(9781934568439,'Das Kapital','English',600,'2007/09/01',(SELECT ID FROM Authors WHERE [First Name] = 'Karl' AND [Last Name] = 'Marx')),
		(9789177813071,'Kommunistiska manifestet','Swedish',90,'2018/02/19',(SELECT ID FROM Authors WHERE [First Name] = 'Karl' AND [Last Name] = 'Marx')),
		(9789174297003,'Samlade dikter','Swedish',75,'2018/05/09',(SELECT ID FROM Authors WHERE [First Name] = 'Karin' AND [Last Name] = 'Boye')),
		(9789188275059,'Kallocain','Swedish',69,'2018/03/23',(SELECT ID FROM Authors WHERE [First Name] = 'Karin' AND [Last Name] = 'Boye')),
		(9789188753380,'Astarte','Swedish',69,'2021/02/17',(SELECT ID FROM Authors WHERE [First Name] = 'Karin' AND [Last Name] = 'Boye')),
		(9789188753502,'Kris','Swedish',69,'2022/02/24',(SELECT ID FROM Authors WHERE [First Name] = 'Karin' AND [Last Name] = 'Boye')),
		(9789186847425,'Ella gör sig fri','Swedish',59,'2012/02/14',(SELECT ID FROM Authors WHERE [First Name] = 'Karin' AND [Last Name] = 'Boye')),
		(9789174293081,'Utvandrarna','Swedish',75,'2013/01/15',(SELECT ID FROM Authors WHERE [First Name] = 'Vilhelm' AND [Last Name] = 'Moberg')),
		(9789174293098,'Invandrarna','Swedish',75,'2013/01/15',(SELECT ID FROM Authors WHERE [First Name] = 'Vilhelm' AND [Last Name] = 'Moberg')),
		(9789174293104,'Nybyggarna','Swedish',75,'2013/01/15',(SELECT ID FROM Authors WHERE [First Name] = 'Vilhelm' AND [Last Name] = 'Moberg')),
		(9789174293111,'Sista brevet till Sverige','Swedish',75,'2013/01/15',(SELECT ID FROM Authors WHERE [First Name] = 'Vilhelm' AND [Last Name] = 'Moberg'));
END
--Om det inte finns något i tabellen InventoryBalance, lägg till.--
IF NOT EXISTS(SELECT * FROM InventoryBalance WHERE ShopID = 1)
BEGIN
	INSERT INTO InventoryBalance
	--ID, ISBN, AMOUNT
	VALUES
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Rödhake'),44),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Rödhake'),90),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Rödhake'),34),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Kungariket'),76),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Kungariket'),85),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Kungariket'),97),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Kniv'),24),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Kniv'),25),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Kniv'),99),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Das Kapital'),60),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Das Kapital'),100),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Das Kapital'),53),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Kommunistiska manifestet'),47),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Kommunistiska manifestet'),14),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Kommunistiska manifestet'),46),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Samlade dikter'),63),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Samlade dikter'),65),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Samlade dikter'),37),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Kallocain'),17),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Kallocain'),97),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Kallocain'),80),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Astarte'),4),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Astarte'),97),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Astarte'),12),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Kris'),57),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Kris'),68),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Kris'),7),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Ella gör sig fri'),2),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Ella gör sig fri'),97),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Ella gör sig fri'),82),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Utvandrarna'),43),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Utvandrarna'),67),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Utvandrarna'),8),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Invandrarna'),84),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Invandrarna'),39),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Invandrarna'),99),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Nybyggarna'),35),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Nybyggarna'),49),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Nybyggarna'),61),
	((SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'),(SELECT ISBN13 FROM Books WHERE Title = 'Sista brevet till Sverige'),75),
	((SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),(SELECT ISBN13 FROM Books WHERE Title = 'Sista brevet till Sverige'),91),
	((SELECT ID FROM Shops WHERE Name LIKE 'Akademibokhandeln'),(SELECT ISBN13 FROM Books WHERE Title = 'Sista brevet till Sverige'),7);
END
--Om det inte finns något i tabellen Kunder, lägg till.--
IF NOT EXISTS(SELECT * FROM Customers WHERE UserID = 1)
BEGIN
	INSERT INTO Customers
	--ID, Shop, UserEmail, UserPassword, UserFirstName, UserLastName, UserCountry, UserCity, UserState, UserAdress, UserZipCode
	VALUES(1,(SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),'walterwhite1958@hotmail.com','password123','Walter','White','United States of America','Albuquerque','New Mexico','308 Negra Arroyo Lane','87104');
END
--Välja alla tabller--
--SELECT * FROM Authors;
--SELECT * FROM Books;
--SELECT * FROM Shops;

--Detta kan/ska konventeras till en vy--
SELECT	CONCAT([First Name],' ',[Last Name]) AS [Namn], 
		CONCAT(DATEDIFF(year,a.Birthdate,IsNULL(a.[Death Date],SYSDATETIME())),' år') AS [Ålder],
		CONCAT(COUNT(b.ISBN13),' st') AS [Böcker],
		CONCAT(SUM(i.Amount*b.Price),' kr') AS [Lagervärde]
	FROM InventoryBalance as i
	JOIN Books as b 
		ON b.ISBN13 = i.ISBN13
	JOIN Authors as a
		ON a.ID = b.AuthorID
	GROUP BY [First Name],[Last Name], a.Birthdate, a.[Death Date];