CREATE DATABASE Fabrika;
--�rnek ad�na yeni bir database olu�turmam�z� sa�lar

CREATE SCHEMA Uretim;
--Database alt�nda tablolar� gruplamak ad�na kullan�l�r.

CREATE TABLE Uretim.Kesimhane(
	[MODEL_ADI] NVARCHAR(30) PRIMARY KEY,
	--30 karakter s�n�rlamas� var fakat 15 karakter girildi�inde 15 karakterlik yer kapl�yor.
	--Nvarchar oldu�u i�in unicode karakterler kullan�labiliyor
	--Data tipinden sonra PK tan�mlanabilece�i gibi daha sonra da tan�mlanabilir
	
	MODEL_NO NUMERIC,
	--Virg�l ve �ok basamakl� olan say�sal de�erler bu �ekilde tan�mlanabilir.

	[MUSTERI] [VARCHAR](30),
	--8000 karaktere kadar kullan�labiliyor fakat unicode karakterler kullan�lam�yor.

	[MARKA] CHAR (25),
	--25 tan�mland��� i�in her hal�karda 25 karakterlik yer kapl�yor. Kullan�m� �ok yayg�n de�il
	
	ADET INT,

	FIYAT SMALLMONEY,
	--214478.3648 gibi bir say� tan�mlanm�� olup, parasal de�erler i�in kullan�labilir

	TERMIN DATE,
	--Zaman dilimleri i�in kullan�labilir. Sadece g�n/ay/y�l ifade eder

	TOPLAM_FIYAT BIGINT,
	--Kullan�labilecek en y�ksek int say�y� ifade eder

	--PRIMARY KEY ([MODEL ADI],MODEL_NO)
	--Composit primary key ifade ediyor olup, bu �ekilde en son yapmam�za da olanak sa�lar
);

CREATE TABLE Uretim.IK(
	TC BIGINT PRIMARY KEY,
	AD NVARCHAR(25) NULL,
	SOYAD NVARCHAR (20) NULL
);

CREATE TABLE Uretim.Uretim(
	TC BIGINT,
	MODEL_ADI NVARCHAR(30),
	BANT_NO TINYINT
	PRIMARY KEY (TC,MODEL_ADI)
);
CREATE TABLE Uretim.Diger(
	S_NO INT PRIMARY KEY IDENTITY(1,1)
	-- Primary keyde 1 den ba�layarak 1-1 artarak ilerle
);
ALTER TABLE Uretim.Uretim ADD CONSTRAINT fk_TC FOREIGN KEY (TC) references Uretim.IK (TC);
--Alter ile k�s�t ekleme, ��karma i�lemleri yap�labilmektedir.
--Foreign key i�in �ncelikle hangi tabloya eklenecekse o yaz�lmal�, k�s�t ad� yaz�ld�ktan sonra foreign key belirtilmesini
--	m�teakip parantez i�inde ilgili i�lemler yap�lmal�d�r.
ALTER TABLE Uretim.Uretim ADD CONSTRAINT fk_model FOREIGN KEY (MODEL_ADI) references Uretim.Kesimhane (MODEL_ADI)
ON UPDATE NO ACTION
ON DELETE CASCADE
--Update ve delete durumunda yap�lmas� gereken i�lemler foreign key ile belirlenebilir. Cascade ne yap�l�yorsa aynen uygula demek


ALTER TABLE Uretim.IK ADD CONSTRAINT fk_TC_Check CHECK (TC BETWEEN 10000000000 AND 99999999999)
--Bu �ekilde TC i�in 11 hanelik bir k�s�t getirilmi� oldu

ALTER TABLE Uretim.IK ALTER COLUMN AD VARCHAR(20) NOT NULL;
--�retim.IK tablsundaki AD s�tunun de�i�iklik bu �ekilde sonradan da yap�labiliyor

INSERT Uretim.IK VALUES (12345678901,'AL�','VEL�');
INSERT Uretim.IK VALUES (12345678902,'CAN');--HATA VER�YOR ��NK� SOYAD YAZILMADI
INSERT INTO Uretim.IK (TC,AD)VALUES (12345678903,'MEHMET');
INSERT Uretim.IK (TC,AD) VALUES
(12345678904,'KER�M'),
(12345678905,'AHMET'),
(12345678906,'AL�');
--Yukar�da belirtildi�i �zere 4 farkl� �ekilde tabloya veri giri�i yap�labilmektedir.
--E�er spesifik columna ekleme yap�lamayacak sa into denmesine gerek yok

SELECT TC,AD INTO YeniTablo FROM Uretim.IK
--Select into ile bir tablodan istedi�imiz s�tunlar� yeni bir tablo olu�turarak kopyalayabiliyoruz.
--INTO dan sonra yeni tablonun ismi yaz�lmal�

INSERT YeniTablo SELECT TC,AD FROM Uretim.IK WHERE AD like 'Me%'
--TC'yi primary key olarak tan�mlamad���m�z i�in ayn� veriyi kopyalayabildik.
--E�erki sadece belirli columnlar se�ildiyse selectten sonra bunlar belirtilmeli

UPDATE YeniTablo SET AD = '�SMA�L' WHERE AD = 'SERDAR'
--Bu �ekilde tablo i�indeki veri de�i�tirilebilmekte

UPDATE YeniTablo SET AD = (SELECT AD FROM Uretim.IK WHERE AD = 'SERDAR') WHERE AD = '�SMA�L'
--Bu �ekilde ba�ka tablodan veri �ekilerek de�i�im yap�labildi

DELETE FROM YeniTablo
--Tablonun i�ini bo�alt�r fakat identity olmas� halinde identity kald��� eyrden devam eder

DROP TABLE YeniTablo;
--Tabloyu ortadan kald�r�r

TRUNCATE TABLE Uretim.IK;
--Tablonun i�ini bo�alt�r

DROP DATABASE Fabrika;
--Database i siler