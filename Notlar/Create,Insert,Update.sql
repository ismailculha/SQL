CREATE DATABASE Fabrika;
--Örnek adýna yeni bir database oluþturmamýzý saðlar

CREATE SCHEMA Uretim;
--Database altýnda tablolarý gruplamak adýna kullanýlýr.

CREATE TABLE Uretim.Kesimhane(
	[MODEL_ADI] NVARCHAR(30) PRIMARY KEY,
	--30 karakter sýnýrlamasý var fakat 15 karakter girildiðinde 15 karakterlik yer kaplýyor.
	--Nvarchar olduðu için unicode karakterler kullanýlabiliyor
	--Data tipinden sonra PK tanýmlanabileceði gibi daha sonra da tanýmlanabilir
	
	MODEL_NO NUMERIC,
	--Virgül ve çok basamaklý olan sayýsal deðerler bu þekilde tanýmlanabilir.

	[MUSTERI] [VARCHAR](30),
	--8000 karaktere kadar kullanýlabiliyor fakat unicode karakterler kullanýlamýyor.

	[MARKA] CHAR (25),
	--25 tanýmlandýðý için her halükarda 25 karakterlik yer kaplýyor. Kullanýmý çok yaygýn deðil
	
	ADET INT,

	FIYAT SMALLMONEY,
	--214478.3648 gibi bir sayý tanýmlanmýþ olup, parasal deðerler için kullanýlabilir

	TERMIN DATE,
	--Zaman dilimleri için kullanýlabilir. Sadece gün/ay/yýl ifade eder

	TOPLAM_FIYAT BIGINT,
	--Kullanýlabilecek en yüksek int sayýyý ifade eder

	--PRIMARY KEY ([MODEL ADI],MODEL_NO)
	--Composit primary key ifade ediyor olup, bu þekilde en son yapmamýza da olanak saðlar
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
	-- Primary keyde 1 den baþlayarak 1-1 artarak ilerle
);
ALTER TABLE Uretim.Uretim ADD CONSTRAINT fk_TC FOREIGN KEY (TC) references Uretim.IK (TC);
--Alter ile kýsýt ekleme, çýkarma iþlemleri yapýlabilmektedir.
--Foreign key için öncelikle hangi tabloya eklenecekse o yazýlmalý, kýsýt adý yazýldýktan sonra foreign key belirtilmesini
--	müteakip parantez içinde ilgili iþlemler yapýlmalýdýr.
ALTER TABLE Uretim.Uretim ADD CONSTRAINT fk_model FOREIGN KEY (MODEL_ADI) references Uretim.Kesimhane (MODEL_ADI)
ON UPDATE NO ACTION
ON DELETE CASCADE
--Update ve delete durumunda yapýlmasý gereken iþlemler foreign key ile belirlenebilir. Cascade ne yapýlýyorsa aynen uygula demek


ALTER TABLE Uretim.IK ADD CONSTRAINT fk_TC_Check CHECK (TC BETWEEN 10000000000 AND 99999999999)
--Bu þekilde TC için 11 hanelik bir kýsýt getirilmiþ oldu

ALTER TABLE Uretim.IK ALTER COLUMN AD VARCHAR(20) NOT NULL;
--Üretim.IK tablsundaki AD sütunun deðiþiklik bu þekilde sonradan da yapýlabiliyor

INSERT Uretim.IK VALUES (12345678901,'ALÝ','VELÝ');
INSERT Uretim.IK VALUES (12345678902,'CAN');--HATA VERÝYOR ÇÜNKÜ SOYAD YAZILMADI
INSERT INTO Uretim.IK (TC,AD)VALUES (12345678903,'MEHMET');
INSERT Uretim.IK (TC,AD) VALUES
(12345678904,'KERÝM'),
(12345678905,'AHMET'),
(12345678906,'ALÝ');
--Yukarýda belirtildiði üzere 4 farklý þekilde tabloya veri giriþi yapýlabilmektedir.
--Eðer spesifik columna ekleme yapýlamayacak sa into denmesine gerek yok

SELECT TC,AD INTO YeniTablo FROM Uretim.IK
--Select into ile bir tablodan istediðimiz sütunlarý yeni bir tablo oluþturarak kopyalayabiliyoruz.
--INTO dan sonra yeni tablonun ismi yazýlmalý

INSERT YeniTablo SELECT TC,AD FROM Uretim.IK WHERE AD like 'Me%'
--TC'yi primary key olarak tanýmlamadýðýmýz için ayný veriyi kopyalayabildik.
--Eðerki sadece belirli columnlar seçildiyse selectten sonra bunlar belirtilmeli

UPDATE YeniTablo SET AD = 'ÝSMAÝL' WHERE AD = 'SERDAR'
--Bu þekilde tablo içindeki veri deðiþtirilebilmekte

UPDATE YeniTablo SET AD = (SELECT AD FROM Uretim.IK WHERE AD = 'SERDAR') WHERE AD = 'ÝSMAÝL'
--Bu þekilde baþka tablodan veri çekilerek deðiþim yapýlabildi

DELETE FROM YeniTablo
--Tablonun içini boþaltýr fakat identity olmasý halinde identity kaldýðý eyrden devam eder

DROP TABLE YeniTablo;
--Tabloyu ortadan kaldýrýr

TRUNCATE TABLE Uretim.IK;
--Tablonun içini boþaltýr

DROP DATABASE Fabrika;
--Database i siler