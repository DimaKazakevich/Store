use Store;

--Export to xml
go
create procedure ProductsToXml
as
begin
	select ProductId, Title, Description, Price, CategoryId, BrandId 
	from Products
		for xml path('product'), root('products');

	exec master.dbo.sp_configure 'show advanced options', 1
		reconfigure with override
	exec master.dbo.sp_configure 'xp_cmdshell', 1
		reconfigure with override;

	declare @cmd nvarchar(255);
	select @cmd = '
    bcp "use Store; select ProductId, Title, Description, Price, CategoryId, BrandId from Products for xml path(''product''), root(''products'')" ' +
    'queryout "D:\Dima\БД\курсач\Export.xml" -S .\SQLEXPRESS -T -w -r -t';
exec xp_cmdshell @cmd;
end; 


--Export to json
go
create procedure ExportToJson
as begin
select ProductId, Title, Description, Price, CategoryId, BrandId 
from Products
	for json path, root('products');

	exec master.dbo.sp_configure 'show advanced options', 1
		reconfigure with override
	exec master.dbo.sp_configure 'xp_cmdshell', 1
		reconfigure with override;

	declare @cmd nvarchar(255);
	select @cmd = '
    bcp "use Store; select ProductId, Title, Description, Price, CategoryId, BrandId from Products for json path, root(''products'')" ' +
    'queryout "D:\Dima\БД\курсач\Export.json" -S .\SQLEXPRESS -T -w -r -t';
exec xp_cmdshell @cmd;
end;
 

