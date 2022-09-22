-------SUBQUERY



--3 �ekilde kullan�labilir.Select, From ve Where ile.
--Between sadece subquery i�inde kullan�labilir. D���nda kullan�lamaz
--Correlated subquery d�� ve i� query'lerin birbirleri ile ba�lant�s� olmas� halinde kullan�l�r.
--SELECT id, name, graduation, seniority FROM departments AS A WHERE dept_name IN
--(
--SELECT dept_name FROM  departments AS B WHERE A.id= B.id  GROUP BY dept_name HAVING AVG(salary) > 80000)

--Exist operat�r� correlated subquerylerde i�indekiler d��ar�dakilerin e�le�mesi i�in kullan�l�r.
--Not exist ise olumsuz olarak i�eride ��kanlar�n d���ndakileri bize verir.
-- _____WHERE NOT EXISTS ( SELECT 1______ �eklinde kullan�l�yor



--�RNEK1 (With Subquery)
SELECT A.product_name, A.brand_id, (SELECT brand_name FROM product.brand WHERE A.brand_id = brand_id), 
	A.category_id, (SELECT category_name FROM product.category WHERE A.category_id = category_id )
FROM product.product AS A
GROUP BY A.product_name, A.brand_id, A.category_id
ORDER BY 2,4
--With Inner join
SELECT A.product_name, A.brand_id, B.brand_name, A.category_id, C.category_name
FROM product.product A
INNER JOIN product.brand B
	ON A.brand_id = B.brand_id
INNER JOIN product.category C
	ON A.category_id = C.category_id
GROUP BY A.product_name, A.brand_id, B.brand_name, A.category_id, C.category_name
ORDER BY 1
--�kiside ayn� sonucu d�nd�r�yor


--�RNEK2 (With Subquery)
SET STATISTICS IO ON
SELECT A.product_id, A.product_name, 
	(SELECT SUM(quantity*list_price*(1-discount)) FROM sale.order_item WHERE A.product_id = product_id) AS TOPLAMSATIS,
	(SELECT AVG(quantity*list_price*(1-discount)) FROM sale.order_item WHERE A.product_id = product_id) AS ORTSATIS,
	(SELECT MAX(quantity*list_price*(1-discount)) FROM sale.order_item WHERE A.product_id = product_id) AS MAKSSATIS,
	(SELECT MIN(quantity*list_price*(1-discount)) FROM sale.order_item WHERE A.product_id = product_id) AS MINSATIS
FROM product.product A
GROUP BY A.product_id, A.product_name
--With left join
SET STATISTICS IO ON
SELECT A.product_id, A.product_name,  SUM(B.quantity*B.list_price*(1*B.discount)) AS TOPLAMSATIS,
	AVG(B.quantity*B.list_price*(1*B.discount)) AS ORTSATIS,
	MAX(B.quantity*B.list_price*(1*B.discount)) AS MAKSSATIS,
	MIN(B.quantity*B.list_price*(1*B.discount)) AS MINSATIS
FROM product.product A
LEFT JOIN sale.order_item B
	ON A.product_id = B.product_id
GROUP BY A.product_id, A.product_name
--�kiside ayn� sonucu d�nd�r��yor fakat subquery'de her bir tabloyu i�lem miktar� kadar her seferinde �a��r�rken
--joinlerde tablo bir kere �a�r�larak birle�tiriliyor ve i�lemler �zerinden yap�labiliyor. 
--Bu ba�lamda joinle i�lem yapmak peprformans a��s�ndan daha tercih edilesi bir y�ntem olarak durmaktad�r.

--�OK �NEML� NOT: ORDER  BY'DA QUERY'DE YER ALMASA B�LE AGG FUNCTION �LE YAPAB�LMEKTEY�Z. �RNE��N TOPLAM TUTARI SROGU 
--	SONUCUNDA �STEMESEK B�LE SIRALAMAYI BU �EK�LDE YAPAB�L�YORUZ.


--�RNEK-1
--Soru: Apple - Pre-Owned iPad 3 - 32GB - White �r�n�n hi� sipari� verilmedi�i eyaletleri bulunuz.
--Eyalet m��terilerin ikamet adreslerinden al�nacakt�r.
--�r�n� sat�n alanlar�n listesi
SELECT DISTINCT SC.state
FROM product.product PP, 
	sale.order_item OI, 
	sale.orders SO, 
	sale.customer SC
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND
	PP.product_id = OI.product_id AND
	OI.order_id = SO.order_id AND
	SO.customer_id = SC.customer_id;

SET STATISTICS IO ON
SELECT DISTINCT C2.[state]
FROM sale.customer C2
WHERE NOT EXISTS(
SELECT 1
FROM product.product PP, 
	sale.order_item OI, 
	sale.orders SO, 
	sale.customer SC
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND
	PP.product_id = OI.product_id AND
	OI.order_id = SO.order_id AND
	SO.customer_id = SC.customer_id AND
	C2.state = SC.state --Burada existin ba�� ile sonunu e�liyor
	)


--�RNEK-2
--Soru: Burkes Outlet ma�aza sto�unda bulunmay�p,
-- Davi techno ma�azas�nda bulunan �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n
SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
NOT EXISTS( SELECT A.product_id, A.store_id, A.quantity
FROM product.stock A, sale.store B
WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND PC.product_id = A.product_id AND A.quantity>0);
--Not exist dendi�inde a�a��dakinde olmay�p di�erinde olan demek
--Exist ise a�a��dakinde olup yukar�dakinde de olan demek




--�RNEK-3
-- Brukes Outlet storedan al�n�p The BFLO Store ma�azas�ndan hi� al�nmayan �r�n var m�?
-- Varsa bu �r�nler nelerdir?
-- �r�nlerin sat�� bilgileri istenmiyor, sadece �r�n listesi isteniyor.
SELECT DISTINCT product_id
FROM sale.store SS, sale.orders SO, sale.order_item SI
WHERE SS.store_id = SO.store_id AND SO.order_id = SI.order_id AND SS.store_name = 'Burkes Outlet' AND  NOT EXISTS(
SELECT DISTINCT C.product_id
FROM sale.store A, sale.orders B, sale.order_item C
WHERE A.store_id = B.store_id AND B.order_id = C.order_id AND A.store_name = 'The BFLO Store' AND SI.product_id = C.product_id)
---��Z�M2
SELECT	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
except
		SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store';
--��Z�M3
SELECT P.product_name, p.list_price, p.model_year
FROM product.product P
WHERE NOT EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
				and P.product_id = I.product_id)
	AND
	EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
				and P.product_id = I.product_id);






----------WITH CLAUSES


--Sorgu s�resince kullan�l�r. Yaln�zca ait olduklar� sorgu i�inde kullan�labilir.
--B�t�n CTE'ler with ile ba�lar. SELECT;DELETE;UPDATE; INSERT komutlar� ile kullan�l�r.
--WITH query_name [(column_name1, ...)] AS 
--    (SELECT ...) -- CTE Definition
--SELECT * FROM query_name; -- SQL_Statement
-- Bir VIEW gibi �al���rlar.
-- Sorgu s�recinde o s�rada meydana gelip daha sonra Sorgu sonunda kaybolan objelerdir.
-- Sadece sorguya �zg� VIEW diyebiliriz.
-- ALL CTEs(ordinary or recursive) stat with a "WITH" clause ...
-- Bir common table i�inde birden fazla WITH clause kullan�labilir
-- 2. �e�iti var 1.Ordinary 2. Recursive

--Burada withTen sonra ayz�lan b�l�mden sonra s�tun belirtilirken buras� CTE definition k�sm�ndaki s�tun isimleri ile ayn� olmal�d�r.
WITH temp_table (avgsa) AS
	(
  SELECT AVG(salary)
	FROM departments
  )
	SELECT name, salary
	FROM departments INNER JOIN temp_table 
	ON departments.salary > temp_table.avgsa;  --On k�sm�na b�y�k k���k ifade kulland�



WITH cte
    AS (SELECT 1 AS n -- anchor member
        UNION ALL
        SELECT n + 1 -- recursive member
        FROM   cte
        WHERE  n < 10) -- terminator
SELECT n
FROM cte;


--�RNEK-1
-- 1.Ordinary Common Table Expressions
-- Soru: -- Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi� 
--ve Austin �ehrinde ikamet eden m��terileri listeleyin.
WITH tbl AS
(SELECT TOP 1 order_date AS last_date  --max(b.order_date) JeraldLastOrderDate ile de yap�labilirdi.
FROM sale.customer A, sale.orders B
WHERE first_name = 'Jerald ' AND last_name = 'Berray ' AND A.customer_id = B.customer_id
ORDER BY order_date DESC)
SELECT DISTINCT A.first_name, A.last_name
FROM sale.customer A, sale.orders B, tbl C
WHERE A.city = 'Austin' AND A.customer_id = B.customer_id AND B.order_date < C.last_date
--Burada �enmli olan with ile yap�lan join i�leminde tekrar id'leri birle�tirmek zorunda kalm�yorsun. �htiyac�n olana bak�yosun
--Kolayca kodun bir k�sm�n� yazmam�z� sa�l�yor


--�RNEK-2
-- Herbir markan�n sat�ld��� en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait ka� farkl� �r�n bulundu�unu da ayr� bir CTE sorgusunda tan�mlay�n�z.
-- Bu sorgular� kullanarak  Logitech ve Sony markalar�na ait son sat�� tarihini ve toplam �r�n say�s�n� (product tablosundaki) ayn� sql sorgusunda d�nd�r�n�z.
--��Z�M1 YANLI�	
		WITH tbl1 ( brand_id, name_,marka,son_tarih) AS(
		SELECT DISTINCT B.brand_id, B.brand_name, COUNT(B.brand_id) AS marka_say�, MAX(D.order_date)
		FROM product.product A, product.brand B, sale.order_item C, sale.orders D
		WHERE A.brand_id = B.brand_id AND A.product_id = C.product_id AND A.product_id = D.order_id
		GROUP BY B.brand_id, B.brand_name )
		SELECT DISTINCT B.*
		FROM product.brand A, tbl1 B
		WHERE B.name_ = 'Logitech' OR B.name_ = 'Sony'
--COUNTI inner join yapt���m i�in yanl�� count i�lemi verdi. Order i�inde count i�lemi verdi. Do�rusu i�in ayr� ayr� yapmam gerekirdi.

--��Z�M BU
with tbl as(
	select	DISTINCT br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id and
		a.brand_name in ('Logitech', 'Sony');


--�RNEK-3
--- Soru: --2018 y�l�nda t�m ma�azalar�n ortalama cirosunun alt�nda ciroya sahip ma�azalar� listeleyin.
--List the stores their earnings are under the average income in 2018.
--- with clause un alt�nda 2 tane tablo tan�mlayaca��z

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;

---1. tabloda Her bir store name her bir ma�azan�n yapm�� oldu�u sat�� tutar�. Filtre olarak da y�la 2018 dedik
---2.tabloda T1 deki de�erlere g�re ortalama ald�k
--- Tablolar� birbiri i�erisinde referans g�sterebiliyoruz
--- Final de T1,T2 tablosuna git T2 deki ortalama cironun T1 deki store cirolar�ndan b�y�k olan ma�azalar� getir


-------RECURSIVE CTE EXPRESSION

WITH CTE AS (select 0 rakam UNION ALL select 1 rakam)  -- Bu �ekilde 10 a kadar gidebiliriz
SELECT * from CTE;

--- Bunu dinamik yapal�m ad�m ad�m ..DIKKAT Bu alttaki sonsuza kadar gider
---WITH CTE AS (select 0 rakam UNION ALL select rakam+1)
---SELECT * from CTE;

---WHERE blo�unda bunu s�n�rlayal�m

WITH CTE AS (select 0 rakam UNION ALL select rakam+1 from cte where rakam<9)
SELECT * from CTE;

--- Raporlamada bu tip tablolar �ok kullan�yorlar.
-- PowerBI da bir database olu�turarak bunu kullanacaks�n�z
-- DB ler genelde tarihler olur. Haftan�n g�n�, tatil mi de�il. O tarihin i�inde bulundu�u ay�n ilk g�n�, son g�n� vs
-- .. gibi attribute lar olur. Bunlar �ok b�y�k esneklik sa�lar. Sizde CTE ile ba�lay�p b�yle bir attribute(ya da tablo) olu�turabilirsiniz





--�RNEK-1
--Soru: 2020 ocak ay�n�n herbir tarihi bir sat�r olacak �ekilde 31 sat�rl� bir tablo olu�turunuz.
--with cast('2020-01-01' as date) tarih  --- veriyi date olarak cast ettik
with cte AS (
	select cast('2020-01-01' as date) AS gun
	union ALL
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select * from cte;

with cte AS (
	select ascii('A') num
	union all
	select num + 1
	from cte
	where num < ascii('Z')
)
select char(num) from cte; --Burada say�lar� cte'ye koydu. Char i�inde bunlar� char olarak d�nd�rd�


--�RNEK-2
--- Soru: Write a query that returns all staff with their manager_ids(use recursive CTE)
-- Her bir �al��an�n patronuyla CTE sini alaca��z burada

Select staff_id, first_name, manager_id from sale.staff where staff_id =1
 --- �imdi de manager � james olan ki�ileri getirelim
Select * from sale.staff a where a.manager_id = 1

-- �imdi with ekleyelim ve where a.manager_id = 1 i manuel olarak almayaca��m. Bir �nce tan�mlam�� oldu�um ki�inin id sine(staff_id) sine e�itleyece�iz

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;


WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;