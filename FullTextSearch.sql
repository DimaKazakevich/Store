use Store;  
go  
create fulltext catalog ProductsCatalog;  

create UNIQUE index unique_product ON Products(ProductId); 

create fulltext index on Production.Document  
(  
    Title language 2057,  --Full-text index column name (2057 is the LCID for British English)  
	Description language 2057
)  
key index unique_product on ProductsCatalog --Unique index  
with change_tracking auto            --Population type;  
go  

   go
   SELECT Table1.ProductId AS [Id],
          RowRank.Rank AS [RANK],
          Table1.Title AS [TextData]
   FROM Products AS Table1
   INNER JOIN CONTAINSTABLE(Products, Table1.Title, 'dk') AS RowRank
   ON Table1.ProductId=RowRank.[KEY]
   ORDER BY RowRank.RANK DESC;

   SELECT FT_TBL.Name, KEY_TBL.RANK  
    FROM Products AS FT_TBL   
        INNER JOIN CONTAINSTABLE(Products.Title, Name,   
        'dk' ) AS KEY_TBL  
            ON FT_TBL.ProductId = KEY_TBL.[KEY]  
ORDER BY KEY_TBL.RANK DESC;  

select * from Products
where freetext(Description, 'dk');

select * from Products
where contains(Description, 'dk');

select * from freetexttable(Products, *, N'dk');

SELECT Description  
    ,KEY_TBL.RANK  
FROM Products AS FT_TBL   
    INNER JOIN FREETEXTTABLE(Products,  
    *,   
    'dk') AS KEY_TBL  
ON FT_TBL.ProductId = KEY_TBL.[KEY]  
ORDER BY RANK DESC;  
GO  

-----l
SELECT Description  
FROM Products
WHERE FREETEXT (Description, 'dk');
GO 