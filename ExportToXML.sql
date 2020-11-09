use Store;

--Export to xml
go
create Procedure ProductsToXml
as
begin
	select ProductId, Title, Description, Price, CategoryId, BrandId from Products
		for xml path('product'), root('products'); --Problem with Prod_Name, need to delete spaces

	--to use xp_cmdshell
	exec master.dbo.sp_configure 'show advanced options', 1
		RECONFIGURE WITH OVERRIDE
	exec master.dbo.sp_configure 'xp_cmdshell', 1
		RECONFIGURE WITH OVERRIDE;

	-- Save XML records to a file
	declare @fileName nvarchar(100)
	declare @sqlStr varchar(1000)
	declare @sqlCmd varchar(1000)

	SET @fileName = 'D:\Dima\3 курс\1 сем\БД\курсач\Store\Export.xml'
	SET @sqlStr = 'use Store; select ProductId, Title, Description, Price, CategoryId, BrandId from Products for xml path(''product''), root(''products'') '
	SET @sqlCmd = 'bcp "' + @sqlStr + '" queryout ' + @fileName + ' -w -T'
	EXEC xp_cmdshell @sqlCmd;
end;