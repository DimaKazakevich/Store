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
		  from openrowset(bulk 'D:\Dima\БД\курсач\Import.xml', single_blob) as T(MY_XML)) as T(MY_XML)
		  CROSS APPLY MY_XML.nodes('products/product') as MY_XML (product);
end;


--import from json to server 
go
create Procedure ProductsFromJSON
as
begin
	declare @JSON varchar(max);
	select @JSON = BulkColumn
		from openrowset(bulk 'D:\Dima\БД\курсач\Import.json', single_blob) json;
	if (ISJSON(@JSON) = 1)
	begin
		declare @Title nvarchar(100);
		declare @Description nvarchar(1000);
		declare @Price decimal(16,2);
		declare @CategoryId int;
		declare @BrandId int;

		declare products_cursor Cursor For
			select * 
			from openjson(@JSON, '$.products')
			with(
				Title nvarchar(100)  '$.Title',
				Description nvarchar(1000) '$.Description',
				Price decimal(16,2)  '$.Price',
				CategoryId int  '$.CategoryId',
				BrandId int  '$.BrandId'
				);
		open products_cursor;

		fetch next from products_cursor Into @Title, @Description, @Price, @CategoryId, @BrandId;
		while @@FETCH_STATUS = 0
		begin
			exec AddProduct  @Title, @Description, @Price, @CategoryId, @BrandId;
			fetch next from products_cursor into @Title, @Description, @Price, @CategoryId, @BrandId;
		end;
		
		close products_cursor;
		deallocate products_cursor;
	end;

	else
	begin
		print 'json is not vallid';
	end;
end;

