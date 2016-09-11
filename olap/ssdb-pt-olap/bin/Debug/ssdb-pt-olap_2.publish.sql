/*
Скрипт развертывания для OLAP_DATA_dev

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "OLAP_DATA_dev"
:setvar DefaultFilePrefix "OLAP_DATA_dev"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Выполняется создание $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
USE [$(DatabaseName)];


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Выполняется создание [dbo].[t_sales_fact]...';


GO
CREATE TABLE [dbo].[t_sales_fact] (
    [ID]             INT              IDENTITY (1, 1) NOT NULL,
    [date]           INT              NOT NULL,
    [tovar]          UNIQUEIDENTIFIER NOT NULL,
    [unit]           UNIQUEIDENTIFIER NOT NULL,
    [quantity_sale]  INT              NULL,
    [amount_sale]    MONEY            NULL,
    [quantity_order] INT              NULL,
    [amount_order]   MONEY            NULL,
    CONSTRAINT [PK_t_trans] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[t_stock_fact]...';


GO
CREATE TABLE [dbo].[t_stock_fact] (
    [date]     INT              NULL,
    [tovar]    UNIQUEIDENTIFIER NOT NULL,
    [store]    UNIQUEIDENTIFIER NOT NULL,
    [quantity] INT              NOT NULL
);


GO
PRINT N'Выполняется создание [dbo].[t_stores_dim]...';


GO
CREATE TABLE [dbo].[t_stores_dim] (
    [ID]   UNIQUEIDENTIFIER NOT NULL,
    [name] VARCHAR (500)    NOT NULL
);


GO
PRINT N'Выполняется создание [dbo].[t_times_dim]...';


GO
CREATE TABLE [dbo].[t_times_dim] (
    [id]           INT          NOT NULL,
    [date]         DATE         NOT NULL,
    [day]          INT          NULL,
    [week]         INT          NULL,
    [month]        VARCHAR (50) NULL,
    [monthNum]     INT          NULL,
    [DayOfWeek]    VARCHAR (50) NULL,
    [DayOfWeekNum] INT          NULL,
    [year]         INT          NULL,
    [dateName]     VARCHAR (10) NULL,
    CONSTRAINT [PK_times_dim] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
PRINT N'Выполняется создание [dbo].[t_tovars_dim]...';


GO
CREATE TABLE [dbo].[t_tovars_dim] (
    [id]    UNIQUEIDENTIFIER NOT NULL,
    [name]  VARCHAR (500)    NOT NULL,
    [brand] VARCHAR (500)    NOT NULL,
    [cat_1] VARCHAR (500)    NULL,
    [cat_2] VARCHAR (500)    NULL,
    [cat_3] VARCHAR (500)    NULL,
    [cat_4] VARCHAR (500)    NULL
);


GO
PRINT N'Выполняется создание [dbo].[t_units_dim]...';


GO
CREATE TABLE [dbo].[t_units_dim] (
    [ID]   UNIQUEIDENTIFIER NOT NULL,
    [Name] VARCHAR (500)    NOT NULL
);


GO
PRINT N'Выполняется создание [dbo].[fill_times_Dim]...';


GO
CREATE PROCEDURE [dbo].[fill_times_Dim]
AS
BEGIN

	truncate table t_times_dim

	insert into t_times_dim (id, [date], [dateName], [day],[week],[month],[monthnum],[dayofweek],[dayofweeknum],[year])
	select 
		   id=datepart(YEAR,CONVERT(datetime,День))*10000 + datepart(M,CONVERT(datetime,День))*100 + datepart(D,CONVERT(datetime,День)),
		   [date] = convert(varchar(10),CONVERT(datetime,День),101),
		   [datename]= convert(varchar(8),CONVERT(datetime,День),4),
		   [day] = День,
		   Неделя = datepart(WEEK,CONVERT(datetime,День)),
		   case datepart(mm,CONVERT(datetime,День))
			 when 1 then 'январь'
			 when 2 then 'февраль'
			 when 3 then 'март'
			 when 4 then 'апрель'
			 when 5 then 'май'
			 when 6 then 'июнь'
			 when 7 then 'июль'
			 when 8 then 'август'
			 when 9 then 'сентябрь'
			 when 10 then 'октябрь'
			 when 11 then 'ноябрь'
			 when 12 then 'декабрь'
		   end Месяц,
		   МесяцДляСортировки = datepart(mm,CONVERT(datetime,День)),
		   case lower(datename(weekday,CONVERT(datetime,День)))
			 when 'monday' THEN 'понедельник'
			 when 'tuesday' THEN 'вторник'
			 when 'wednesday' THEN 'среда'
			 when 'thursday' THEN 'четверг'
			 when 'friday' THEN 'пятница'
			 when 'saturday' THEN 'суббота'
			 when 'sunday' THEN 'воскресенье'
		   end AS ДеньНедели,
		   case lower(datename(weekday,CONVERT(datetime,День)))
			 when 'monday' THEN 1
			 when 'tuesday' THEN 2
			 when 'wednesday' THEN 3
			 when 'thursday' THEN 4
			 when 'friday' THEN 5
			 when 'saturday' THEN 6
			 when 'sunday' THEN 7
		   end as ДеньНеделиДляСортировки,
		   datepart(yy,CONVERT(datetime,День)) as Год

	  from (-- дни
			select 40177 + (ROW_NUMBER() over(ORDER BY v1.number)-1) as День from master.dbo.spt_values v1 full join (SELECT code=1 UNION SELECT code=2 UNION SELECT code=3) v2 on 1=1
		   ) as t1
	  where CONVERT(datetime,День) >= '20140101' and
			CONVERT(datetime,День) <= getdate()+100       
END
GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Обновление завершено.';


GO
