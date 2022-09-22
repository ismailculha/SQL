
------- DATE FUNCTIONS ---------

SELECT GETDATE() AS DAY_--2022-06-07 05:55:52.153
SELECT GETUTCDATE()--2022-06-07 02:55:47.267
-- Anlýk tarih ve zamanný otomatik getirmemizi saðlar, Utcdate ise utc'deki zamaný almamýzý saðlar

SELECT DATENAME(WEEK, '2022-06-07')--24
SELECT DATENAME(MONTH, '2022-06-07')--June
SELECT DATENAME(DAYOFYEAR, '2022-06-07')--158
SELECT DATENAME(WEEKDAY, '2022-06-07')--Tuesday
SELECT DATENAME(DAY, '2022-06-07')--7
--Ýçerisinde Year,Quarter, Month, Dayofyear, Day, Week, Weekday, Hour, Minute, Second ve Millisecond olmak üzere bütün veriler alýnabiliyor.
--Nvarcahar olarak döndürüyor

SELECT DATEPART(WEEKDAY, '2022-06-07')--3
SELECT DATEPART(WEEK,'2022-06-07')--24
--Ayný datename gibi fakat nvarchar deðil, int döndürüyor
--Ýçerisinde Year,Quarter, Month, Dayofyear, Day, Week, Weekday, Hour, Minute, Second ve Millisecond olmak üzere bütün veriler alýnabiliyor.

SELECT DAY(GETDATE()) AS DAY_;--7
SELECT MONTH(GETDATE()) AS MONTH_;--6
SELECT YEAR(GETDATE()) AS MONTH_;--2022
--Belirtilen tarih foramtýnda ilgili gün, ay ve yýl bilgilerini bize verir

SELECT DATEDIFF(SECOND, '1991-09-21', GETDATE());--969170083
SELECT DATEDIFF(MINUTE, '1991-09-21', GETDATE());--16152834
SELECT DATEDIFF(DAY, '1991-09-21', GETDATE());--11217
SELECT DATEDIFF(WEEK, '1991-09-21', GETDATE());--1603
SELECT DATEDIFF(YEAR, '1991-09-21', GETDATE());--31
--Belirtilen interval aralýðýnda aradaki farký döndürmemizi saðlar

SELECT DATEADD(SECOND, 20, '1991-09-21')--1991-09-21 00:00:20.000
SELECT DATEADD(DAY, -20, '1991-09-21')--1991-09-01 00:00:00.000
--Belitilen iinterval aralýðýnda gün ekleme, çýkarma yapmamýzý saðlar

SELECT EOMONTH('2021-02-10') AS EndofFeb--2021-02-28
SELECT EOMONTH(GETDATE(),2)--2022-08-31
--Tek baþýna tarih yazýldýðýnda ayýn kaç gün çektiði bilgisini verir. 
--Yanýna int aldýðýnda o kadar ay sonrasýnýn kaç gün çektiði bilgisini verir.

SELECT ISDATE('21.09.1991')--0
SELECT ISDATE('2022-06-06')--1
--Ýçerisinde nvarchar alýyor, buna göre eðer nvarchar formatý doðruysa 0,1 olarak veri döndürüyor

SELECT CONVERT (DATE, '04 Jun 22', 6) --2022-06-04
--Burada 6 içerdeki varcharýn tipi olmalý, baþka bir þey yazdýðýnda olmuyor
SELECT CONVERT (VARCHAR(10), GETDATE(), 6) --07 Jun 22
--Getdate i hangi formatta görmek istediðimizi 6 ile belirtiyoruz

SELECT DATEFROMPARTS(2021,5,28)--2021-05-28
--Ýçerisine 3 parametre alýyor. Sýrasý ile year, month, day
SELECT DATETIMEFROMPARTS(2021,5,28,12,0,05,011)--2021-05-28 12:00:05.010
--Ýçerisine aldýðý 7 parametreyi datetime olarak döndürüyor


----------- STRING FUNCTIONS -------------


SELECT LEN('ÝSMAÝL')--6
SELECT LEN(NULL)--NULL
SELECT LEN(10.2)--4
--Ýçerisine aldýðý nvarcharýn uzunluðunu int olarak döndürür, içinde null varsa sonucu null olarak döndürür. Numeric olsa dahi

SELECT CHARINDEX('i','ismail')--1
SELECT CHARINDEX('Ý','ismail',2)--5
SELECT CHARINDEX('ma',null)--NULL
SELECT CHARINDEX('self', 'Reinvent yourself and ourself') AS motto;--14
SELECT CHARINDEX('self', 'Reinvent yourself and ourself', 15) AS motto;--26
--Charindexte ilk baþta aranacak string girilir.
--2. kýsma içerisinde aranacak asýl öðe girilir.
--Büyük küçük farf duyarlý olmayýp, aranan öðede o harften ne varsa onun pozisyonunu verir.
--Kelime halindeki çoklu aramalarda aranan kelimenin ilk harfinin pozisyonunu verir.
--Eðer bulamazsa 0 döndürüyor. Eðer aranan veri null ise null döndürür.

SELECT PATINDEX('Ý%','ismail')--1
SELECT PATINDEX('%Ý_','ismail')--5
SELECT PATINDEX('%ma',null)--HATA
SELECT PATINDEX('%ma%','ismail')--3
--Charindex ile ayný mantýkta çalýþýr.
--Büyük,küçük harf duyarlý deðildir. Baþýna ve sonuna % iþareti alarak bize sonuç döndürür.
--Bilinmeyenler yerine _ kullanýlabilir.
--Eðer bulamazsa 0 döndürüyor. Eðer aranan veri null ise hata verir.

SELECT UPPER('ismail')--ÝSMAÝL
SELECT UPPER(19.897654)--19.897654
SELECT LOWER(null)--NULL
SELECT LOWER('ÝsmAiL')--ismail
--Sayýlara dokunmaz, null deðerde yine null döndürür. Diðerlerinde büyüküçük yapar

SELECT value from STRING_SPLIT('ismail,iyi,çalýþ, yoksa, zorlanýrsýn.',',')--
SELECT value as sonuc from string_split('John,is,a,very,tall,boy.', '.')--John,is,a,very,tall,boy
--Select value from kýsmý yazýlmak mecburiyetindedir
--Ýlk baþta parçalanacak string yazýlýrken en son ayraç þeklinde kullanýlacak parametre yazýlýr. ve buna göre parçalama iþlemi yapýlýr.

SELECT SUBSTRING ('ismail',1,4)--isma
SELECT SUBSTRING ('ismail',-5,7)--i
--Baþlangýç ve bitiþ indeksleri DAHÝL olmak üzere sonuç döndürür.

SELECT LEFT('ÝSMAÝL',2)--ÝS
SELECT RIGHT('ÝSMAÝL',2)--ÝL
SELECT LEFT(NULL,2)--NULL
--Saðdan veya soldan belirtilen rakam kadar karakteri döndürür

SELECT LEN (TRIM(' ÝSMAÝL '))--6
SELECT TRIM('ÝS' from 'ÝSMAÝL')--MAÝL
SELECT TRIM('ai' from 'ÝSMAÝL')--SMAÝL
SELECT TRIM('@' FROM '@@@clarusway@@@@') AS new_string;--clarusway
SELECT LTRIM('   cadillac') AS new_string;--cadillac
SELECT LEN(RTRIM('   cadillac   ')) AS new_string; --11
--Sadece baþtan ve sondan bakýyor. from lu kullanýalcaksa baþta yazýlan nvarcharýn farklý fraksiyonlarýna da bakýyor.
--Eðer from ile kullanýlmayacaksa baþta ve sonda olan boþluklarý atar.
--Büyük küçük harf duyarlý deðildir

SELECT REPLACE('ÝSMAÝL','a','e')--ÝSMeÝL
SELECT REPLACE('I do it my way.','DO','did') AS song_name;--I did it my way.
--Ýlk baþta olanýn içindeki olanlarý deðiþtiriyor

SELECT STR(123.45,5,1)--123.5
SELECT STR(123.45,2,1)--**
SELECT STR(123.55,10) --       124
--Aradaki noktayýda sayacak þekilde numeric bir ifadeyi str olarak döndürmeyi saðlar.
--2. gelen sayý noktada dahil olmak üzere kaç adet karakterin alýnacaðýný ifade eder.
--En son sayý virgülden sonrasýný ifade etmektedir.
--Eðer 3. sayý kullanýlmazsa tam sayý olarak yuvarlama yapar.
--Her türlü karakter uzunluðunda bir str döndürür

SELECT 'CUSTOMER' + '_' + CAST (1.15 AS varchar) --CUSTOMER_1.15
SELECT CAST(4599.999999 AS numeric(6,2)) AS col  --4600.00
SELECT CAST(4599.999999 AS numeric(6)) AS col  --4600
--Cast ile veri deðiþimleri yapýlabilmekte yada uzun numeric ifadeler kolaylýkla kýsaltýlabilmektedir.
--Numericte virgülden sonra kaç basamak geleceði yazýlmadýðýnda sadece en baþtaki kýsmý alýr. Ayný strde olduðu gibi

SELECT CONCAT('ismail',' ','çulha') as ad_soyad--ismail çulha
SELECT CONCAT('ismail',' ',4507,null) as ad_soyad--ismail 4507
SELECT 4507 + ' ' + 'ismail'--HATA
SELECT 'çulha' + ' ' + 'ismail'--çulha ismail
--Concat ile numeric, null ve string birleþimi yapýlabilmektedir.
--+operatörü ile ne yazýkki bu iþlem yapýlamamaktadýr. Sadece string birleþimler yapýlabiliyor.

SELECT ROUND(565.49, -1)--570.00
SELECT ROUND(565.49, 1)--565.50
SELECT ROUND(565.49, -2)--600.00
SELECT ROUND(565.49, -4)--0.00
SELECT ROUND(565.56, 1,-1)--565.50
SELECT ROUND(565.56, 1,0)--565.60
--Yanýndaki sayý pozitif olduðunda virgülden sonra o kadar rakam al ve o rakamdan sonrasýný yuvarla demek oluyor.
--Yandaki sayý negatif olduðundan virgülden baþa doðru o kadar sayý ilerle ve o sayýyýda içine alacak þekilde yuvarla demek oluyor.
--En sondaki sayý 0 olursa normal yuvarlama iþlemi yapar, eðer baþka bir rakam olursa aþaðý yuvarlar

SELECT ISNULL(NULL,'null yerine bunu yazar')--null yerine bunu yazar
SELECT ISNULL('null olmadýðýnda 1. ifadeyi yazar','2. ifade')--null olmadýðýnda 1. ifadeyi yazar
--Parantez içindek ilk ifadenin sorgulamasýný yapar, null olmasý halinde 2. ifadeyi yazar
--Ýlk ifade null olmadýðý takdirde ilk ifadeyi döndürür

SELECT COALESCE(NULL,NULL,'3. ÝFADE','4')--3. ÝFADE
SELECT COALESCE(NULL,NULL,NULL,NULL)--HATA, 1 TANESÝ NULL OLMAYAN OLMALI
SELECT COALESCE(1,2,3)--1
SELECT COALESCE(1) --HATA, 1'DE FAZLA ELEMAN OLMALI
--Parantez içindekilerden sýrasýyla null olmayan ilk ifadeyi döndürür.  Str olmak zorunda deðil.

SELECT NULLIF ('ÝSMAÝL','ÝSMAÝL','hp') --HATA
SELECT NULLIF ('21.09.1991','21.09.1991') --NULL
SELECT NULLIF ('1','2') --1
SELECT NULLIF ('1',1) --NULL
--Parantez içindeki 2 ifadenin ayný olup olmadýðýnýn kontrolünü saðlar, eðer ayný ise null döndürür.

SELECT ISNUMERIC (123.455)--1
SELECT ISNUMERIC ('ÝSMAÝL')--0
SELECT ISNUMERIC (NULL)--0
SELECT ISNUMERIC(STR(12255.212, 5))--1
--Nümerik ise 1, aksi halde 0

SELECT ASCII('ISMAÝL')--73
--Ýlk karakterin asci kodunu verir

SELECT CHAR(65)--A
--Verilen ascii koduna karþýlýk gelen karakteri verir

SELECT CONCAT_WS('.', 'www', 'W3Schools', 'com');--www.W3Schools.com
--Aralara . konarak birleþtirme yapmayý saðlar

SELECT DIFFERENCE('Juice', 'Banana');--2
SELECT DIFFERENCE('Juice', 'Jucy');--4
SELECT DIFFERENCE('ismail', 'culha'); --1
SELECT DIFFERENCE('ððððððð', 'afght'); --0
--Soundex functiona göre iki ifadenin telaffuzu ile birlikte similaritiesini 0-4 arasý veriyor

SELECT REPLICATE('SQL TUT', 5);--SQL TUTSQL TUTSQL TUTSQL TUTSQL TUT
--Yanýndaki sayý kadar stringi çoðaltýr

SELECT REVERSE('SQL Tutorial');--lairotuT LQS
--Metni terse çevirir

SELECT IIF(500<1000, 'YES', 'NO');--YES
SELECT IIF(500<1000, 5, 10);--5
--Baþta belirtilen koþul doðruysa 2. ifadeyi kullan, yanlýþsa 3. ifadeyi









