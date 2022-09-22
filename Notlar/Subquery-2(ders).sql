--ÖRNEK1
SELECT order_id,list_price,
(
SELECT AVG(list_price)
FROM sale.order_item
WHERE	order_id=A.order_id --Transformda olduðu gibi eþitlersen sonucu o þekilde evriyor
) 
AS AVG_PRICE
FROM sale.order_item A


SELECT A.order_id, A.list_price, AVG(B.list_price)
FROM sale.order_item A
LEFT JOIN sale.order_item B
ON A.order_id = B.order_id
GROUP BY A.order_id, A.list_price
ORDER BY 1

SELECT order_id, (SELECT SUM(list_price) FROM product.product  WHERE product_id = B.product_id )
FROM sale.order_item B
ORDER BY order_id

--iKÝSÝ ARASINDAKÝ FARKIN NEDENLERÝNIN MANTIKSAL AÇIKLAMASI ???
--1. KOD
SELECT  B.order_id, (SELECT SUM(list_price*quantity*(1-discount)) FROM sale.order_item WHERE order_id = B.order_id ) AS TOTAL
FROM sale.order_item B
GROUP BY B.order_id
--2. KOD
SELECT  order_id, (SELECT SUM(B.list_price*B.quantity*(1-B.discount)) FROM sale.order_item B WHERE B.order_id = order_id ) AS TOTAL
FROM sale.order_item
GROUP BY order_id

SELECT *
FROM sale.staff
WHERE manager_id = (SELECT staff_id FROM sale.staff WHERE first_name = 'Davis ' AND last_name = 'Thomas')

SELECT * 
FROM sale.staff 
WHERE manager_id =(SELECT staff_id FROM sale.staff WHERE first_name = 'Charles' AND last_name = 'Cussona')


SELECT product_id, product_name, model_year, list_price
FROM product.product
WHERE list_price > (
		SELECT list_price 
		FROM product.product 
		WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')

SELECT first_name, last_name, B.order_date
FROM sale.customer A, sale.orders B
WHERE A.customer_id = B.customer_id AND B.order_date IN 
(SELECT B.order_date FROM sale.customer A, sale.orders B 
WHERE A.customer_id = B.customer_id AND A.first_name = 'Laurel' AND A.last_name = 'Goldammer')


SELECT PP.product_name, PP.list_price
FROM product.product PP, product.category PC
WHERE PP.category_id = PC.category_id AND
PP.model_year = '2021' AND PC.category_name  NOT IN (
SELECT category_name
FROM product.category
WHERE category_name IN ('Game','GPS','Home Theater'))
--PC.category_name NOT IN ('Game','GPS','Home Theater')

SELECT product_name, model_year, list_price
FROM product.product PP
WHERE model_year = 2020 AND list_price > (
SELECT MAX (PP.list_price)
FROM product.category PC, product.product PP
WHERE category_name = 'Receivers Amplifiers' AND PP.category_id = PC.category_id )
ORDER BY 3 DESC

SELECT product_name, model_year, list_price
FROM product.product PP
WHERE model_year = 2020 AND list_price > ALL (
SELECT PP.list_price
FROM product.category PC, product.product PP
WHERE category_name = 'Receivers Amplifiers' AND PP.category_id = PC.category_id )
ORDER BY 3 DESC
--> all hepsinden büyükleri kapsar. and  and and ile bakýyor
--> any herhangi birinden daha büyüðü kapsar. any'de or or or ile bakýyor
