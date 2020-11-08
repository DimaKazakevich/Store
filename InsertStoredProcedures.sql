use Store;

go
create procedure AddProduct
		@Tite nvarchar(50),
		@Description nvarchar(50),
		@Price nvarchar(30), 
		@CategoryId numeric(6,2),
		@SizeId numeric(6,2),
		@BrandId int
as
begin
	declare @Category int, @Size int, @Brand int;
	if not exists  (select CategoryId from Categories where CategoryId = @CategoryId) throw 50001 , 'Invalid @CategoryId parameter value', 1;
	if not exists (select SizeId from Sizes where SizeId = @SizeId) throw 50001 , 'Invalid @SizeId parameter value', 1;
	if not exists (select BrandId from Brands where BrandId = @BrandId) throw 50001 , 'Invalid @BrandId parameter value', 1;
    begin
	Insert into Products(Title, Description, Price, CategoryId, SizeId, BrandId)
	values(@Tite, @Description, @Price, @Category, 
										(select SizeId from Sizes where SizeId = @SizeId), 
										(select BrandId from Brands where BrandId = @BrandId))
   end
end;