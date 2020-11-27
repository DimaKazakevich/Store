go
create procedure CreateTitle
	@Size int,
	@Name nvarchar(1000) output
as
begin
	set @Name = (
	select c1 as [text()]
	from (select top (@Size) c1
		  from
			(
			values
				('a'), ('b'), ('c'), ('d'), ('e'), ('f'), ('g'), (' '), ('h'), ('i'), ('j'),
				('k'), ('l'), ('m'), ('n'), ('o'), ('p'), ('q'), (' '), ('r'), ('s'), ('t'),
				('u'), ('v'), ('w'), ('x'), ('y'), ('z'), (' ')
			) as T1(c1)
		    order by abs(checksum(newid()))
		 ) as T2
	for xml path('')
	);
end;

--drop procedure CreateNameAndDescription;
drop procedure CreatePrice;

go
create procedure CreateRandomNumber @Number char(2) output
as
begin
	set @Number = (
	select
		c1 as [text()]
	from
		(
		select top (2) c1
		from (values ('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9'),
		('0'), ('1'), ('2'), ('3'), ('4'), ('5'), ('6'), ('7'), ('8'), ('9')) AS T1(c1)
			order by abs(checksum(newid()))
		) as T2
	for xml path('')
	);
end;
 

go
create procedure RandomProducts @ProductsCount int
as
begin
declare @Title nvarchar(100),
		@Description nvarchar(1000),
		@Price char(2),
		@CategoryId int,
		@SizeId int,
		@number INT;

set @number = 1;

while @number <= @ProductsCount
begin
	exec CreateTitle 27, @Title output;
	set @Title = (select replace(@Title,'&#x20;',' '));

	declare @max_length int = 150;
	declare @s nvarchar(max) = '';
	with chars(n, c) AS (
	select 1, 'a' union all 
	select 2, 'b' union all 
	select 3, 'c' union all
	select 4, 'd' union all
	select 5, 'e' union all
	select 6, 'f' union all
	select 8, 'g' union all
	select 9, 'h' union all
	select 10, ' ' union all
	select 11, 'i' union all
	select 12, 'j' union all
	select 13, 'k' union all
	select 14, 'l' union all
	select 15, 'm' union all
	select 16, 'n' union all
	select 17, 'o' union all
	select 18, 'p' union all
	select 19, ' ' union all
	select 20, 'q' union all
	select 21, 'r' union all
	select 22, 's' union all
	select 23, 't' union all
	select 24, 'u' union all
	select 25, ' ' union all
	select 26, 'v' union all
	select 27, 'w' union all
	select 28, 'x' union all
	select 29, 'y' union all
	select 30, 'z' union all
	select 31, ' '

	-- add more characters here to include them in a random string
	),
	lines as (
	select 1 as n union all
	select 2 union all
	select 3 union all
	select 4 union all
	select 5 union all
	select 6 union all
	select 7 union all
	select 8 union all
	select 9 union all
	select 10
	),
	all_lines as (
	select row_number() over(order by l1.n) as n,
			convert(int, rand(abs(convert(int, convert(varbinary, newid())))) * (select count(n) from chars)) + 1 as char_n
	from lines l1
		CROSS JOIN lines l2 -- 100
		CROSS JOIN lines l3 -- 1000
		-- add more CROSS JOINs here to get longer string
	),
	only_lines as (
	select * from all_lines
	where n <= @max_length
	)
	select @s = @s + c 
	from only_lines l INNER JOIN chars c on l.char_n = c.n
	set @Description = (select @s);

	set @SizeId = (select top 1 SizeId from Sizes order by newid());

	set @CategoryId = (select top 1 CategoryId from Categories order by newid());

	exec CreateRandomNumber @Price output;
	set @Price = cast(@Price as int);

	exec AddProduct @Title, @Description, @Price, @CategoryId, @SizeId; 
	set @number = @number + 1;
end;
end;

drop procedure RandomProducts;
exec RandomProducts;

select count(*) from Products;

select * from Products where ProductId between 31444 and 31480;


go
create procedure RandomSizeDetails @SizeDetailsCount int
as
begin
	declare @SizeId int,
			@number int,
			@CountSizesPerProduct int,
			@Count int;

	set @number = 1;
	set @CountSizesPerProduct = 1;

	while @number <= @SizeDetailsCount
	begin
		while @CountSizesPerProduct <= 5
		begin
			set @SizeId = (select top 1 SizeId from Sizes order by newid());

			while exists (select SizeId, ProductId from SizeDetails where SizeId = @SizeId and ProductId = @number)
			begin
				set @SizeId = (select top 1 SizeId from Sizes order by newid());
			end;
				
			exec CreateRandomNumber @Count output;
			set @Count = cast(@Count as int);
			exec AddSizeDetail @number, @SizeId, @Count;
			set @CountSizesPerProduct = @CountSizesPerProduct + 1;
		end;

	set @number = @number + 1;
	set @CountSizesPerProduct = 1;
	end;
end;

go
drop table SizeDetails;

exec RandomSizeDetails;

drop procedure RandomSizeDetails;

select count(*) from Products;

------------
exec RandomProducts 100000; --2 мин 14сек
exec RandomSizeDetails 100000; --2 мин 23 сек



