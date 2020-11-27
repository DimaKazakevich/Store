go
create view ProductsView
as
select Products.ProductId, Products.Title, Description, Price, Category, Brand, Sizes.SizesString
from Products inner join Categories
on Products.CategoryId = Categories.CategoryId
inner join Brands
on Products.BrandId = Brands.BrandId
cross apply dbo.getAllSizesByProductId(Products.ProductId) as Sizes;

select * from ProductsView;

drop view ProductsView;

drop function getAllSizesByProductId;


go
create function getAllSizesByProductId(@ProductId int)
returns @rtnTable table (SizesString nvarchar(max))
as
begin
  declare  @Size nvarchar(max),
		   @SizesString nvarchar(max) = '';

	declare sizes_cursor cursor
	for select Size
		from Products inner join SizeDetails
		on Products.ProductId = SizeDetails.ProductId
		inner join Sizes 
		on SizeDetails.SizeId = Sizes.SizeId
		where Products.ProductId = @ProductId;

	open sizes_cursor;

	fetch sizes_cursor into @Size;

	while @@FETCH_STATUS = 0
	begin
		set @SizesString = rtrim(@Size) + ', ' + @SizesString;
		fetch sizes_cursor into @Size;
	end;

	--set @SizesString = substring(@SizesString, 1, (len(@SizesString) - 1)) --remove the last sybmol(comma) in @SizesString
	insert into @rtnTable values(@SizesString);
	
	close sizes_cursor;
	deallocate sizes_cursor;
	return
end