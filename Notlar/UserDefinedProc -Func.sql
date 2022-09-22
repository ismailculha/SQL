----

--Fonksiyonlar bir deðiþken alýp bir deðiþken döndürmek zorundayken prosedürde böyle bir zorunluluk yoktur.

CREATE PROCEDURE sampleproc1
AS
	SELECT 'HELLO WORLD'
GO;

EXEC sampleproc1;

DROP PROCEDURE sampleproc1; -- ALTER PROCEDURE


CREATE OR ALTER PROCEDURE hello
as
SELECT 'Hello MSSQL'
GO;

EXEC hello;

CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);
INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )

select	*
from	ORDER_TBL

CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);

SET NOCOUNT ON--KAÇ SATIRIN EKLENDÝÐÝ BÝLGÝSÝNÝN ÖNÜNE GEÇÝYOR
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

CREATE PROCEDURE sp_sum_order
AS
BEGIN

	SELECT COUNT(*) AS TOTAL_ORDER 
	FROM ORDER_TBL 

END;

EXEC sp_sum_order

CREATE PROCEDURE sp_wantedday_order 
(@DAY DATE)
AS
BEGIN

	SELECT COUNT(*) AS TOTAL_ORDER 
	FROM ORDER_TBL
	WHERE ORDER_DATE = @DAY

END;

EXECUTE sp_wantedday_order '2022-06-22';
DECLARE @DAY1 DATE
SELECT @DAY1 = ORDER_DATE FROM ORDER_TBL WHERE ORDER_ID = 2
EXECUTE sp_wantedday_order @DAY1


DECLARE
	@p1 INT,
	@p2 INT,
	@SUM INT
SET @p1 = 5
SELECT *
from ORDER_TBL
where ORDER_ID = @p1;

DECLARE
	@order_id INT,
	@customer_name nvarchar(100)
SET @order_id = 5
SELECT @customer_name = customer_name
from ORDER_TBL
where ORDER_ID = @order_id
select @customer_name


-----FONKSÝYONLAR

CREATE FUNCTION fnc_uppertext
(
	@inputtext varchar (MAX)
)
RETURNS VARCHAR (MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END;

SELECT dbo.fnc_uppertext('hello world');


-- Müþteri adýný parametre olarak alýp o müþterinin alýþveriþlerini döndüren bir fonksiyon yazýnýz.
create function fnc_getordersbycustomer
(
@CUSTOMER_NAME NVARCHAR(100)
)
RETURNS TABLE
AS
	return
		select	*
		from	ORDER_TBL
		where	CUSTOMER_NAME = @CUSTOMER_NAME
;

SELECT	*
FROM	dbo.fnc_getordersbycustomer('Owen')


-- IF / ELSE
-- Bir fonksiyon yaziniz. Bu fonksiyon aldýðý rakamsal deðeri çift ise Çift, tek ise Tek döndürsün. Eðer 0 ise Sýfýr döndürsün.

DECLARE
	@input int,
	@modulus int
SET @input = 5
SELECT @modulus = @input % 2
IF @input = 0
	BEGIN
	 print 'Sýfýr'
	END
ELSE IF @modulus = 0
	BEGIN
	 print 'Çift'
	END
ELSE print 'Tek'


create FUNCTION dbo.fnc_tekcift
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE
		-- @input int,
		@modulus int,
		@return nvarchar(max)
	-- SET @input = 100
	SELECT @modulus = @input % 2
	IF @input = 0
		BEGIN
		 set @return = 'Sýfýr'
		END
	ELSE IF @modulus = 0
		BEGIN
		 set @return = 'Çift'
		END
	ELSE set @return = 'Tek'
	return @return
	
END
;

select dbo.fnc_tekcift(100) A, dbo.fnc_tekcift(9) B, dbo.fnc_tekcift(0) C

DECLARE
	@counter int,
	@total int
set @counter = 1
set @total = 50
while @counter < @total
	begin
		PRINT @counter
		set @counter = @counter + 1
	end
;