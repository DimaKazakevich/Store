--FilterByCategory
go
create procedure FilterByCategory
		@Category nvarchar(50)
as
begin
	if not exists (select Category from Categories where Category = @Category) throw 50001 , 'Invalid @Category parameter value', 1;
    begin
		select ProductId, Title, Description, Price, Category, Brand, Sizes.SizesString as Sizes
		from Products inner join Categories
		on Products.CategoryId = Categories.CategoryId
		inner join Brands
		on Products.BrandId = Brands.BrandId
		cross apply dbo.getAllSizesByProductId(Products.ProductId) as Sizes
		where Categories.CategoryId = (select CategoryId from Categories where Category = @Category);
   end
end;

drop procedure FilterByCategory;
exec FilterByCategory 'Gloves';


--FilterByBrand
drop procedure FilterByBrand;
go
create procedure FilterByBrand
		@Brand nvarchar(50)
as
begin
	if not exists (select Brand from Brands where Brand = @Brand) throw 50001 , 'Invalid @Brand parameter value', 1;
    begin
		select ProductId, Title, Description, Price, Category, Brand, Sizes.SizesString as Sizes
		from Products inner join Categories
		on Products.CategoryId = Categories.CategoryId
		inner join Brands
		on Products.BrandId = Brands.BrandId
		cross apply dbo.getAllSizesByProductId(Products.ProductId) as Sizes
		where Brands.BrandId = (select BrandId from Brands where Brand = @Brand);
   end
end;

drop procedure FilterByBrand;
exec FilterByBrand 'New balance';


--FilterByPrice
go
create procedure FilterByPrice
		@MinPrice decimal(16,2),
		@MaxPrice decimal(16,2)
as
begin
	select * from ProductsView where Price between @MinPrice and @MaxPrice;
end;

drop procedure FilterByPrice;
exec FilterByPrice 72, 91;

