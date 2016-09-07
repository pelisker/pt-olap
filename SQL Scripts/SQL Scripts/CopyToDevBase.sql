--Кпирования данных для песочницы.

use OLAP_DATA_dev

--Копия фактов
TRUNCATE TABLE [t_sales_fact]
INSERT INTO [t_sales_fact](
		[date]
      ,[tovar]
      ,[unit]
      ,[quantity_sale]
      ,[amount_sale]
      ,[quantity_order]
      ,[amount_order])
SELECT top 100 
		[date]
      ,[tovar]
      ,[unit]
      ,[quantity_sale]
      ,[amount_sale]
      ,[quantity_order]
      ,[amount_order] FROM [OLAP_DATA].[dbo].[t_sales_fact]
      ORDER BY tovar
GO

TRUNCATE TABLE [t_stock_fact]
INSERT INTO [t_stock_fact]
SELECT top 100 * FROM [OLAP_DATA].[dbo].[t_stock_fact] ORDER BY tovar
GO

--Копия измерений

TRUNCATE TABLE [t_stores_dim]
INSERT INTO [t_stores_dim]
SELECT * FROM [OLAP_DATA].[dbo].[t_stores_dim]
WHERE ID IN (SELECT store FROM t_stock_fact)

TRUNCATE TABLE [t_units_dim]
INSERT INTO [t_units_dim]
SELECT * FROM [OLAP_DATA].[dbo].[t_units_dim]
WHERE ID IN (SELECT distinct unit FROM t_sales_fact)

TRUNCATE TABLE [t_tovars_dim]
INSERT INTO [t_tovars_dim]
SELECT * FROM [OLAP_DATA].[dbo].[t_tovars_dim]
WHERE ID IN (SELECT tovar FROM t_stock_fact)
OR ID IN (SELECT tovar FROM t_sales_fact)

--Детач базы
USE [master]
GO
ALTER DATABASE [OLAP_DATA_dev] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
EXEC master.dbo.sp_detach_db @dbname = N'OLAP_DATA_dev', @skipchecks = 'false'
GO