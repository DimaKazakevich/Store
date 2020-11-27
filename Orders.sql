go
create procedure CreateOrder @UserId int
as
begin
	if not exists (select UserId from Users where UserId = @UserId) throw 50001 , '@UserId parameter value does not exist', 1;

	insert into Orders(UserId, DateTime) values (@UserId, getdate());
end;

exec Register 'kazak1629@gmail.com', 'kazak1629';
exec CreateOrder 2;
exec CreateOrderLine 1, 2939, 2, 'M';

go
create procedure CreateOrderLine
	@OrderId int,
	@ProductId int,
	@Quantity int,
	@Size nvarchar(50)
as
begin
	if not exists (select Size from Sizes where Size = @Size) throw 50001 , '@Size parameter value does not exist', 1;
	if not exists (select ProductId from Products where ProductId = @ProductId) throw 50001 , '@ProductId parameter value does not exist', 1;
	if not exists (select OrderId from Orders where OrderId = @OrderId) throw 50001 , '@OrderId parameter value does not exist', 1;

	insert into OrderLines(OrderId ,ProductId, Quantity, Size) values (@OrderId, @ProductId, @Quantity, @Size);
end;


--drop trigger Products_INSERT_UPDATE;
go
create trigger Products_INSERT_UPDATE
on OrderLines
after insert
as
declare @Price decimal(16,2);
set @Price = (select Price from Products where ProductId = (select ProductId from inserted));
update Orders
set TotalCost = TotalCost + @Price
where OrderId = (select OrderId from inserted);