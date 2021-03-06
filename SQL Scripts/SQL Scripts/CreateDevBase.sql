USE [master]
GO

/****** Object:  Database [OLAP_DATA_dev]    Script Date: 09/06/2016 17:06:20 ******/
CREATE DATABASE [OLAP_DATA_dev] ON  PRIMARY 
( NAME = N'integration', FILENAME = N'C:\Projects\pt-olap\Database\OLAP_DATA_dev.mdf' , SIZE = 4032KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'integration_log', FILENAME = N'C:\Projects\pt-olap\Database\OLAP_DATA_dev_log.ldf' , SIZE = 512KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [OLAP_DATA_dev] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [OLAP_DATA_dev].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [OLAP_DATA_dev] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET ARITHABORT OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [OLAP_DATA_dev] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [OLAP_DATA_dev] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [OLAP_DATA_dev] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET  DISABLE_BROKER 
GO

ALTER DATABASE [OLAP_DATA_dev] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [OLAP_DATA_dev] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [OLAP_DATA_dev] SET  READ_WRITE 
GO

ALTER DATABASE [OLAP_DATA_dev] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [OLAP_DATA_dev] SET  MULTI_USER 
GO

ALTER DATABASE [OLAP_DATA_dev] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [OLAP_DATA_dev] SET DB_CHAINING OFF 
GO


USE [OLAP_DATA_dev]
GO
/****** Object:  Table [dbo].[t_units_dim]    Script Date: 09/06/2016 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_units_dim](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_tovars_dim]    Script Date: 09/06/2016 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_tovars_dim](
	[id] [uniqueidentifier] NOT NULL,
	[name] [varchar](500) NOT NULL,
	[brand] [varchar](500) NOT NULL,
	[cat_1] [varchar](500) NULL,
	[cat_2] [varchar](500) NULL,
	[cat_3] [varchar](500) NULL,
	[cat_4] [varchar](500) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_times_dim]    Script Date: 09/06/2016 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_times_dim](
	[id] [int] NOT NULL,
	[date] [date] NOT NULL,
	[day] [int] NULL,
	[week] [int] NULL,
	[month] [varchar](50) NULL,
	[monthNum] [int] NULL,
	[DayOfWeek] [varchar](50) NULL,
	[DayOfWeekNum] [int] NULL,
	[year] [int] NULL,
	[dateName] [varchar](10) NULL,
 CONSTRAINT [PK_times_dim] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_stores_dim]    Script Date: 09/06/2016 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_stores_dim](
	[ID] [uniqueidentifier] NOT NULL,
	[name] [varchar](500) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_stock_fact]    Script Date: 09/06/2016 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_stock_fact](
	[date] [int] NULL,
	[tovar] [uniqueidentifier] NOT NULL,
	[store] [uniqueidentifier] NOT NULL,
	[quantity] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_sales_fact]    Script Date: 09/06/2016 17:05:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_sales_fact](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[date] [int] NOT NULL,
	[tovar] [uniqueidentifier] NOT NULL,
	[unit] [uniqueidentifier] NOT NULL,
	[quantity_sale] [int] NULL,
	[amount_sale] [money] NULL,
	[quantity_order] [int] NULL,
	[amount_order] [money] NULL,
 CONSTRAINT [PK_t_trans] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[fill_times_Dim]    Script Date: 09/06/2016 17:05:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
