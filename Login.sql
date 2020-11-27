go
create procedure Login
	@Email nvarchar(254),
	@Password nvarchar(16)
as
begin
	declare @Pass nvarchar(16);
	set @Pass = (select Password from Users where Email = @Email);
	if @Password = @Pass
		select 1 as login;
	else 
		select 0 as login;
end;

exec Login 'kazak1629@gmail.com', 'B6C32E74B9224355';