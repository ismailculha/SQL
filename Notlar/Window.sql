---------------WINDOW FUNCTION


--window_function (expression) OVER (
--[ PARTITION BY expr_list ]
--[ ORDER BY order_list ] [ frame_clause ])

--Genel manada normal functýonlardan farklý olarak gruplamayý sýralamayý kendi içinde yaparak satýr bazýnda veri döndürmemizi saðlar.
--Satýr sayýsý ayný kalacak þekilde veri döndürüyor.
--The OVER() clause can take the following clauses to extend its functionality:
--PARTITION BY clause: Defines window partitions to form groups of rows
--ORDER BY clause: Orders rows within a partition
--ROW or RANGE clause: Defines the scope of the function

--ÖRNEK-1
USE master
SELECT DISTINCT graduation, seniority, COUNT (id) OVER() as cnt_employee FROM departments
--Overýn içini doldurmazsa toplamý yanýnda veriyor

SELECT DISTINCT graduation, COUNT(id) OVER (PARTITION BY graduation ) FROM departments
-- Overin içini doldurma þeklien göre þekillendiriyor


SELECT hire_date, COUNT (id) OVER(ORDER BY hire_date) cnt_employee FROM departments
-- ORDER BY YAPTIÐI ZAMAN KÜMÜLATÝF TOPLAM ALIYOR AGG FUNC ÝLE KULLANIMINDA




--Ranking Window Functions (Hepsinde order by kullanýlmak zorundadýr)
--CUME_DIST	Compute the cumulative distribution of a value in an ordered set of values.
--DENSE_RANK	Compute the rank for a row in an ordered set of rows with no gaps in rank values.
--NTILE	Divide a result set into a number of buckets as evenly as possible and assign a bucket number to each row.
--PERCENT_RANK	Calculate the percent rank of each row in an ordered set of rows.
--RANK	Assign a rank to each row within the partition of the result set.
--ROW_NUMBER	Assign a sequential integer starting from one to each row within the current partition.

SELECT name, RANK() OVER(ORDER BY hire_date DESC) AS rank_duration FROM departments; --Ýþe giriþ tarihlerine göre rank verdi. 
--Rank function eðer ki sonuç ayný ise ayný ranki verir. --Satýr numarasýný atar. Ayný deðerlerde küçük olan satýr numarasýný atar
SELECT name, DENSE_RANK() OVER(ORDER BY hire_date DESC) AS rank_duration FROM departments;
--Dense rank ise sýra ile atama yapar

SELECT name, seniority, hire_date, ROW_NUMBER() OVER(PARTITION BY seniority ORDER BY hire_date DESC) AS row_number FROM departments;
--Row number kendisine verilen ölçüt çerçevesinde her bir satýra numara veriyor




--Value Window Functions
--FIRST_VALUE	Get the value of the first row in a specified window frame.
--LAG	Provide access to a row at a given physical offset that comes before the current row.
--LAST_VALUE	Get the value of the last row in a specified window frame.
--LEAD	Provide access to a row at a given physical offset that follows the current row.

SELECT id, name, LAG(name) OVER(ORDER BY id) AS previous_name FROM departments;
--Bir öncekini otomatik olarak alýyor. 
--name yanýna virgül ile baþka bir þey yazýlýrsa onu kullanýr, kullanýlýrsa outbond olduðu zaman ne döndüreceði belirtilir.
SELECT id, name, LEAD(name,2) OVER(ORDER BY id) AS next_name FROM departments;
SELECT id, name , FIRST_VALUE (name) OVER(ORDER BY id) AS first_name FROM departments;
SELECT id, name,
	LAST_VALUE(name) OVER(ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_name
FROM departments;

--SYNTAX

--FUNCTION() OVER( PARTITION BY ..... ORDER BY ....... WINDOW FRAME ........)
-- WINDOW FRAME:


--ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW	
--Start at row 1 of the partition and include rows up to the current row.

--ROWS UNBOUNDED PRECEDING	
--Start at row 1 of the partition and include rows up to the current row.

--ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING	
--Start at the current row and include rows up to the end of the partition.

--ROWS BETWEEN N PRECEDING AND CURRENT ROW.	
--Start at a specified number of rows before the current row and include rows up to the current row.

--ROWS BETWEEN CURRENT ROW AND N FOLLOWING	
--Start at the current row and include rows up to a specified number of rows following the current row.

--ROWS BETWEEN N PRECEDING AND N FOLLOWING	
--Start at a specified number of rows before the current row and include a specified number of rows following the current row. Yes, the current row is also included!





---------DERSLER

--AGGREGATE WINDOW FUNCTIONS: MIN, MAX, SUM, AVG, COUNT




USE SampleRetail
--ürünlerin stock sayýlarýný bulunuz
SELECT product_id, SUM(quantity) AS total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id;

SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id) AS total_stock
FROM product.stock;

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.
SELECT DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) AS avg_price
FROM product.product;

select distinct brand_id, model_year	
		,avg(list_price) over(partition by brand_id,model_year) avg_price
		,count(*) over(partition by brand_id,model_year) count_product
		,max(list_price) over(partition by brand_id,model_year) max_price
		,count(*) over(partition by model_year) model_count
from [product].[product]


select	product_id, brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by brand_id, category_id, model_year


-- Window Frames

-- Windows frame i anlamak için birkaç örnek:
-- Herbir satýrda iþlem yapýlacak olan frame in büyüklüðünü (satýr sayýsýný) tespit edip window frame in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(product_id) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(product_id) OVER(PARTITION BY category_id ORDER BY  product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(product_id) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(product_id) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(product_id) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(product_id) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

--WINDOW FRAME DEFAULT OLARAK UNBOUNDED PRECEDING AND CURRENT ROW OLDUÐU ÝÇÝN COUNT(*) ORDER BY DAN SONRA YAZILMASA DAHÝ AYNI SONUCU VERÝYOR

-- Cheapest product price in each category
-- Herbir kategorideki en ucuz ürünün fiyatý
SELECT DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id )
FROM product.product

-- How many different product in the product table?
-- Product tablosunda toplam kaç faklý product bulunduðu
SELECT DISTINCT COUNT(*) OVER()
FROM product.product

SELECT DISTINCT COUNT(*) OVER()
FROM( SELECT DISTINCT product_id FROM sale.order_item) table1

SELECT COUNT(DISTINCT product_id)
FROM sale.order_item


-- Write a query that returns how many products are in each order?
-- Her sipariþte kaç ürün olduðunu döndüren bir sorgu yazýn?
SELECT DISTINCT order_id, SUM(quantity) OVER(PARTITION BY order_id)
FROM sale.order_item

-- Herbir kategorideki herbir markada kaç farklý ürünün bulunduðu
SELECT DISTINCT category_id, brand_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id ) 
FROM producT.product

SELECT DISTINCT A.category_id, A.brand_id, COUNT(A.product_id) OVER(PARTITION BY A.category_id, A.brand_id ) 
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id

--AGGREGATE WINDOW FUNCTIONS: MIN, MAX, SUM, AVG, COUNT
--NAVIGATION WINDOW FUNCTIONS: FIRST_VALUE, LAST_VALUE, NTH_VALUE, LAG, LEAD
--NUMBERING WINDOW FUNCTIONS: ROW_NUMBER, RANK, DENSE_RANK, NTILE, CUME_DIST, PERCENT_RANK




--NAVIGATION WINDOW FUNCTIONS: FIRST_VALUE, LAST_VALUE, NTH_VALUE, LAG, LEAD

--Order by kesinlikle kullanýlmalýdýr


--Maðaza bazýnda en çok stoða sahip olan ürünleri getiriniz
SELECT DISTINCT store_id, FIRST_VALUE(product_id) OVER(PARTITION BY store_id ORDER BY quantity DESC) most_stocked_prod 
FROM product.stock


--Write a query that returns customers and their most valuable order with total amount of it.

--ÇÖZÜM-1
WITH T1 AS
(
SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)
SELECT	DISTINCT customer_id,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MV_ORDER,
		FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MVORDER_NET_PRICE
FROM	T1

--ÇÖZÜM-2
select distinct customer_id,first_value(order_id) over(partition by customer_id order by sum_ desc) order_id
				,first_value(sum_) over(partition by customer_id order by sum_ desc) net_price
from 
(
select distinct so.[customer_id],so.order_id
		,sum([quantity]*[list_price]*(1-[discount])) over(partition by [customer_id],so.order_id order by so.order_id ) sum_
from [sale].[order_item]soi ,[sale].[orders] so
where so.[order_id]=soi.[order_id]
) A

SELECT DISTINCT YEAR(order_date), MONTH(order_date), FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date)
FROM sale.orders




SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock
--Order by da iki sütun kullanýldý
--rowsda manuel satýr sayýsý eklenebiliyor. range ise sadece kewwordlerle ilerlenecekse range 
SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock


--Write a query that returns the order date of the one previous sale of each staff(use de LAG function).
SELECT O.order_id,S.staff_id,S.first_name,S.last_name,O.order_date , 
	LAG(order_date) OVER(PARTITION BY S.staff_id ORDER BY O.order_id) previous_order_date
FROM sale.staff S,sale.orders O
WHERE O.staff_id=S.staff_id

SELECT SO.order_id, SS.staff_id, SS.first_name, SS.last_name, SO.order_date,
	LEAD(SO.order_date) OVER(PARTITION BY SS.staff_id ORDER BY SO.order_id )
FROM sale.staff SS, sale.orders SO
WHERE SS.staff_id = SO.staff_id


--PERSONELÝN ORTALAMA KAÇ GÜN ÝÇÝNDE TEKRAR SATIÞ YAPTIÐI BÝLGÝSÝ
SELECT DISTINCT staff_id ,AVG(fark) OVER(PARTITION BY staff_id)
FROM(
SELECT staff_id, order_id, order_date,
	DATEDIFF(DAY, LAG(order_date) OVER(PARTITION BY staff_id ORDER BY order_id ), order_date) as fark
FROM sale.orders) as tablo1
WHERE NOT fark IS NULL



--NUMBERING WINDOW FUNCTIONS: ROW_NUMBER, RANK, DENSE_RANK, NTILE, CUME_DIST, PERCENT_RANK


--Assign an ordinal number to the product prices for each category in ascending order
--1. Herbir kategori içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)

SELECT product_id, category_id, list_price, ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price ) ROW_NUM
FROM product.product


-- Ayný soruyu ayný fiyatlý ürünler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)
SELECT product_id, category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price ) ROW_NUM,
	RANK() OVER(PARTITION BY category_id ORDER BY list_price ) RANK_ROW_NUM,
	DENSE_RANK () OVER(PARTITION BY category_id ORDER BY list_price ) DENSE_ROW_NUM
FROM product.product
--Bu üçünde foksiyonun saðýnda yer alan parantez boþ kalýyor. Çünkü içeri alýnandan baðýmsýz sonuç döndürüyor 


--CUME_DIST = ROW NUMBER / TOTAL_ROW
--PERCENT_RANK =  (ROW NUMBER-1) / (TOTAL_ROW-1)
--NTILE = SÜTUNU ÝSTENEN KADAR KÜMEYE AYIRIYOR


--Herbir model_yili içinde ürünlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)
-- row_number(), rank(), dense_rank()
SELECT product_id, model_year, list_price,
	ROW_NUMBER() OVER(PARTITION BY model_year ORDER BY list_price ) ROW_NUM,
	RANK() OVER(PARTITION BY model_year ORDER BY list_price ) RANK_ROW_NUM,
	DENSE_RANK () OVER(PARTITION BY model_year ORDER BY list_price ) DENSE_ROW_NUM
	FROM product.product

-- Write a query that returns the cumulative distribution and relatýve standing of the list price in product table by brand.
-- product tablosundaki list price' larýn kümülatif daðýlýmýný marka kýrýlýmýnda hesaplayýnýz
SELECT product_id, brand_id, list_price,
	ROUND(CUME_DIST() OVER(PARTITION BY brand_id ORDER BY list_price),3) AS CumeDýst,
	ROUND(PERCENT_RANK() OVER(PARTITION BY brand_id ORDER BY list_price),3) AS PercentRank,
	NTILE(100) OVER( ORDER BY list_price) AS Ntýle
FROM product.product
ORDER BY 2


-- Yukarýdaki sorguda CumDist alanýný CUME_DIST fonksiyonunu kullanmadan hesaplayýnýz.
SELECT brand_id, list_price, ROW_NUMBER() OVER(PARTITION BY brand_id ORDER BY list_price),
CONVERT(NUMERIC(18,3), (COUNT(*) OVER(PARTITION BY brand_id ORDER BY list_price) *1.0) / 
	(COUNT(*) OVER(PARTITION BY brand_id)*1.0))
FROM product.product


with tbl as (
	select	brand_id, list_price,
			count(*) over(partition by brand_id) TotalProductInBrand,
			row_number() over(partition by brand_id order by list_price) RowNum,
			rank() over(partition by brand_id order by list_price) RankNum
	from	product.product
)
select *,
        ROUND(CAST(RowNum as float) / TotalProductInBrand, 3)  CumDistRowNum,
        STR(CONVERT(float, RankNum) / TotalProductInBrand, 10, 3) CumDistRankNum
from tbl

--Write a query that returns both of the followings:
--The average product price of orders.
--Average net amount.
--Aþaðýdakilerin her ikisini de döndüren bir sorgu yazýn:
--Sipariþlerin ortalama ürün fiyatý.
--Ortalama net tutar.

SELECT DISTINCT order_id, 
	AVG(list_price) OVER(PARTITION BY order_id ) AS avg_price,
	AVG(list_price*quantity*(1-discount)) OVER() avg_price_total
FROM sale.order_item


--Ortalama ürün fiyatýnýn ortalama net tutardan yüksek olduðu sipariþleri listeleyin.

SELECT *
FROM(
	SELECT DISTINCT order_id, 
		AVG(list_price) OVER(PARTITION BY order_id ) AS avg_price,
		AVG(list_price*quantity*(1-discount)) OVER() avg_price_total
	FROM sale.order_item) AS table1
WHERE avg_price > avg_price_total
ORDER BY 2


--Calculate the stores' weekly cumulative number of orders for 2018
--maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz

SELECT *, SUM(weeks_order) OVER(PARTITION BY  store_id ORDER BY week_of_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM(
	SELECT DISTINCT SS.store_id, SS.store_name, DATEPART(WEEK,order_date) week_of_year,
	COUNT(*) OVER(PARTITION BY DATEPART(WEEK,order_date), SS.store_id) AS weeks_order
	FROM sale.store SS, sale.orders SO
	WHERE SS.store_id = SO.store_id AND YEAR(order_date) = 2018
) AS table1


--Calculate the stores' weekly cumulative number of orders for 2018
--maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz
select distinct a.store_id, a.store_name, -- b.order_date,
	datepart(WEEK, b.order_date) WeekOfYear,
	COUNT(*) OVER(PARTITION BY a.store_id, datepart(WEEK, b.order_date)) weeks_order,
	COUNT(*) OVER(PARTITION BY a.store_id ORDER BY datepart(WEEK, b.order_date)) cume_total_order
from sale.store A, sale.orders B
where a.store_id=b.store_id and year(order_date)='2018'
ORDER BY 1, 3
;

--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.

SELECT *,AVG(sum_) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING  AND CURRENT ROW) AS avg_
FROM(
SELECT DISTINCT SO.order_date, SUM(quantity) OVER (PARTITION BY SO.order_date ORDER BY SO.order_date) sum_
	FROM sale.orders SO, sale.order_item SI
WHERE SO.order_id = SI.order_id AND
	SO.order_date BETWEEN '2018-03-12' AND '2018-04-12') as table1;


-- Eksik kalan günleri de dahil ederek hesap ediniz
with day1 AS (
	select cast('2018-03-12' as date) AS gun
	union ALL
	select DATEADD(DAY,1,gun)
	from day1
	where gun < '2018-04-12'
),
cte1 AS(
SELECT DISTINCT SO.order_date, SUM(quantity) OVER (PARTITION BY SO.order_date ORDER BY SO.order_date) sum_
	FROM sale.orders SO, sale.order_item SI
	WHERE SO.order_id = SI.order_id AND
		SO.order_date BETWEEN '2018-03-12' AND '2018-04-12')
SELECT *, AVG(sum2) OVER (ORDER BY gun ROWS BETWEEN 6 PRECEDING  AND CURRENT ROW) AS avg
FROM(
SELECT gun, IIF(sum_ IS NULL, 0, sum_) AS sum2--, AVG(IIF(sum_ IS NULL, 0, sum_)) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING  AND CURRENT ROW) AS avg_
FROM day1 A
LEFT JOIN cte1 B
	ON A.gun = B.order_date) as table3

--LÝst customers whose have at least 2 consecutive orders are not shipped
SELECT customer_id
FROM(
SELECT *, LAG(shipping) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_shipping,
	shipping + LAG(shipping) OVER(PARTITION BY customer_id ORDER BY order_date)  AS RESULT
FROM(
SELECT customer_id, order_status, order_date,
CASE 
	WHEN shipped_date IS NULL THEN 0
	ELSE 1
	END shipping
FROM sale.orders) table1) as table2
WHERE RESULT = 0