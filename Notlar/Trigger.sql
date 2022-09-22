--Bir tabloda ekleme, güncelleme ve silme iþlemlerinden biri gerçekleþtiðinde veya gerçekleþmeden önce, 
--ayný tabloda veya baþka bir tabloda belirli iþlemlerin yapýlmasýný istediðimizde, trigger yapýsýný kullanýrýz. 
--Örnek verecek olursak, satýþ tablosunda satýþ iþlemi gerçekleþtiðinde ürünün stok miktarýnýn eksiltilmesi, 
--banka hesabýnda iþlem gerçekleþtikten sonra otomatik olarak email gönderilmesi gibi örnekler verilebilir.

--Tetikleyiciler veritabaný yöneticisi (Db admin) tarafýndan 
--INSERT, UPDATE ve DELETE iþlemlerinden önce veya sonra çalýþtýrýlmak üzere tanýmlanýr.
--After ve instead 0f trigger olmak üzere 2'ye ayrýlýr

--Burada öenmli olan mevzuu eklenen, çýkarýlan veya update edilen bütün bilgiler inserted, deleted tablolarýnda saklanýr.
--Bunlar inserted tablosundan alýndýktan sonra baþka bir tabloda güncelleme maksadýyla kullanýlabilir.

USE SampleRetail
CREATE TRIGGER TRG__
ON product.stock
AFTER INSERT --after delete - after update
AS
BEGIN
	DECLARE @ITEMID AS INT
	DECLARE @AMOUNT AS INT
	DECLARE @STORE AS SMALLINT
	SELECT @ITEMID = product_id, @AMOUNT = quantity, @STORE = store_id  FROM inserted -- or deleted
	IF @STORE = 1
		UPDATE ___ÝLGÝLÝ TABLO___ SET ____ = STOCK + @AMOUNT WHERE @ITEMID = ___ÝLLÝLÝ TABLODAKÝ EÞDEÐERÝ

END