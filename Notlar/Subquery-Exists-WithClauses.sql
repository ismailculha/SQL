-------SUBQUERY



--3 þekilde kullanýlabilir.Select, From ve Where ile.
--Between sadece subquery içinde kullanýlabilir. Dýþýnda kullanýlamaz
--Correlated subquery dýþ ve iç query'lerin birbirleri ile baðlantýsý olmasý halinde kullanýlýr.
--SELECT id, name, graduation, seniority FROM departments AS A WHERE dept_name IN
--(
--SELECT dept_name FROM  departments AS B WHERE A.id= B.id  GROUP BY dept_name HAVING AVG(salary) > 80000)

--Exist operatörü correlated subquerylerde içindekiler dýþarýdakilerin eþleþmesi için kullanýlýr.
--Not exist ise olumsuz olarak içeride çýkanlarýn dýþýndakileri bize verir.
-- _____WHERE NOT EXISTS ( SELECT 1______ þeklinde kullanýlýyor



--ÖRNEK1 (With Subquery)
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
--Ýkiside ayný sonucu döndürüyor


--ÖRNEK2 (With Subquery)
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
--Ýkiside ayný sonucu döndürüüyor fakat subquery'de her bir tabloyu iþlem miktarý kadar her seferinde çaðýrýrken
--joinlerde tablo bir kere çaðrýlarak birleþtiriliyor ve iþlemler üzerinden yapýlabiliyor. 
--Bu baðlamda joinle iþlem yapmak peprformans açýsýndan daha tercih edilesi bir yöntem olarak durmaktadýr.

--ÇOK ÖNEMLÝ NOT: ORDER  BY'DA QUERY'DE YER ALMASA BÝLE AGG FUNCTION ÝLE YAPABÝLMEKTEYÝZ. ÖRNEÐÝN TOPLAM TUTARI SROGU 
--	SONUCUNDA ÝSTEMESEK BÝLE SIRALAMAYI BU ÞEKÝLDE YAPABÝLÝYORUZ.


--ÖRNEK-1
--Soru: Apple - Pre-Owned iPad 3 - 32GB - White ürünün hiç sipariþ verilmediði eyaletleri bulunuz.
--Eyalet müþterilerin ikamet adreslerinden alýnacaktýr.
--Ürünü satýn alanlarýn listesi
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
	C2.state = SC.state --Burada existin baþý ile sonunu eþliyor
	)


--ÖRNEK-2
--Soru: Burkes Outlet maðaza stoðunda bulunmayýp,
-- Davi techno maðazasýnda bulunan ürünlerin stok bilgilerini döndüren bir sorgu yazýn
SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
NOT EXISTS( SELECT A.product_id, A.store_id, A.quantity
FROM product.stock A, sale.store B
WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND PC.product_id = A.product_id AND A.quantity>0);
--Not exist dendiðinde aþaðýdakinde olmayýp diðerinde olan demek
--Exist ise aþaðýdakinde olup yukarýdakinde de olan demek




--ÖRNEK-3
-- Brukes Outlet storedan alýnýp The BFLO Store maðazasýndan hiç alýnmayan ürün var mý?
-- Varsa bu ürünler nelerdir?
-- Ürünlerin satýþ bilgileri istenmiyor, sadece ürün listesi isteniyor.
SELECT DISTINCT product_id
FROM sale.store SS, sale.orders SO, sale.order_item SI
WHERE SS.store_id = SO.store_id AND SO.order_id = SI.order_id AND SS.store_name = 'Burkes Outlet' AND  NOT EXISTS(
SELECT DISTINCT C.product_id
FROM sale.store A, sale.orders B, sale.order_item C
WHERE A.store_id = B.store_id AND B.order_id = C.order_id AND A.store_name = 'The BFLO Store' AND SI.product_id = C.product_id)
---ÇÖZÜM2
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
--ÇÖZÜM3
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


--Sorgu süresince kullanýlýr. Yalnýzca ait olduklarý sorgu içinde kullanýlabilir.
--Bütün CTE'ler with ile baþlar. SELECT;DELETE;UPDATE; INSERT komutlarý ile kullanýlýr.
--WITH query_name [(column_name1, ...)] AS 
--    (SELECT ...) -- CTE Definition
--SELECT * FROM query_name; -- SQL_Statement
-- Bir VIEW gibi çalýþýrlar.
-- Sorgu sürecinde o sýrada meydana gelip daha sonra Sorgu sonunda kaybolan objelerdir.
-- Sadece sorguya özgü VIEW diyebiliriz.
-- ALL CTEs(ordinary or recursive) stat with a "WITH" clause ...
-- Bir common table içinde birden fazla WITH clause kullanýlabilir
-- 2. çeþiti var 1.Ordinary 2. Recursive

--Burada withTen sonra ayzýlan bölümden sonra sütun belirtilirken burasý CTE definition kýsmýndaki sütun isimleri ile ayný olmalýdýr.
WITH temp_table (avgsa) AS
	(
  SELECT AVG(salary)
	FROM departments
  )
	SELECT name, salary
	FROM departments INNER JOIN temp_table 
	ON departments.salary > temp_table.avgsa;  --On kýsmýna büyük küçük ifade kullandý



WITH cte
    AS (SELECT 1 AS n -- anchor member
        UNION ALL
        SELECT n + 1 -- recursive member
        FROM   cte
        WHERE  n < 10) -- terminator
SELECT n
FROM cte;


--ÖRNEK-1
-- 1.Ordinary Common Table Expressions
-- Soru: -- Jerald Berray isimli müþterinin son sipariþinden önce sipariþ vermiþ 
--ve Austin þehrinde ikamet eden müþterileri listeleyin.
WITH tbl AS
(SELECT TOP 1 order_date AS last_date  --max(b.order_date) JeraldLastOrderDate ile de yapýlabilirdi.
FROM sale.customer A, sale.orders B
WHERE first_name = 'Jerald ' AND last_name = 'Berray ' AND A.customer_id = B.customer_id
ORDER BY order_date DESC)
SELECT DISTINCT A.first_name, A.last_name
FROM sale.customer A, sale.orders B, tbl C
WHERE A.city = 'Austin' AND A.customer_id = B.customer_id AND B.order_date < C.last_date
--Burada öenmli olan with ile yapýlan join iþleminde tekrar id'leri birleþtirmek zorunda kalmýyorsun. Ýhtiyacýn olana bakýyosun
--Kolayca kodun bir kýsmýný yazmamýzý saðlýyor


--ÖRNEK-2
-- Herbir markanýn satýldýðý en son tarihi bir CTE sorgusunda,
-- Yine herbir markaya ait kaç farklý ürün bulunduðunu da ayrý bir CTE sorgusunda tanýmlayýnýz.
-- Bu sorgularý kullanarak  Logitech ve Sony markalarýna ait son satýþ tarihini ve toplam ürün sayýsýný (product tablosundaki) ayný sql sorgusunda döndürünüz.
--ÇÖZÜM1 YANLIÞ	
		WITH tbl1 ( brand_id, name_,marka,son_tarih) AS(
		SELECT DISTINCT B.brand_id, B.brand_name, COUNT(B.brand_id) AS marka_sayý, MAX(D.order_date)
		FROM product.product A, product.brand B, sale.order_item C, sale.orders D
		WHERE A.brand_id = B.brand_id AND A.product_id = C.product_id AND A.product_id = D.order_id
		GROUP BY B.brand_id, B.brand_name )
		SELECT DISTINCT B.*
		FROM product.brand A, tbl1 B
		WHERE B.name_ = 'Logitech' OR B.name_ = 'Sony'
--COUNTI inner join yaptýðým için yanlýþ count iþlemi verdi. Order içinde count iþlemi verdi. Doðrusu için ayrý ayrý yapmam gerekirdi.

--ÇÖZÜM BU
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


--ÖRNEK-3
--- Soru: --2018 yýlýnda tüm maðazalarýn ortalama cirosunun altýnda ciroya sahip maðazalarý listeleyin.
--List the stores their earnings are under the average income in 2018.
--- with clause un altýnda 2 tane tablo tanýmlayacaðýz

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

---1. tabloda Her bir store name her bir maðazanýn yapmýþ olduðu satýþ tutarý. Filtre olarak da yýla 2018 dedik
---2.tabloda T1 deki deðerlere göre ortalama aldýk
--- Tablolarý birbiri içerisinde referans gösterebiliyoruz
--- Final de T1,T2 tablosuna git T2 deki ortalama cironun T1 deki store cirolarýndan büyük olan maðazalarý getir


-------RECURSIVE CTE EXPRESSION

WITH CTE AS (select 0 rakam UNION ALL select 1 rakam)  -- Bu þekilde 10 a kadar gidebiliriz
SELECT * from CTE;

--- Bunu dinamik yapalým adým adým ..DIKKAT Bu alttaki sonsuza kadar gider
---WITH CTE AS (select 0 rakam UNION ALL select rakam+1)
---SELECT * from CTE;

---WHERE bloðunda bunu sýnýrlayalým

WITH CTE AS (select 0 rakam UNION ALL select rakam+1 from cte where rakam<9)
SELECT * from CTE;

--- Raporlamada bu tip tablolar çok kullanýyorlar.
-- PowerBI da bir database oluþturarak bunu kullanacaksýnýz
-- DB ler genelde tarihler olur. Haftanýn günü, tatil mi deðil. O tarihin içinde bulunduðu ayýn ilk günü, son günü vs
-- .. gibi attribute lar olur. Bunlar çok büyük esneklik saðlar. Sizde CTE ile baþlayýp böyle bir attribute(ya da tablo) oluþturabilirsiniz





--ÖRNEK-1
--Soru: 2020 ocak ayýnýn herbir tarihi bir satýr olacak þekilde 31 satýrlý bir tablo oluþturunuz.
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
select char(num) from cte; --Burada sayýlarý cte'ye koydu. Char içinde bunlarý char olarak döndürdü


--ÖRNEK-2
--- Soru: Write a query that returns all staff with their manager_ids(use recursive CTE)
-- Her bir çalýþanýn patronuyla CTE sini alacaðýz burada

Select staff_id, first_name, manager_id from sale.staff where staff_id =1
 --- Þimdi de manager ý james olan kiþileri getirelim
Select * from sale.staff a where a.manager_id = 1

-- Þimdi with ekleyelim ve where a.manager_id = 1 i manuel olarak almayacaðým. Bir önce tanýmlamýþ olduðum kiþinin id sine(staff_id) sine eþitleyeceðiz

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