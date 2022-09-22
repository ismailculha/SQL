
--------------------------BTK KURS NOTLAR-------------------------



--1. DE���KEN TANIMLAMA
USE SampleRetail
DECLARE @PRICE AS FLOAT,
@ISIM AS VARCHAR (20) = 'ISMAIL'
SET @PRICE = (SELECT AVG(list_price) FROM product.product)
SELECT @PRICE, @ISIM
--Hepsini birlikte execute etmek zorundas�n. Di�er t�rl� hata veriyor

DECLARE @NAME AS VARCHAR(100),
@YEAR AS INT
SELECT
@NAME = product_name, @YEAR = model_year --Bu �ekilde de de�i�kene veri atanabiliyor
FROM product.product
WHERE product_id = 1

SELECT @NAME,@YEAR


--2. D�NG�LER

USE SampleRetail
CREATE TABLE tarih(
�d INT IDENTITY (1,1),
tarih2 DATETIME)
DECLARE @I AS INT = 0
WHILE @I < 10
BEGIN
	INSERT INTO tarih VALUES (GETDATE()) --Bu �ekilde veri atanabildi�i gibi PRINT ile yazd�r�labiliyorda
	WAITFOR DELAY '00:00:01' --Her 1 saniyede 1 veri atmam�z� sa�lad�
	SET @I = @I+1
END
SELECT * FROM tarih
DROP TABLE tarih

---�RNEK2
USE ETRADE
DECLARE @NAME VARCHAR(40), @SEHIR VARCHAR (20), @DOGUM DATE, @YAS INT, @YASGRUBU VARCHAR(30), @I INT = 0
WHILE @I < 1
BEGIN
SELECT @NAME = CUSTOMERNAME FROM CUSTOMERS WHERE ID = ROUND(RAND()*999,0)
SELECT @SEHIR = CITY FROM CUSTOMERS WHERE ID = ROUND(RAND()*999,0)
SELECT @DOGUM = BIRTHDATE FROM CUSTOMERS WHERE ID = ROUND(RAND()*999,0)
SET @YAS = DATEDIFF(YEAR,@DOGUM,GETDATE())
IF @YAS <= 40
	SET @YASGRUBU = '40 YA� ALTI'
ELSE SET @YASGRUBU = '40 YA� �ST�'
SET @I = @I+1
END
SELECT @NAME, @SEHIR, @DOGUM, @YAS, @YASGRUBU --Bunu istedi�in eyrde kullanabilirsin




------INDEKSLEME

USE CRM
SP_SPACEUSED CUSTOMERS -- Tablo hakk�nda bilgi verir

SET STATISTICS IO ON
SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME LIKE '�MER �OLAKO�LU'
--NONCLUSTERED INDEX OLMADAN 54061 ADET ARAMA YAPTI

CREATE NONCLUSTERED INDEX IX1 on CUSTOMERS
(
NAMESURNAME
)
SET STATISTICS IO ON
SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME LIKE '�MER �OLAKO�LU'
--ARAMA 6 SAYFAYA D��T�. NON-CLUSTERED INDEX TEN SONRA HIZ �NANILMAZ ARTTI
--indeksleme.
--Properties alt�nda Fregmentation i�inde page fullness ile g�sterilmekte. 
--Bu k�s�m bizim aramalardaki h�z�m�z� �nemli �l��de art�rmaktad�r.

--rebuild
--��erideki index bozulmalar� d�zeltme yollar�ndan biridir. Reorganize'a g�re daha uzun s�rer 
--D�k�len sayfalar� masa d���nda yeniden d�zenlemek gibi.Fregmentation %40 �st�nde

--reorganize
--��erideki index bozulmalar� d�zeltme yollar�ndan biridir. D�zenlemeyi daha k�sa s�rede yapmay� sa�lar. 
--D�k�len sayfalar� masa �st�nde d�zenlemek gibi.Fregmentation %40 alt�nda

--fill factor
--Properties-Options-Fill factor
--�ndeks bozulmalar�n�n �n�ne ge�mek ad�na bo�uk b�rak�yor. Sonradan dolum olsa dahi bozulmalar�n �n�ne ge�iliyor.
--Sayfada bo�luk b�rakmak gibi

--SERVER OTOMAT�K FILL FACTOR
--Server properties i�inde database settings alt�nda fill factor belirlenerek otomatik fill factor belirlenebilir
CREATE NONCLUSTERED INDEX IX2 on CUSTOMERS
(
BIRTHDATE
) WITH (FILLFACTOR = 70)


SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME = '�MER �OLAKO�LU'

--Herbir tablonun alt�nda indexes dosyas� i�erisinde olu�turulan indeksler �zelinde haz�rlanm�� istatistikler tablosu vard�r.
--Veri giri�i olmas� durumunda buran�n g�ncellenmesi gerekir ki g�ncellenmedi�i takdirde sistemi zorlay�c� durumlar olu�abilir.
--�statistikleri g�ncellemenin yollar� rebuild, reorganize olup ayr�ca
--	SP_UPDATESTATS VE UPDATE STATISTICS __TABLE_NAME___
