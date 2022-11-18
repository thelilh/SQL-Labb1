--Om Databasen BookstoreDb inte finns, skapa den.--
IF DB_ID (N'BookstoreDb') IS NULL
	CREATE DATABASE BookstoreDb;
GO
--Använd Databasen BookstoreDb.--
USE BookstoreDb;
--Om Tabellen Authors inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Authors' and xtype='U')
    CREATE TABLE Authors (
		ID integer NOT NULL PRIMARY KEY,
		[First Name] nvarchar(max) NOT NULL,
		[Last Name] nvarchar(max) NOT NULL,
		[Birthdate] DATETIME NOT NULL
    );
GO
--Om Tabellen Books inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Books' and xtype='U')
    CREATE TABLE Books (
		ISBN13 BIGINT NOT NULL PRIMARY KEY,
		[Title] nvarchar(max) NOT NULL,
		[Language] nvarchar(max) NOT NULL,
		[Price] integer NOT NULL,
		[Date] nvarchar(max) NOT NULL,
		[AuthorID] integer NOT NULL,
		FOREIGN KEY (AuthorID) REFERENCES Authors(ID)
    );
GO
--Om Tabellen Shops inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Shops' and xtype='U')
    CREATE TABLE Shops (
		ID integer NOT NULL PRIMARY KEY,
		[Name] nvarchar(max) NOT NULL,
		[Website] nvarchar(max) NOT NULL
    );
GO
--Om InventoryBalance inte finns, skapa den.--
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InventoryBalance' and xtype='U')
    CREATE TABLE InventoryBalance (
		ID integer NOT NULL,
		ISBN13 BIGINT NOT NULL,
		Amount integer NOT NULL,
		PRIMARY KEY(ID,ISBN13)
    );
GO
--Om det inte finns något i tabellen Authors, lägg till.--
IF NOT EXISTS(SELECT * FROM Authors WHERE ID = 1)
BEGIN
	INSERT INTO Authors
	VALUES(1,'Karl','Marx','1818/05/05'),
		(2,'Karin','Boye','1900/10/26'),
		(3,'Vilhelm','Moberg','1898/08/20'),
		(4,'Jo','Nesbø','1960/03/29');
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
--Välja alla tabller--
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Shops;
SELECT * FROM InventoryBalance;