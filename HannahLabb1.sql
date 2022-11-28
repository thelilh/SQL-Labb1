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
--Om vi inte har en 'publisher' tabell ska den skapas.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Publisher' and xtype='U')
	CREATE TABLE Publisher(
		ID integer, --Unikt ID för det förelaget
		Name nvarchar(max), --Namnet för förelaget
		CONSTRAINT PK_Publisher_ID PRIMARY KEY(ID) --Använd det Unika ID som PK
	);
GO
--Om vi inte har en 'BookType' tabell ska den skapas.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='BookType' and xtype='U')
	CREATE TABLE BookType(
		ID integer, --Unikt ID för den boktypen
		Name nvarchar(max), --Namnet för boktypen
		CONSTRAINT PK_BookType_ID PRIMARY KEY(ID) --Använd det Unika ID som PK
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
		[Publisher] integer NOT NULL,
		[BookType] integer NOT NULL,
		CONSTRAINT PK_Books_ISBN13 PRIMARY KEY(ISBN13),
		CONSTRAINT FK_Books_Publisher FOREIGN KEY (Publisher) REFERENCES Publisher(ID),
		CONSTRAINT FK_Books_Type FOREIGN KEY (BookType) REFERENCES BookType(ID)
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
		Shop integer NOT NULL,
		ISBN13 BIGINT NOT NULL,
		Amount integer NOT NULL,
		CONSTRAINT PK_Inventory_ID PRIMARY KEY(Shop,ISBN13),
		CONSTRAINT FK_Inventory_ISBN13 FOREIGN KEY(ISBN13) REFERENCES Books(ISBN13),
		CONSTRAINT FK_Inventory_Shop FOREIGN KEY(Shop) REFERENCES Shops(ID)
    );
GO
--Om Customers inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Customers' and xtype='U')
    CREATE TABLE Customers (
		ID integer NOT NULL,
		Shop integer NOT NULL, --Vilken butik tillhör användaren?
		Email nvarchar(max) NOT NULL, --Perfekt, användaren kan få sin email som login
		Password nvarchar(max) NOT NULL, --Vad menar du att detta är en säkerhetsrisk?
		FirstName nvarchar(max) NOT NULL, --Användarens namn
		LastName nvarchar(max) NOT NULL, --Användarens efternamn
		Country nvarchar(max) NOT NULL, --Användarens land
		City nvarchar(max) NOT NULL, --Användarens stad
		State nvarchar(max) NOT NULL, --Användarens region
		Adress nvarchar(max) NOT NULL, --Användarens adress
		ZipCode nvarchar(12) NOT NULL, --Detta är en nvarchar då Storbritannien, som exempel, har OX9 1AA
		CONSTRAINT PK_CustomerID PRIMARY KEY(ID),
		CONSTRAINT FK_Customers_Shop FOREIGN KEY(Shop) REFERENCES Shops(ID)
    );
GO
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='BooksWithManyAuthors' and xtype='U')
	CREATE TABLE BooksWithManyAuthors(
		Author integer NOT NULL,
		Book BIGINT NOT NULL,
		CONSTRAINT PK_BooksWithManyAuthors_ID PRIMARY KEY(Author,Book)
	);
GO
--Om vi inte har en 'orders' tabell ska den skapas.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Orders' and xtype='U')
	CREATE TABLE Orders(
		OrderID BIGINT, --Unikt ID för JUST DEN beställningen.
		OrderUser integer, --Vilken användare beställer?
		OrderBook BIGINT, --Vilken bok beställs?
		OrderShop integer, --Varifrån beställdes boken?
		CONSTRAINT PK_Orders_Number PRIMARY KEY(OrderID), --Använd det Unika ID som PK
		CONSTRAINT FK_Orders_Book FOREIGN KEY(OrderBook) REFERENCES Books(ISBN13), --Hämta Bokens ISBN13 från tabellen Books
		CONSTRAINT FK_Orders_User FOREIGN KEY(OrderUser) REFERENCES Customers(ID), --Hämta Användarens ID från tabellen Customers
		CONSTRAINT FK_Orders_Shop FOREIGN KEY(OrderShop) REFERENCES Shops(ID) --Hämta Affärens ID från tabellen Shops
	);
GO
--Om det inte finns något i tabellen Authors, lägg till.--
IF NOT EXISTS(SELECT * FROM Authors WHERE ID = 1)
	INSERT INTO Authors
	--ID, First Name, Last Name, Birthdate, Death date
	VALUES(1,'Karl','Marx','1818/05/05','1883/03/14'),
		(2,'Vilhelm','Moberg','1898/08/20','1973/08/08'),
		(3,'Karin','Boye','1900/10/26','1941/04/24'),
		(4,'Jo','Nesbø','1960/03/29',NULL),
		(5,'Friedrich','Engels','1820/11/28','1895/08/05');
--Om det inte finns något i tabellen Shops, lägg till.--
IF NOT EXISTS(SELECT * FROM Shops WHERE ID = 1)
	INSERT INTO Shops
	VALUES(1,'Adlibris','https://www.adlibris.com/se'),
		(2,'Akademibokhandeln','https://www.akademibokhandeln.se/'),
		(3,'Bokus','https://www.bokus.com/');
--Om det inte finns något i tabellen Publisher, lägg till--
IF NOT EXISTS(SELECT * FROM Publisher WHERE ID = 1)
	INSERT INTO Publisher
	-- ID, Name
	VALUES	(1,'Kommunisternas Bokförlag'),
			(2,'Förelaget för Svenska Böker'),
			(3,'Det Nordiska Förelaget');
--Om det inte finns något i tabellen BookType, lägg till--
IF NOT EXISTS(SELECT * FROM BookType WHERE ID = 1)
	INSERT INTO BookType
	-- ID, Namn
	VALUES	(1,'Pocket'),
			(2,'Inbunden'),
			(3,'E-bok'),
			(4,'Ljudbok');
--Om det inte finns något i tabellen Books, lägg till.--
IF NOT EXISTS(SELECT * FROM Books WHERE ISBN13 = 9789174295559)
	INSERT INTO Books
	--ISBN13, Title, Language, Price (in SEK), Release Date, AuthorID
	VALUES
		(9789174295559,'Rödhake','Swedish',75,'2016/08/10',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Nordiska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Inbunden')),
		(9789100187804,'Kungariket','Swedish',120,'2021/03/01',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Nordiska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Inbunden')),
		(9789174298116,'Kniv','Swedish',75,'2020/01/16',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Nordiska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Inbunden')),
		(9781934568439,'Das Kapital','English',600,'2007/09/01',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Kommunisternas%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Inbunden')),
		(9789177813071,'Kommunistiska manifestet','Swedish',90,'2018/02/19',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Kommunisternas%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Inbunden')),
		(9789174297003,'Samlade dikter','Swedish',75,'2018/05/09',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789188275059,'Kallocain','Swedish',69,'2018/03/23',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789188753380,'Astarte','Swedish',69,'2021/02/17',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789188753502,'Kris','Swedish',69,'2022/02/24',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789186847425,'Ella gör sig fri','Swedish',59,'2012/02/14',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789174293081,'Utvandrarna','Swedish',75,'2013/01/15',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789174293098,'Invandrarna','Swedish',75,'2013/01/15',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789174293104,'Nybyggarna','Swedish',75,'2013/01/15',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket')),
		(9789174293111,'Sista brevet till Sverige','Swedish',75,'2013/01/15',
			(SELECT ID FROM Publisher WHERE Name LIKE '%Svenska%'),
			(SELECT ID FROM BookType WHERE Name LIKE 'Pocket'));
--Om det inte finns något i tabellen InventoryBalance, lägg till.--
IF NOT EXISTS(SELECT * FROM InventoryBalance WHERE Shop = 1)
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
--Om det inte finns något i tabellen Kunder, lägg till.--
IF NOT EXISTS(SELECT * FROM Customers WHERE ID = 1)
	INSERT INTO Customers
	--ID, Shop, UserEmail, UserPassword, UserFirstName, UserLastName, UserCountry, UserCity, UserState, UserAdress, UserZipCode
	VALUES
		(1,
			(SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),
			'walterwhite1958@hotmail.com',
			'password123',
			'Walter',
			'White',
			'United States of America',
			'Albuquerque',
			'New Mexico',
			'308 Negra Arroyo Lane',
			'87104'),
		(2,
			(SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),
			'glenn.glensson@gmail.com',
			'BlaVit1904',
			'Glenn',
			'Glennson',
			'Sverige',
			'Göteborg',
			'Västra Götaland',
			'Göteborgsstigen 3',
			'40040'),
		(3,
			(SELECT ID FROM Shops WHERE Name LIKE 'Bokus'),
			'agda.ingvarsson1936@gmail.com',
			'Kurt123',
			'Agda',
			'Ingvarsson',
			'Sverige',
			'Åmål',
			'Västra Götaland',
			'Åmålvägen 20',
			'60030');
			
--Om det inte finns något i tabellen Orders, lägg till.--
IF NOT EXISTS(SELECT * FROM Orders WHERE OrderID = 1)
	INSERT INTO Orders
	-- OrderID, OrderUser, OrderBook, OrderShop 
	VALUES	(1, 
			(SELECT ID FROM Customers WHERE FirstName LIKE 'Walter' AND LastName LIKE 'White'), 
			(SELECT ISBN13 FROM Books WHERE Title LIKE 'Das Kapital'),
			(SELECT ID FROM Shops WHERE Name LIKE 'Adlibris')),

			(2, 
			(SELECT ID FROM Customers WHERE FirstName LIKE 'Agda' AND LastName LIKE 'Ingvarsson'), 
			(SELECT ISBN13 FROM Books WHERE Title LIKE 'Kniv'),
			(SELECT ID FROM Shops WHERE Name LIKE 'Adlibris'));
--Avkommentera följande för att flytta en bok--
--DECLARE @ShopFrom integer = (SELECT ID FROM Shops WHERE Name LIKE 'Bokus');
--DECLARE @ShopTo integer = (SELECT ID FROM Shops WHERE Name LIKE 'Adlibris');
--DECLARE @BookToMove BIGINT = (SELECT ISBN13 FROM Books WHERE Title LIKE 'Das Kapital');
--EXEC [sp_FlyttaBok] @MoveFrom = @ShopFrom, @MoveTo = @ShopTo, @ISBN13 = @BookToMove, @Amount = 20; 

--Skapa 'many-to-many' relationen mellan böcker och författare
--Om Tabellen Shops inte finns, skapa den.--

IF NOT EXISTS(SELECT * FROM BooksWithManyAuthors WHERE Author = 1)
	INSERT INTO BooksWithManyAuthors 
	VALUES
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karl' AND [Last Name] LIKE 'Marx'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Das Kapital')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karl' AND [Last Name] LIKE 'Marx'),(SELECT ISBN13 FROM Books WHERE Title LIKE '%Kommunistiska%')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Friedrich' AND [Last Name] LIKE 'Engels'),(SELECT ISBN13 FROM Books WHERE Title LIKE '%Kommunistiska%')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Jo' AND [Last Name] LIKE 'Nesbø'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Rödhake')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Jo' AND [Last Name] LIKE 'Nesbø'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Kungariket')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Jo' AND [Last Name] LIKE 'Nesbø'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Kniv')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karin' AND [Last Name] LIKE 'Boye'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Samlade Dikter')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karin' AND [Last Name] LIKE 'Boye'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Kallocain')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karin' AND [Last Name] LIKE 'Boye'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Astarte')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karin' AND [Last Name] LIKE 'Boye'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Kris')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Karin' AND [Last Name] LIKE 'Boye'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Ella gör sig fri')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Vilhelm' AND [Last Name] LIKE 'Moberg'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Utvandrarna')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Vilhelm' AND [Last Name] LIKE 'Moberg'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Invandrarna')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Vilhelm' AND [Last Name] LIKE 'Moberg'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Nybyggarna')),
			((SELECT ID FROM Authors WHERE [First Name] LIKE 'Vilhelm' AND [Last Name] LIKE 'Moberg'),(SELECT ISBN13 FROM Books WHERE Title LIKE 'Sista brevet till Sverige'));
--Välj från Vyn 'TitlesPerAuthors'
SELECT * 
FROM [TitlesPerAuthors];

SELECT * 
FROM [BookView]
ORDER BY Title;
