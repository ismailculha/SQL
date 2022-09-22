
-------- CLAUSES -----------

CREATE TABLE departments
(
id BIGINT,
name VARCHAR(20),
dept_name VARCHAR(20),
seniority VARCHAR(20),
graduation CHAR (3),
salary BIGINT,
hire_date DATE
);

INSERT departments VALUES
 (10238,  'Eric'    , 'Economics'        , 'Experienced'  , 'MSc'      ,   72000 ,  '2019-12-01')
,(13378,  'Karl'    , 'Music'            , 'Candidate'    , 'BSc'      ,   42000 ,  '2022-01-01')
,(23493,  'Jason'   , 'Philosophy'       , 'Candidate'    , 'MSc'      ,   45000 ,  '2022-01-01')
,(36299,  'Jane'    , 'Computer Science' , 'Senior'       , 'PhD'      ,   91000 ,  '2018-05-15')
,(30766,  'Jack'    , 'Economics'        , 'Experienced'  , 'BSc'      ,   68000 ,  '2020-04-06')
,(40284,  'Mary'    , 'Psychology'       , 'Experienced'  , 'MSc'      ,   78000 ,  '2019-10-22')
,(43087,  'Brian'   , 'Physics'          , 'Senior'       , 'PhD'      ,   93000 ,  '2017-08-18')
,(53695,  'Richard' , 'Philosophy'       , 'Candidate'    , 'PhD'      ,   54000 ,  '2021-12-17')
,(58248,  'Joseph'  , 'Political Science', 'Experienced'  , 'BSc'      ,   58000 ,  '2021-09-25')
,(63172,  'David'   , 'Art History'      , 'Experienced'  , 'BSc'      ,   65000 ,  '2021-03-11')
,(64378,  'Elvis'   , 'Physics'          , 'Senior'       , 'MSc'      ,   87000 ,  '2018-11-23')
,(96945,  'John'    , 'Computer Science' , 'Experienced'  , 'MSc'      ,   80000 ,  '2019-04-20')
,(99231,  'Santosh'	,'Computer Science'  ,'Experienced'   ,'BSc'       ,  74000  , '2020-05-07' );

--------HAVING

--SELECT column_1, aggregate_function(column_2) FROM table_name GROUP BY column_1 HAVING search_condition ORDER BY ____;
--Aggreate function ile ilgili filtreleme yapmak i�in kullan�l�r.
--Agg kullan�ld��� i�in group by ile kullan�lmak zorundad�r.
--Group by'a agg function i�ine girmemi�, select k�sm�nda yazan b�t�n s�tunlar dahil edilmelidir.
--Where i�lem uygulanmam��lara uygulan�rken, Having agg functionlara uygulan�r.
--Where data agg functiona uygulanmadan uygulan�rken, Having agg funciton'dan sonra filtreleme yapar.

--�RNEK1
SELECT dept_name, AVG(salary) AS avg_salary
FROM departments
GROUP BY dept_name
HAVING AVG(salary) > 50000;

--�RNEK2 (Sample Retail Database)
SELECT category_id, MAX(list_price), MIN(list_price)
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500




--------GROUPING SETS

--SELECT column1, column2, aggregate_function (column3)
--	FROM table_name
--	GROUP BY GROUPING SETS ((column1, column2),(column1),(column2));

--Agg function ile olan i�lemi farkl� �ekillerde gruplamak i�in kullan�l�r.
--Burada fonksiyon sabit olup group set ile farkl� group by'lar yap�larak bunlar�n �zelinde sonu� d�nd�r�lebiliyor.

--�RNEK1
SELECT seniority, graduation, AVG(salary)
FROM departments
GROUP BY GROUPING SETS((seniority, graduation),(seniority),(graduation));
--Burada g�r�lece�i �zere farkl� groupby'lar tek kod diziminde yap�labliyor.

--�RNEK2 (Sample Retail)
SELECT category_id, model_year, COUNT(*)
FROM product.product
GROUP BY GROUPING SETS ((category_id),(model_year),(category_id, model_year))
ORDER BY 1,2
--Group by da oldu�u �zere se�ilen s�tunlar grouping sets i�inde yer almal�d�r



--------PIVOT CLAUSE

--SELECT [column_name], [pivot_value1], [pivot_value2], ...[pivot_value_n]
--	FROM table_name ////HANG� S�TUN VE VALUE'LARI ALACA�IMIZI SE�T�KTEN SONRA ESAS TABLOYU BEL�RL�YORUZ
--	PIVOT (
--	aggregate_function(aggregate_column) /////BUNLARA HANG� AGG FUNC UYGULANACAK BUNU BEL�RL�YORUZ
--	FOR pivot_column ////VALUE'LARIN ALINDI�I COLUMN
--	IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])),  /////EN �STTE BEL�RT�LEN VALUE'LAR YAZILIRI

--Raporlama i�lemlerinde sat�rlar�n alanlara d���t�r�lerek, her bir s�tun i�in agg function uygulanmas�n� sa�lar.
--Farkl� s�tunlara ayn� i�lemi uygulamam�z� sa�lar.
--Buradaki pivot_value bir s�tun i�indeki de�erler olarak d���n�lebilir.
--K�saca ilgili s�tuna g�re ba�ka bir s�tundan al�nan value'lar�n agg function�n� bize verir.

--�RNEK1
SELECT *
FROM (SELECT dept_name seniority, graduation, salary FROM departments) as table1
PIVOT(
AVG(salary)
FOR graduation IN ([MSc],[BSc],[PHd])) as sonuc_
--�lk pivota esas olacak tabloyu tan�mlarken as ile yeni tabloya isim verilmek zorunday�z�
--Pivot sonucuna da yine ayn� �ekilde as ile isim verilmek mecburiyeti vard�r. Yoksa hata veriyor.
--Temel manada ilk Select ile hangi s�tunlar�n al�naca�� se�ildikten sonra
--	For ile hangi s�tunun i�indeki verilerin columna yaz�laca��,
--	Agg func ile hangi de�erin neyinin yaz�laca�� belirtiliyor. Kalan s�tunlardan ilk s�radaki ise rowlara yaz�l�yor


--�RNEK2 (Sample Retail)
SELECT model_year , COUNT(product_id)
FROM product.product
GROUP BY model_year;

SELECT *
FROM (SELECT category_id, model_year, product_id FROM product.product) AS TABLE1
PIVOT
( COUNT(product_id)
FOR model_year IN ([2018],[2019],[2020],[2021]) )AS PIVOT_TABLE




--------ROLLUP

--SELECT d1, d2, d3, aggregate_function(c4) FROM table_name GROUP BY ROLLUP (d1, d2, d3);
--d1, d2, d3
--d1, d2, NULL
--d1, NULL, NULL
--NULL, NULL, NULL sa�dan sola oalcak �ekilde rollup parantezinde olanlar� tedk tek ��kart�r

--�RNEK1
SELECT  seniority, graduation, AVG(salary)
FROM departments
GROUP BY ROLLUP (seniority, graduation) 

--�RNEK2 (Sample Retail)
SELECT brand_id, category_id, model_year, COUNT(*)
FROM product.product
GROUP BY ROLLUP (brand_id, category_id, model_year)
ORDER BY 1,2,3



---------CUBE

--SELECT d1,d2, d3, aggregate_function (c4) FROM table_name GROUP BY CUBE (d1, d2, d3);

--Rollup benzeri gibidir fakat parantez i�indekilerin null dahil olmak �zere t�m kombinasyonlar�n� al�r.

--�RNEK1
SELECT  seniority, graduation, AVG(salary)
FROM departments
GROUP BY CUBE (seniority, graduation) 

--�RNEK2 (Sample Retail)
SELECT brand_id, category_id, COUNT(*)
FROM product.product
GROUP BY CUBE (brand_id, category_id, model_year)
ORDER BY 1,2


----------SET


--UNION = 2 Select komutunu duplicate veriler olmayacak �ekilde birle�tirmeye yarar
--UNION ALL = 2 Select komutu sonucunu b�t�n haliyle birle�tirmeye yarar, duplica veriler olabilir
--INTERSECT = 2 Select komutyu sonucu kesi�im k�mesini verir. Duplica veri olmaz
--EXCEPT = 2 Select komutu sonucunda kesi�im d���nda kalan kendi k�mesini verir. Duplica veri olmaz

--Set i�lemi i�in
--1. Select komutu sonucunda ayn� say�da column i�leme al�nmal�d�r
--2. Se�ilen columnlar ayn� data tipinde olmal�d�r
--3. Order by sorgu sonucunda sadece en sonda bir kez kullan�l�r
--4. Union ve intersectte sorgu s�ras� �enmli de�ildir. �kiside kesi�im yada birle�im veriyor.
--5. Union duplica de�erleri d���rd��� i�in union all daha performansl�d�r.
--6. Set alt query'lerde de kullan�labilir.

--SELECT column1, column2, ... FROM table_A
--UNION // UNION ALL // INTERSECT // EXCEPT
--SELECT column1, column2, ...FROM table_B

--�RNEK1
SELECT A.last_name
FROM sale.customer A
WHERE A.city = 'Aurora'
UNION
SELECT B.last_name as soy
FROM sale.customer B
WHERE B.city = 'Charlotte'
--Burada �nemli olan de�i�kenlerin s�ras� ve cinsi

--�RNEK2
SELECT * INTO  #THOMAS 
FROM
(SELECT A.first_name, A.last_name
FROM sale.customer A
WHERE A.first_name = 'Thomas'
UNION ALL
SELECT A.first_name, A.last_name
FROM sale.customer A
WHERE A.last_name = 'Thomas') AS TMP
--Burada ge�ici tablo olu�turuldu. Select * into from format�n�da g�rm�� olduk


--�RNEK3
(SELECT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id AND A.model_year=2018
INTERSECT
SELECT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id AND A.model_year=2019)


--�RNEK4
SELECT *
FROM(
SELECT first_name, last_name, so.customer_id
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2018
INTERSECT
SELECT first_name, last_name, so.customer_id
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2019
INTERSECT
SELECT first_name, last_name, so.customer_id
FROM sale.customer sc, sale.orders so
WHERE sc.customer_id = so.customer_id and
	  YEAR (so.order_date) = 2020) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date


--�RNEK5
SELECT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id AND A.model_year = '2018'
EXCEPT
SELECT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id AND A.model_year = '2019'


--�RNEK6
SELECT A. product_id, A.product_name
FROM product.product A, sale.orders B, SALE.order_item C
WHERE A.product_id = C.product_id AND B.order_id = C.order_id AND YEAR(B.order_date) = 2019
EXCEPT
SELECT A. product_id, A.product_name
FROM product.product A, sale.orders B, SALE.order_item C
WHERE A.product_id = C.product_id AND B.order_id = C.order_id AND  NOT YEAR(B.order_date) = 2019


--�RNEK7
SELECT *
FROM
			(
			SELECT P.product_name, P.product_id, YEAR(O.order_date) as order_year
			FROM product.product P, sale.orders O, sale.order_item OI 
			WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id
			) A
PIVOT
(
	count(product_id)
	FOR order_year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE;


----------CASE


--CASE case_expression
--  WHEN when_expression_1 THEN result_expression_1
--  WHEN when_expression_1 THEN result_expression_1
--  [ ELSE else_result_expression ]
--	END


--Tam anlam�yla if / else mant��� ile �al���r.
--E�er else kullan�lmazsa ki zorunlu de�il, null d�nd�r�r.


--�RNEK1 (Simple Case)
SELECT dept_name, [name],
	CASE dept_name
		WHEN 'Computer Science' THEN 'IT'
		ELSE 'others'
		END 
FROM departments
--Selectten hemen sonra yaz�l�yor,
--Case te yazan expressiona g�re bak�l�yor. Buras� bak�lacak s�tun olmal�. 
--Case selectten sonra yaz�lmal� ve takibinde virg�l konulmal�
--En son end ile kapat�lmal�d�r. as ile isim verilebilir s�tuna


--�rnek2 (Searched Case)
SELECT name, salary,
	CASE 
	WHEN salary <= 40000 THEN 'LOW'
	WHEN salary >40000 AND salary <= 75000 THEN 'MIDDLE'
	WHEN salary > 40000 THEN 'HIGH'
	END AS salary_inf
FROM departments;

SELECT name, salary
FROM departments
WHERE 	
CASE 
	WHEN salary <= 40000 THEN 'LOW'
	WHEN salary >40000 AND salary <= 75000 THEN 'MIDDLE'
	WHEN salary > 40000 THEN 'HIGH'
	END = 'HIGH';


SELECT name,
       SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) AS Seniority,
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) AS Graduation
FROM departments
GROUP BY name
HAVING 
	SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) > 0 AND
    SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) > 0;


--�RNEK3
SELECT order_id, order_status,
CASE order_status
	WHEN 1 THEN 'Pending'
	WHEN 2 THEN 'Processing'
	WHEN 3 THEN 'Rejected'
	ELSE 'Completed'
	END AS order_status_desc
FROM sale.orders


--�RNEK4
SELECT first_name, last_name, store_id,
CASE
	WHEN store_id = 1 THEN (SELECT store_name FROM sale.store WHERE store_id=1)
	WHEN store_id = 2 THEN (SELECT store_name FROM sale.store WHERE store_id=2)
	WHEN store_id = 3 THEN (SELECT store_name FROM sale.store WHERE store_id=3)
	END AS Store_Name
FROM sale.staff
--Burada case in yan�na store id yazsayd�m When'den sonra 1,2,3 yazmam yeterliydi


--�RNEK5
SELECT first_name, last_name,email,
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_service_provider
FROM sale.customer


--�RNEK6
select	c.order_id, count(distinct a.category_id) uniqueCategory
from	product.category A, product.product B, sale.order_item C
where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
		A.category_id = B.category_id AND
		B.product_id = C.product_id
group by C.order_id
having	count(distinct a.category_id) = 3;



--�RNEK7
select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;









