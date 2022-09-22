

--------- JOIN --------


--INNER JOIN: Returns the common records in both tables.
--LEFT JOIN: Returns all records from the left table and matching records from the right table.
--RIGHT JOIN: Returns all records from the right table and matching records from the left table.
--FULL OUTER JOIN: Returns all records of both left and right tables.
--CROSS JOIN: Returns the Cartesian product of records in joined tables.
--SELF JOIN: A join of a table to itself.

------INNER JOIN

--SELECT columns FROM table_A INNER JOIN table_B ON table_A.columns = table_B.columns
--Burada tableA'n�n tableB ile olan kesi�imine bak�l�yor. O y�zden ilk olarak tableA yaz�ld�.

--�RNEK1
--SampleRetail Database'inde 
--�r�n IDsi, �r�n ad�, kategori IDsi ve kategori adlar�n� se�in ve �r�nleri kategori isimleri ile birlikte listeleyin
SELECT A.product_id, A.product_name, A.category_id, B.category_name 
	FROM product.product AS A
	INNER JOIN product.category AS B
	ON A.category_id = B.category_id;
--From'dan sonra table'dan birisi, InnerJoinden sonra tablonun birisi yaz�l�r.As veya bo�luk ile tablolar adland�r�l�r.
--Select'ten sonra yaz�lan column isimlerinde hangi s�tunun hangi tablodan al�maca�� isimlendirme ile belirtilir.
--On k�sm� iki tabloda ortak olan s�tunlar�n veya ko�ullar�n birle�tirilmi� halidir.
SELECT	A.product_id, A.product_name, A.category_id, B.category_name
	FROM	product.product A,
			product. category B
	WHERE	A.category_id = B.category_id;
--Fromdan sonra iki table'da belirtildikten sonra where ko�uluyla iki tablo birle�tirilebilir.

--�RNEK2
--Ma�aza �al��anlar�n� �al��t�klar� ma�aza bilgileriyle birlikte listeleyin, �al��an ad�, soyad�, ma�aza adlar�n� se�in
SELECT A.first_name, A.last_name, B.store_name
	FROM sale.staff A
	INNER JOIN sale.store B
	ON A.store_id = B.store_id
--SELECT A.first_name, A.last_name, B.store_name FROM sale.staff, sale.store B WHERE A.store_id = B.store_id



------LEFT JOIN


--SELECT columns FROM table_A LEFT JOIN table_B ON join_conditions
--Sol tabloda yer alan b�t�n de�erler ve sa�daki tabloda yer alan kesi�im k�meleri al�n�r. Sa�daki tablo Left Join yazand�r.
--E�er kesi�im bulunamazsa null d�nd�r�r.

--�RNEK1
--Hi� sipari� verilmemi� �r�nleri listeleyin
SELECT A.product_name, B.order_id
	FROM product.product A
	LEFT JOIN sale.order_item B
	ON A.product_id = B.product_id
	WHERE B.order_id IS NULL

--�RNEK2
--�r�n bilgilerini stok miktarlar� ile birlikte listeleyin. 
--Beklenen: product tablosunda olup stok bilgisi olmayan �r�nleri de g�rmek.

SELECT A.product_id, A.product_name, B.quantity
	FROM product.product A
	LEFT JOIN product.stock B
	ON A.product_id = B.product_id



------RIGHT JOIN



--SELECT columns FROM table_A RIGHT JOIN table_B ON join_conditions
--Sa� tabloda yer alan b�t�n de�erler ile soldaki tabloda yer alan kesi�im k�meleri al�n�r Sa�daki tablo Right Join'den sonra yazand�r.
--E�er kesi�im bulunamazsa null d�nd�r�r.
--Soldaki ile yan� i�levi g�rmesi i�in birle�en fromdan sonra de�il, Right Joinden sonra yaz�lmal�d�r.



------FULL OUTER JOIN



--SELECT columns FROM table_A FULL OUTER JOIN table_B ON join_conditions
--�ki tablonun tam anlam�yla birle�imi i�in kullan�l�r. Tablo'daki eksik veriler null verece�i i�in bunlar�n tespiti i�in kullan�labir.

--�RNEK1
--�r�nlerin stok miktarlar� ve sipari� bilgilerini birlikte listeleyin.HER �K� TABLODAK� PRODUCT ID LER� GET�RMEK �NEML�. 

SELECT B.product_id, B.quantity, A.product_id, A.order_id
	FROM sale.order_item A
	FULL OUTER JOIN product.stock B
	ON A.product_id = B.product_id



------CROSS JOIN



--SELECT columns FROM table_A CROSS JOIN table_B
--SELECT columns FROM table_A, table_B
--Cross Join i�lemi ise iki tabloyu birle�tirirken iki tablo aras�nda t�m e�le�tirmeleri listeler yani �apraz birle�tirir 
--bir di�er tabir ile kartezyen �arp�m�n� al�r. 
--Soldaki tablodaki her sat�ra kar��l�k sa�daki tablonun t�m sat�rlar�n� d�nd�rme i�lemi ger�ekle�tirir.

--�RNEK1
--stock tablosunda olmay�p product tablosunda mevcut olan �r�nlerin stock tablosuna t�m storelar i�in kay�t edilmesi gerekiyor. 
--sto�u olmad��� i�in quantity leri 0 olmak zorunda
--Ve bir product id t�m store' lar�n stockuna eklenmesi gerekti�i i�in cross join yapmam�z gerekiyor.
SELECT B.store_id, A.product_id, 0 quantity
	FROM product.product A
	CROSS JOIN sale.store B
	WHERE A.product_id NOT IN (SELECT product_id FROM product.stock)
	ORDER BY A.product_id, B.store_id



------SELF JOIN



--SELECT columns FROM table A JOIN table B WHERE join_conditions
-- Mesela ayn� tabloda ayn� �ehirde olanlar� e�le�tirmek istendi�inde ��kart�labilir, 
--ayn� tablo i�indeki verilerin birbirleri ile k�yas� i�in kullan�l�r

--�rnek1
--Personelleri ve �eflerini listeleyin. �al��an ad� ve y�netici ad� bilgilerini getirin
SELECT A.staff_id, A.first_name, A.last_name, B.first_name AS manager_name
	FROM sale.staff A
	JOIN sale.staff B
	ON B.staff_id = A.manager_id
--Burada dikkat edilece�i �zere B.first_name dedikten sonra ON k�sm�nda staffid'yi manager id olarak de�i�tirdik.
--Yani A tablosunun manager id'si B tablosunun staff id'si gibi g�r�ld�.
SELECT	A.first_name, B.first_name manager_name 
	FROM sale.staff A, sale.staff B
	WHERE	A.manager_id = B.staff_id
	ORDER BY B.first_name



------ VIEW


--Performans, G�venlik, Basitlik ve Depolama alan�nda kolayl�k sa�lar


--CREATE VIEW IF NOT EXISTS view_name
--E�er view olup olmad���n� bilmiyorsak bu kod ile devam edebiliriz.

--CREATE VIEW view_name AS SELECT columns FROM tables [WHERE conditions];
--Viewde insert, delete yada update yap�lamaz. Sadece Create, Drop ve Alter yap�labilir.

--DROP VIEW view_name;


--�RNEK1
CREATE VIEW ProductStock AS 
	SELECT	A.product_id, A.product_name, B.store_id, B.quantity
	FROM	product.product A
	LEFT JOIN product.stock B ON A.product_id = B.product_id
	WHERE	A.product_id > 310;
SELECT * FROM ProductStock; -- O isimle kaydediyor

--Sonucunda view create ediyor.
--Object k�sm�nda views alt�nda ��k�yor. Bu sorgu art�k tablo olarak kullan�labiliyor.
--Tek bir sorgu sonucunda tek bir tablo d�nd�ren b�t�n hususlar view olabiliyor.
--De�i�iklikleri g�ncel olarak tutmam�z� sa�l�yor. Ve sadece sorguyu tutuyor.
--View �zerine sa� t�k design dendi�inde ilgili komutu getiriyor
--Alter view ile sorgu ve view ad� de�i�tirilebilir

--�RNEK2
CREATE VIEW StoreInf AS
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id;
SELECT * FROM StoreInf



----------TEMPORARY TABLE (INTO #_______)



--Bu �ekilde program kapand���nda kapanacak �ekilde tablo olu�turuluyor.
--Sorgunun daha kolay yaz�lmas�n� kolayla�t�rabilir.

SELECT	A.product_id, A.product_name, B.store_id, B.quantity
INTO #TempTableExample
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

SELECT * FROM #TempTableExample












