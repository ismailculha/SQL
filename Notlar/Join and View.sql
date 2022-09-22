

--------- JOIN --------


--INNER JOIN: Returns the common records in both tables.
--LEFT JOIN: Returns all records from the left table and matching records from the right table.
--RIGHT JOIN: Returns all records from the right table and matching records from the left table.
--FULL OUTER JOIN: Returns all records of both left and right tables.
--CROSS JOIN: Returns the Cartesian product of records in joined tables.
--SELF JOIN: A join of a table to itself.

------INNER JOIN

--SELECT columns FROM table_A INNER JOIN table_B ON table_A.columns = table_B.columns
--Burada tableA'nýn tableB ile olan kesiþimine bakýlýyor. O yüzden ilk olarak tableA yazýldý.

--ÖRNEK1
--SampleRetail Database'inde 
--Ürün IDsi, ürün adý, kategori IDsi ve kategori adlarýný seçin ve ürünleri kategori isimleri ile birlikte listeleyin
SELECT A.product_id, A.product_name, A.category_id, B.category_name 
	FROM product.product AS A
	INNER JOIN product.category AS B
	ON A.category_id = B.category_id;
--From'dan sonra table'dan birisi, InnerJoinden sonra tablonun birisi yazýlýr.As veya boþluk ile tablolar adlandýrýlýr.
--Select'ten sonra yazýlan column isimlerinde hangi sütunun hangi tablodan alýmacaðý isimlendirme ile belirtilir.
--On kýsmý iki tabloda ortak olan sütunlarýn veya koþullarýn birleþtirilmiþ halidir.
SELECT	A.product_id, A.product_name, A.category_id, B.category_name
	FROM	product.product A,
			product. category B
	WHERE	A.category_id = B.category_id;
--Fromdan sonra iki table'da belirtildikten sonra where koþuluyla iki tablo birleþtirilebilir.

--ÖRNEK2
--Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin, Çalýþan adý, soyadý, maðaza adlarýný seçin
SELECT A.first_name, A.last_name, B.store_name
	FROM sale.staff A
	INNER JOIN sale.store B
	ON A.store_id = B.store_id
--SELECT A.first_name, A.last_name, B.store_name FROM sale.staff, sale.store B WHERE A.store_id = B.store_id



------LEFT JOIN


--SELECT columns FROM table_A LEFT JOIN table_B ON join_conditions
--Sol tabloda yer alan bütün deðerler ve saðdaki tabloda yer alan kesiþim kümeleri alýnýr. Saðdaki tablo Left Join yazandýr.
--Eðer kesiþim bulunamazsa null döndürür.

--ÖRNEK1
--Hiç sipariþ verilmemiþ ürünleri listeleyin
SELECT A.product_name, B.order_id
	FROM product.product A
	LEFT JOIN sale.order_item B
	ON A.product_id = B.product_id
	WHERE B.order_id IS NULL

--ÖRNEK2
--Ürün bilgilerini stok miktarlarý ile birlikte listeleyin. 
--Beklenen: product tablosunda olup stok bilgisi olmayan ürünleri de görmek.

SELECT A.product_id, A.product_name, B.quantity
	FROM product.product A
	LEFT JOIN product.stock B
	ON A.product_id = B.product_id



------RIGHT JOIN



--SELECT columns FROM table_A RIGHT JOIN table_B ON join_conditions
--Sað tabloda yer alan bütün deðerler ile soldaki tabloda yer alan kesiþim kümeleri alýnýr Saðdaki tablo Right Join'den sonra yazandýr.
--Eðer kesiþim bulunamazsa null döndürür.
--Soldaki ile yaný iþlevi görmesi için birleþen fromdan sonra deðil, Right Joinden sonra yazýlmalýdýr.



------FULL OUTER JOIN



--SELECT columns FROM table_A FULL OUTER JOIN table_B ON join_conditions
--Ýki tablonun tam anlamýyla birleþimi için kullanýlýr. Tablo'daki eksik veriler null vereceði için bunlarýn tespiti için kullanýlabir.

--ÖRNEK1
--Ürünlerin stok miktarlarý ve sipariþ bilgilerini birlikte listeleyin.HER ÝKÝ TABLODAKÝ PRODUCT ID LERÝ GETÝRMEK ÖNEMLÝ. 

SELECT B.product_id, B.quantity, A.product_id, A.order_id
	FROM sale.order_item A
	FULL OUTER JOIN product.stock B
	ON A.product_id = B.product_id



------CROSS JOIN



--SELECT columns FROM table_A CROSS JOIN table_B
--SELECT columns FROM table_A, table_B
--Cross Join iþlemi ise iki tabloyu birleþtirirken iki tablo arasýnda tüm eþleþtirmeleri listeler yani çapraz birleþtirir 
--bir diðer tabir ile kartezyen çarpýmýný alýr. 
--Soldaki tablodaki her satýra karþýlýk saðdaki tablonun tüm satýrlarýný döndürme iþlemi gerçekleþtirir.

--ÖRNEK1
--stock tablosunda olmayýp product tablosunda mevcut olan ürünlerin stock tablosuna tüm storelar için kayýt edilmesi gerekiyor. 
--stoðu olmadýðý için quantity leri 0 olmak zorunda
--Ve bir product id tüm store' larýn stockuna eklenmesi gerektiði için cross join yapmamýz gerekiyor.
SELECT B.store_id, A.product_id, 0 quantity
	FROM product.product A
	CROSS JOIN sale.store B
	WHERE A.product_id NOT IN (SELECT product_id FROM product.stock)
	ORDER BY A.product_id, B.store_id



------SELF JOIN



--SELECT columns FROM table A JOIN table B WHERE join_conditions
-- Mesela ayný tabloda ayný þehirde olanlarý eþleþtirmek istendiðinde çýkartýlabilir, 
--ayný tablo içindeki verilerin birbirleri ile kýyasý için kullanýlýr

--Örnek1
--Personelleri ve þeflerini listeleyin. Çalýþan adý ve yönetici adý bilgilerini getirin
SELECT A.staff_id, A.first_name, A.last_name, B.first_name AS manager_name
	FROM sale.staff A
	JOIN sale.staff B
	ON B.staff_id = A.manager_id
--Burada dikkat edileceði üzere B.first_name dedikten sonra ON kýsmýnda staffid'yi manager id olarak deðiþtirdik.
--Yani A tablosunun manager id'si B tablosunun staff id'si gibi görüldü.
SELECT	A.first_name, B.first_name manager_name 
	FROM sale.staff A, sale.staff B
	WHERE	A.manager_id = B.staff_id
	ORDER BY B.first_name



------ VIEW


--Performans, Güvenlik, Basitlik ve Depolama alanýnda kolaylýk saðlar


--CREATE VIEW IF NOT EXISTS view_name
--Eðer view olup olmadýðýný bilmiyorsak bu kod ile devam edebiliriz.

--CREATE VIEW view_name AS SELECT columns FROM tables [WHERE conditions];
--Viewde insert, delete yada update yapýlamaz. Sadece Create, Drop ve Alter yapýlabilir.

--DROP VIEW view_name;


--ÖRNEK1
CREATE VIEW ProductStock AS 
	SELECT	A.product_id, A.product_name, B.store_id, B.quantity
	FROM	product.product A
	LEFT JOIN product.stock B ON A.product_id = B.product_id
	WHERE	A.product_id > 310;
SELECT * FROM ProductStock; -- O isimle kaydediyor

--Sonucunda view create ediyor.
--Object kýsmýnda views altýnda çýkýyor. Bu sorgu artýk tablo olarak kullanýlabiliyor.
--Tek bir sorgu sonucunda tek bir tablo döndüren bütün hususlar view olabiliyor.
--Deðiþiklikleri güncel olarak tutmamýzý saðlýyor. Ve sadece sorguyu tutuyor.
--View üzerine sað týk design dendiðinde ilgili komutu getiriyor
--Alter view ile sorgu ve view adý deðiþtirilebilir

--ÖRNEK2
CREATE VIEW StoreInf AS
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id;
SELECT * FROM StoreInf



----------TEMPORARY TABLE (INTO #_______)



--Bu þekilde program kapandýðýnda kapanacak þekilde tablo oluþturuluyor.
--Sorgunun daha kolay yazýlmasýný kolaylaþtýrabilir.

SELECT	A.product_id, A.product_name, B.store_id, B.quantity
INTO #TempTableExample
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310;

SELECT * FROM #TempTableExample












