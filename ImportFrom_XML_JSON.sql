use Store;

--import from xml to server 
go
create procedure ProductsFromXml
as
begin
	insert into Products(Title, Description, Price, CategoryId, BrandId)
	select
	   MY_XML.product.query('Title').value('.', 'NVARCHAR(100)'),
	   MY_XML.product.query('Description').value('.', 'NVARCHAR(1000)'),
	   MY_XML.product.query('Price').value('.', 'DECIMAL(16,2)'),
	   MY_XML.product.query('CategoryId').value('.', 'INT'),
	   MY_XML.product.query('BrandId').value('.', 'INT')

	from (select cast(MY_XML as xml)
		  from openrowset(bulk 'D:\Dima\3 курс\1 сем\БД\курсач\Store\Import.xml', single_blob) as T(MY_XML)) as T(MY_XML)
		  CROSS APPLY MY_XML.nodes('products/product') as MY_XML (product);
end;

go
create procedure ProductsFromJSON
as
begin
	declare @JSON varchar(max)
	select @JSON=BulkColumn
	from openrowset (BULK 'D:\Dima\3 курс\1 сем\БД\курсач\Store\Import.json', single_blob) import
	select * into  Product
	from openjson (@JSON)
	with (Title nvarchar(100),
			Description nvarchar(1000),
			Price decimal(16,2),
			CategoryId int,
			BrandId int)
end;
