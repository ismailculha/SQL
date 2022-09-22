
------- DATE FUNCTIONS ---------

SELECT GETDATE() AS DAY_--2022-06-07 05:55:52.153
SELECT GETUTCDATE()--2022-06-07 02:55:47.267
-- Anl�k tarih ve zamann� otomatik getirmemizi sa�lar, Utcdate ise utc'deki zaman� almam�z� sa�lar

SELECT DATENAME(WEEK, '2022-06-07')--24
SELECT DATENAME(MONTH, '2022-06-07')--June
SELECT DATENAME(DAYOFYEAR, '2022-06-07')--158
SELECT DATENAME(WEEKDAY, '2022-06-07')--Tuesday
SELECT DATENAME(DAY, '2022-06-07')--7
--��erisinde Year,Quarter, Month, Dayofyear, Day, Week, Weekday, Hour, Minute, Second ve Millisecond olmak �zere b�t�n veriler al�nabiliyor.
--Nvarcahar olarak d�nd�r�yor

SELECT DATEPART(WEEKDAY, '2022-06-07')--3
SELECT DATEPART(WEEK,'2022-06-07')--24
--Ayn� datename gibi fakat nvarchar de�il, int d�nd�r�yor
--��erisinde Year,Quarter, Month, Dayofyear, Day, Week, Weekday, Hour, Minute, Second ve Millisecond olmak �zere b�t�n veriler al�nabiliyor.

SELECT DAY(GETDATE()) AS DAY_;--7
SELECT MONTH(GETDATE()) AS MONTH_;--6
SELECT YEAR(GETDATE()) AS MONTH_;--2022
--Belirtilen tarih foramt�nda ilgili g�n, ay ve y�l bilgilerini bize verir

SELECT DATEDIFF(SECOND, '1991-09-21', GETDATE());--969170083
SELECT DATEDIFF(MINUTE, '1991-09-21', GETDATE());--16152834
SELECT DATEDIFF(DAY, '1991-09-21', GETDATE());--11217
SELECT DATEDIFF(WEEK, '1991-09-21', GETDATE());--1603
SELECT DATEDIFF(YEAR, '1991-09-21', GETDATE());--31
--Belirtilen interval aral���nda aradaki fark� d�nd�rmemizi sa�lar

SELECT DATEADD(SECOND, 20, '1991-09-21')--1991-09-21 00:00:20.000
SELECT DATEADD(DAY, -20, '1991-09-21')--1991-09-01 00:00:00.000
--Belitilen iinterval aral���nda g�n ekleme, ��karma yapmam�z� sa�lar

SELECT EOMONTH('2021-02-10') AS EndofFeb--2021-02-28
SELECT EOMONTH(GETDATE(),2)--2022-08-31
--Tek ba��na tarih yaz�ld���nda ay�n ka� g�n �ekti�i bilgisini verir. 
--Yan�na int ald���nda o kadar ay sonras�n�n ka� g�n �ekti�i bilgisini verir.

SELECT ISDATE('21.09.1991')--0
SELECT ISDATE('2022-06-06')--1
--��erisinde nvarchar al�yor, buna g�re e�er nvarchar format� do�ruysa 0,1 olarak veri d�nd�r�yor

SELECT CONVERT (DATE, '04 Jun 22', 6) --2022-06-04
--Burada 6 i�erdeki varchar�n tipi olmal�, ba�ka bir �ey yazd���nda olmuyor
SELECT CONVERT (VARCHAR(10), GETDATE(), 6) --07 Jun 22
--Getdate i hangi formatta g�rmek istedi�imizi 6 ile belirtiyoruz

SELECT DATEFROMPARTS(2021,5,28)--2021-05-28
--��erisine 3 parametre al�yor. S�ras� ile year, month, day
SELECT DATETIMEFROMPARTS(2021,5,28,12,0,05,011)--2021-05-28 12:00:05.010
--��erisine ald��� 7 parametreyi datetime olarak d�nd�r�yor


----------- STRING FUNCTIONS -------------


SELECT LEN('�SMA�L')--6
SELECT LEN(NULL)--NULL
SELECT LEN(10.2)--4
--��erisine ald��� nvarchar�n uzunlu�unu int olarak d�nd�r�r, i�inde null varsa sonucu null olarak d�nd�r�r. Numeric olsa dahi

SELECT CHARINDEX('i','ismail')--1
SELECT CHARINDEX('�','ismail',2)--5
SELECT CHARINDEX('ma',null)--NULL
SELECT CHARINDEX('self', 'Reinvent yourself and ourself') AS motto;--14
SELECT CHARINDEX('self', 'Reinvent yourself and ourself', 15) AS motto;--26
--Charindexte ilk ba�ta aranacak string girilir.
--2. k�sma i�erisinde aranacak as�l ��e girilir.
--B�y�k k���k farf duyarl� olmay�p, aranan ��ede o harften ne varsa onun pozisyonunu verir.
--Kelime halindeki �oklu aramalarda aranan kelimenin ilk harfinin pozisyonunu verir.
--E�er bulamazsa 0 d�nd�r�yor. E�er aranan veri null ise null d�nd�r�r.

SELECT PATINDEX('�%','ismail')--1
SELECT PATINDEX('%�_','ismail')--5
SELECT PATINDEX('%ma',null)--HATA
SELECT PATINDEX('%ma%','ismail')--3
--Charindex ile ayn� mant�kta �al���r.
--B�y�k,k���k harf duyarl� de�ildir. Ba��na ve sonuna % i�areti alarak bize sonu� d�nd�r�r.
--Bilinmeyenler yerine _ kullan�labilir.
--E�er bulamazsa 0 d�nd�r�yor. E�er aranan veri null ise hata verir.

SELECT UPPER('ismail')--�SMA�L
SELECT UPPER(19.897654)--19.897654
SELECT LOWER(null)--NULL
SELECT LOWER('�smAiL')--ismail
--Say�lara dokunmaz, null de�erde yine null d�nd�r�r. Di�erlerinde b�y�k���k yapar

SELECT value from STRING_SPLIT('ismail,iyi,�al��, yoksa, zorlan�rs�n.',',')--
SELECT value as sonuc from string_split('John,is,a,very,tall,boy.', '.')--John,is,a,very,tall,boy
--Select value from k�sm� yaz�lmak mecburiyetindedir
--�lk ba�ta par�alanacak string yaz�l�rken en son ayra� �eklinde kullan�lacak parametre yaz�l�r. ve buna g�re par�alama i�lemi yap�l�r.

SELECT SUBSTRING ('ismail',1,4)--isma
SELECT SUBSTRING ('ismail',-5,7)--i
--Ba�lang�� ve biti� indeksleri DAH�L olmak �zere sonu� d�nd�r�r.

SELECT LEFT('�SMA�L',2)--�S
SELECT RIGHT('�SMA�L',2)--�L
SELECT LEFT(NULL,2)--NULL
--Sa�dan veya soldan belirtilen rakam kadar karakteri d�nd�r�r

SELECT LEN (TRIM(' �SMA�L '))--6
SELECT TRIM('�S' from '�SMA�L')--MA�L
SELECT TRIM('ai' from '�SMA�L')--SMA�L
SELECT TRIM('@' FROM '@@@clarusway@@@@') AS new_string;--clarusway
SELECT LTRIM('   cadillac') AS new_string;--cadillac
SELECT LEN(RTRIM('   cadillac   ')) AS new_string; --11
--Sadece ba�tan ve sondan bak�yor. from lu kullan�alcaksa ba�ta yaz�lan nvarchar�n farkl� fraksiyonlar�na da bak�yor.
--E�er from ile kullan�lmayacaksa ba�ta ve sonda olan bo�luklar� atar.
--B�y�k k���k harf duyarl� de�ildir

SELECT REPLACE('�SMA�L','a','e')--�SMe�L
SELECT REPLACE('I do it my way.','DO','did') AS song_name;--I did it my way.
--�lk ba�ta olan�n i�indeki olanlar� de�i�tiriyor

SELECT STR(123.45,5,1)--123.5
SELECT STR(123.45,2,1)--**
SELECT STR(123.55,10) --       124
--Aradaki noktay�da sayacak �ekilde numeric bir ifadeyi str olarak d�nd�rmeyi sa�lar.
--2. gelen say� noktada dahil olmak �zere ka� adet karakterin al�naca��n� ifade eder.
--En son say� virg�lden sonras�n� ifade etmektedir.
--E�er 3. say� kullan�lmazsa tam say� olarak yuvarlama yapar.
--Her t�rl� karakter uzunlu�unda bir str d�nd�r�r

SELECT 'CUSTOMER' + '_' + CAST (1.15 AS varchar) --CUSTOMER_1.15
SELECT CAST(4599.999999 AS numeric(6,2)) AS col  --4600.00
SELECT CAST(4599.999999 AS numeric(6)) AS col  --4600
--Cast ile veri de�i�imleri yap�labilmekte yada uzun numeric ifadeler kolayl�kla k�salt�labilmektedir.
--Numericte virg�lden sonra ka� basamak gelece�i yaz�lmad���nda sadece en ba�taki k�sm� al�r. Ayn� strde oldu�u gibi

SELECT CONCAT('ismail',' ','�ulha') as ad_soyad--ismail �ulha
SELECT CONCAT('ismail',' ',4507,null) as ad_soyad--ismail 4507
SELECT 4507 + ' ' + 'ismail'--HATA
SELECT '�ulha' + ' ' + 'ismail'--�ulha ismail
--Concat ile numeric, null ve string birle�imi yap�labilmektedir.
--+operat�r� ile ne yaz�kki bu i�lem yap�lamamaktad�r. Sadece string birle�imler yap�labiliyor.

SELECT ROUND(565.49, -1)--570.00
SELECT ROUND(565.49, 1)--565.50
SELECT ROUND(565.49, -2)--600.00
SELECT ROUND(565.49, -4)--0.00
SELECT ROUND(565.56, 1,-1)--565.50
SELECT ROUND(565.56, 1,0)--565.60
--Yan�ndaki say� pozitif oldu�unda virg�lden sonra o kadar rakam al ve o rakamdan sonras�n� yuvarla demek oluyor.
--Yandaki say� negatif oldu�undan virg�lden ba�a do�ru o kadar say� ilerle ve o say�y�da i�ine alacak �ekilde yuvarla demek oluyor.
--En sondaki say� 0 olursa normal yuvarlama i�lemi yapar, e�er ba�ka bir rakam olursa a�a�� yuvarlar

SELECT ISNULL(NULL,'null yerine bunu yazar')--null yerine bunu yazar
SELECT ISNULL('null olmad���nda 1. ifadeyi yazar','2. ifade')--null olmad���nda 1. ifadeyi yazar
--Parantez i�indek ilk ifadenin sorgulamas�n� yapar, null olmas� halinde 2. ifadeyi yazar
--�lk ifade null olmad��� takdirde ilk ifadeyi d�nd�r�r

SELECT COALESCE(NULL,NULL,'3. �FADE','4')--3. �FADE
SELECT COALESCE(NULL,NULL,NULL,NULL)--HATA, 1 TANES� NULL OLMAYAN OLMALI
SELECT COALESCE(1,2,3)--1
SELECT COALESCE(1) --HATA, 1'DE FAZLA ELEMAN OLMALI
--Parantez i�indekilerden s�ras�yla null olmayan ilk ifadeyi d�nd�r�r.  Str olmak zorunda de�il.

SELECT NULLIF ('�SMA�L','�SMA�L','hp') --HATA
SELECT NULLIF ('21.09.1991','21.09.1991') --NULL
SELECT NULLIF ('1','2') --1
SELECT NULLIF ('1',1) --NULL
--Parantez i�indeki 2 ifadenin ayn� olup olmad���n�n kontrol�n� sa�lar, e�er ayn� ise null d�nd�r�r.

SELECT ISNUMERIC (123.455)--1
SELECT ISNUMERIC ('�SMA�L')--0
SELECT ISNUMERIC (NULL)--0
SELECT ISNUMERIC(STR(12255.212, 5))--1
--N�merik ise 1, aksi halde 0

SELECT ASCII('ISMA�L')--73
--�lk karakterin asci kodunu verir

SELECT CHAR(65)--A
--Verilen ascii koduna kar��l�k gelen karakteri verir

SELECT CONCAT_WS('.', 'www', 'W3Schools', 'com');--www.W3Schools.com
--Aralara . konarak birle�tirme yapmay� sa�lar

SELECT DIFFERENCE('Juice', 'Banana');--2
SELECT DIFFERENCE('Juice', 'Jucy');--4
SELECT DIFFERENCE('ismail', 'culha'); --1
SELECT DIFFERENCE('�������', 'afght'); --0
--Soundex functiona g�re iki ifadenin telaffuzu ile birlikte similaritiesini 0-4 aras� veriyor

SELECT REPLICATE('SQL TUT', 5);--SQL TUTSQL TUTSQL TUTSQL TUTSQL TUT
--Yan�ndaki say� kadar stringi �o�alt�r

SELECT REVERSE('SQL Tutorial');--lairotuT LQS
--Metni terse �evirir

SELECT IIF(500<1000, 'YES', 'NO');--YES
SELECT IIF(500<1000, 5, 10);--5
--Ba�ta belirtilen ko�ul do�ruysa 2. ifadeyi kullan, yanl��sa 3. ifadeyi









