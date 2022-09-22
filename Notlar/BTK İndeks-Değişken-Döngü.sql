
--------------------------BTK KURS NOTLAR-------------------------



--1. DEÐÝÞKEN TANIMLAMA
USE SampleRetail
DECLARE @PRICE AS FLOAT,
@ISIM AS VARCHAR (20) = 'ISMAIL'
SET @PRICE = (SELECT AVG(list_price) FROM product.product)
SELECT @PRICE, @ISIM
--Hepsini birlikte execute etmek zorundasýn. Diðer türlü hata veriyor

DECLARE @NAME AS VARCHAR(100),
@YEAR AS INT
SELECT
@NAME = product_name, @YEAR = model_year --Bu þekilde de deðiþkene veri atanabiliyor
FROM product.product
WHERE product_id = 1

SELECT @NAME,@YEAR


--2. DÖNGÜLER

USE SampleRetail
CREATE TABLE tarih(
ýd INT IDENTITY (1,1),
tarih2 DATETIME)
DECLARE @I AS INT = 0
WHILE @I < 10
BEGIN
	INSERT INTO tarih VALUES (GETDATE()) --Bu þekilde veri atanabildiði gibi PRINT ile yazdýrýlabiliyorda
	WAITFOR DELAY '00:00:01' --Her 1 saniyede 1 veri atmamýzý saðladý
	SET @I = @I+1
END
SELECT * FROM tarih
DROP TABLE tarih

---ÖRNEK2
USE ETRADE
DECLARE @NAME VARCHAR(40), @SEHIR VARCHAR (20), @DOGUM DATE, @YAS INT, @YASGRUBU VARCHAR(30), @I INT = 0
WHILE @I < 1
BEGIN
SELECT @NAME = CUSTOMERNAME FROM CUSTOMERS WHERE ID = ROUND(RAND()*999,0)
SELECT @SEHIR = CITY FROM CUSTOMERS WHERE ID = ROUND(RAND()*999,0)
SELECT @DOGUM = BIRTHDATE FROM CUSTOMERS WHERE ID = ROUND(RAND()*999,0)
SET @YAS = DATEDIFF(YEAR,@DOGUM,GETDATE())
IF @YAS <= 40
	SET @YASGRUBU = '40 YAÞ ALTI'
ELSE SET @YASGRUBU = '40 YAÞ ÜSTÜ'
SET @I = @I+1
END
SELECT @NAME, @SEHIR, @DOGUM, @YAS, @YASGRUBU --Bunu istediðin eyrde kullanabilirsin




------INDEKSLEME

USE CRM
SP_SPACEUSED CUSTOMERS -- Tablo hakkýnda bilgi verir

SET STATISTICS IO ON
SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'ÖMER ÇOLAKOÐLU'
--NONCLUSTERED INDEX OLMADAN 54061 ADET ARAMA YAPTI

CREATE NONCLUSTERED INDEX IX1 on CUSTOMERS
(
NAMESURNAME
)
SET STATISTICS IO ON
SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'ÖMER ÇOLAKOÐLU'
--ARAMA 6 SAYFAYA DÜÞTÜ. NON-CLUSTERED INDEX TEN SONRA HIZ ÝNANILMAZ ARTTI
--indeksleme.
--Properties altýnda Fregmentation içinde page fullness ile gösterilmekte. 
--Bu kýsým bizim aramalardaki hýzýmýzý önemli ölçüde artýrmaktadýr.

--rebuild
--Ýçerideki index bozulmalarý düzeltme yollarýndan biridir. Reorganize'a göre daha uzun sürer 
--Dökülen sayfalarý masa dýþýnda yeniden düzenlemek gibi.Fregmentation %40 üstünde

--reorganize
--Ýçerideki index bozulmalarý düzeltme yollarýndan biridir. Düzenlemeyi daha kýsa sürede yapmayý saðlar. 
--Dökülen sayfalarý masa üstünde düzenlemek gibi.Fregmentation %40 altýnda

--fill factor
--Properties-Options-Fill factor
--Ýndeks bozulmalarýnýn önüne geçmek adýna boþuk býrakýyor. Sonradan dolum olsa dahi bozulmalarýn önüne geçiliyor.
--Sayfada boþluk býrakmak gibi

--SERVER OTOMATÝK FILL FACTOR
--Server properties içinde database settings altýnda fill factor belirlenerek otomatik fill factor belirlenebilir
CREATE NONCLUSTERED INDEX IX2 on CUSTOMERS
(
BIRTHDATE
) WITH (FILLFACTOR = 70)


SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME = 'ÖMER ÇOLAKOÐLU'

--Herbir tablonun altýnda indexes dosyasý içerisinde oluþturulan indeksler özelinde hazýrlanmýþ istatistikler tablosu vardýr.
--Veri giriþi olmasý durumunda buranýn güncellenmesi gerekir ki güncellenmediði takdirde sistemi zorlayýcý durumlar oluþabilir.
--Ýstatistikleri güncellemenin yollarý rebuild, reorganize olup ayrýca
--	SP_UPDATESTATS VE UPDATE STATISTICS __TABLE_NAME___
