create database Store;
use Store;

create table Categories
(
	CategoryId int identity(1,1) constraint Categories_PK primary key,
	Category nvarchar(50)
);
drop table Categories;
create table Brands
(
	BrandId int identity(1,1) constraint Brands_PK primary key,
	Brand nvarchar(50)
);
drop table Brands;
create table Sizes
(
	SizeId int identity(1,1) constraint Sizes_PK primary key,
	Size nvarchar(50)
);

create table Products
(
	ProductId int identity(1,1) constraint Prodcuts_PK primary key,
	Title nvarchar(100),
	Description nvarchar(1000),
	Price decimal(16,2),
	CategoryId int constraint Products_Categories_FK foreign key references Categories(CategoryId),
	BrandId int constraint Products_Brands_FK foreign key references Brands(BrandId)
);
drop table Products;
create table SizeDetails
(
	ProductId int constraint SizeDetails_Products_FK foreign key references Products(ProductId),
	SizeId int constraint SizeDetails_Sizes_FK foreign key references Sizes(SizeId),
	Count int,
	constraint SizeDetails_PK primary key(ProductId, SizeId)
);
drop table SizeDetails;
drop table Sizes;
create table Users
(
	UserId int identity(1,1) constraint Users_PK primary key,
	Email nvarchar(254),
	Password nvarchar(max),
	isAdmin bit default 0
);

create table Orders
(
	OrderId int identity(1,1) constraint Orders_PK primary key,
	UserId int constraint OrderLines_Users_FK foreign key references Users(Userid),
	DateTime datetime,
	TotalCost decimal(16,2) default 0
);

create table OrderLines
(
	OrderLineId int identity(1,1) constraint OrderLines_PK primary key,
	OrderId int constraint OrderLines_Orders_FK foreign key references Orders(OrderId),
	ProductId int constraint OrderLines_Products_FK foreign key references Products(ProductId),
	Quantity int,
	Size nvarchar(50)
);
drop table OrderLines;