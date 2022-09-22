--Bir tabloda ekleme, g�ncelleme ve silme i�lemlerinden biri ger�ekle�ti�inde veya ger�ekle�meden �nce, 
--ayn� tabloda veya ba�ka bir tabloda belirli i�lemlerin yap�lmas�n� istedi�imizde, trigger yap�s�n� kullan�r�z. 
--�rnek verecek olursak, sat�� tablosunda sat�� i�lemi ger�ekle�ti�inde �r�n�n stok miktar�n�n eksiltilmesi, 
--banka hesab�nda i�lem ger�ekle�tikten sonra otomatik olarak email g�nderilmesi gibi �rnekler verilebilir.

--Tetikleyiciler veritaban� y�neticisi (Db admin) taraf�ndan 
--INSERT, UPDATE ve DELETE i�lemlerinden �nce veya sonra �al��t�r�lmak �zere tan�mlan�r.
--After ve instead 0f trigger olmak �zere 2'ye ayr�l�r

--Burada �enmli olan mevzuu eklenen, ��kar�lan veya update edilen b�t�n bilgiler inserted, deleted tablolar�nda saklan�r.
--Bunlar inserted tablosundan al�nd�ktan sonra ba�ka bir tabloda g�ncelleme maksad�yla kullan�labilir.

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
		UPDATE ___�LG�L� TABLO___ SET ____ = STOCK + @AMOUNT WHERE @ITEMID = ___�LL�L� TABLODAK� E�DE�ER�

END