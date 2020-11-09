use Store;

--AddProduct
go
create procedure AddProduct
		@Title nvarchar(50),
		@Description nvarchar(50),
		@Price decimal(16,2), 
		@CategoryId int,
		@BrandId int
as
begin
	if not exists (select CategoryId from Categories where CategoryId = @CategoryId) throw 50001 , 'Invalid @CategoryId parameter value', 1;
	if not exists (select BrandId from Brands where BrandId = @BrandId) throw 50001 , 'Invalid @BrandId parameter value', 1;
    begin
		insert into Products(Title, Description, Price, CategoryId, BrandId)
		values(@Title, @Description, @Price, (select CategoryId from Categories where CategoryId = @CategoryId),
											 (select BrandId from Brands where BrandId = @BrandId))
   end
end;


--DeleteProductById
go
create procedure DeleteProductById
		@ProductId int
as
begin
	delete from Products where ProductId = @ProductId;
end;


--UpdateProduct
go
create procedure UpdateProduct
		@ProductId int,
		@Title nvarchar(50),
		@Description nvarchar(50),
		@Price decimal(16,2), 
		@CategoryId int,
		@BrandId int
as
begin
	if not exists  (select CategoryId from Categories where CategoryId = @CategoryId) throw 50001 , 'Invalid @CategoryId parameter value', 1;
	if not exists (select BrandId from Brands where BrandId = @BrandId) throw 50001 , 'Invalid @BrandId parameter value', 1;
    begin
		update Products
		set Title = @Title,
			Description = @Description,
			Price = @Price,
			CategoryId = @CategoryId,
			BrandId = @BrandId
		where ProductId = @ProductId;
   end
end;


--AddBrand
go
create procedure AddBrand @Brand nvarchar(50)
as
begin
	if exists (select Brand from Brands where Brand = @Brand) throw 50001 , 'Such a brand already exists', 1;
    begin
		insert into Brands values(@Brand)
   end
end;


--DeleteBrandByName
go
create procedure DeleteBrandByName @Brand nvarchar(50)
as
begin
	delete from Brands where Brand = @Brand;
end;


--UpdateBrand
go
create procedure UpdateBrand
		@BrandId int,
		@Brand nvarchar(50)
as
begin
    begin
		update Brands
		set Brand = @Brand where BrandId = @BrandId;
   end
end;


--AddCategory
go
create procedure AddCategory @Category nvarchar(50)
as
begin
	if exists (select Category from Categories where Category = @Category) throw 50001 , 'Such a category already exists', 1;
    begin
		insert into Categories values(@Category)
   end
end;


--DeleteCategoryByName
go
create procedure DeleteCategoryByName @Category nvarchar(50)
as
begin
	delete from Categories where Category = @Category;
end;


--UpdateCateogry
go
create procedure UpdateCateogry
		@CategoryId int,
		@Category nvarchar(50)
as
begin
    begin
		update Categories set Category = @Category where CategoryId = @CategoryId;
   end
end;