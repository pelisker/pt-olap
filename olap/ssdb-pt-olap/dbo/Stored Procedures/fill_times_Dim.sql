CREATE PROCEDURE [dbo].[fill_times_Dim]
AS
BEGIN

	SET LANGUAGE russian
	SET DATEFORMAT mdy
	truncate table t_times_dim

	insert into t_times_dim (id, [date], [dateName], [day],[week],[weekNum],[month],[monthnum],[dayofweek],[dayofweeknum],[year])
	select 
		   id=datepart(YEAR,CONVERT(datetime,День))*10000 + datepart(M,CONVERT(datetime,День))*100 + datepart(D,CONVERT(datetime,День)),
		   [date] = convert(varchar(10),CONVERT(datetime,День),101),
		   [datename]= convert(varchar(8),CONVERT(datetime,День),4),
		   [day] = День,
		   Неделя = 'Неделя ' + cast(datepart(WEEK,CONVERT(datetime,День)) as varchar(10)),
		   Неделя2sort = 
		   cast(datepart(yy,CONVERT(datetime,День)) as varchar(10)) + '_' 
		   + right(100 + datepart(MM,CONVERT(datetime, День)), 2) + '_' 
		   + right(100 + datepart(WEEK,CONVERT(datetime, День)), 2),
		   --+ cast(FORMAT(datepart(MM,CONVERT(datetime,День)) , '00','en-US')as varchar(2)) + '_' 
		   --+ cast(FORMAT(datepart(WEEK,CONVERT(datetime,День)) , '00','en-US')as varchar(2)),
		   case datepart(mm,CONVERT(datetime,День))
			 when 1 then 'Январь'
			 when 2 then 'Февраль'
			 when 3 then 'Март'
			 when 4 then 'Апрель'
			 when 5 then 'Май'
			 when 6 then 'Июнь'
			 when 7 then 'Июль'
			 when 8 then 'Август'
			 when 9 then 'Сентябрь'
			 when 10 then 'Октябрь'
			 when 11 then 'Ноябрь'
			 when 12 then 'Декабрь'
		   end Месяц,
			cast(datepart(yy,CONVERT(datetime,День)) as varchar(4)) 
			+ '-' + right(100 + datepart(MM,CONVERT(datetime, День)), 2) 
			--+ '-' + right(100 + datepart(WEEK,CONVERT(datetime, День)), 2) 
			--+ '-' + right(100 + datepart(DAY,CONVERT(datetime, День)), 2) 
			Месяц2sort,
		   case lower(datename(weekday,CONVERT(datetime,День)))
			 when 'monday' THEN 'понедельник'
			 when 'tuesday' THEN 'вторник'
			 when 'wednesday' THEN 'среда'
			 when 'thursday' THEN 'четверг'
			 when 'friday' THEN 'пятница'
			 when 'saturday' THEN 'суббота'
			 when 'sunday' THEN 'воскресенье'
			 else lower(datename(weekday,CONVERT(datetime,День)))
		   end AS ДеньНедели,
		   /*cast(datepart(yy,CONVERT(datetime,День)) as varchar(10)) + '_' 
		   + right(100 + datepart(MM,CONVERT(datetime, День)), 2) + '_' 
		   + right(100 + datepart(WEEK,CONVERT(datetime, День)), 2)+ '_' 
		   --+ cast(FORMAT(datepart(MM,CONVERT(datetime,День)) , '00','en-US')as varchar(2)) + '_' 		   
		   --+ cast(FORMAT(datepart(WEEK,CONVERT(datetime,День)) , '00','en-US')as varchar(2)) + '_' 
		   +*/ case datename(weekday,CONVERT(datetime,День))
			 when 'понедельник' THEN '01'
			 when 'вторник' THEN '02'
			 when 'среда' THEN '03'
			 when 'четверг' THEN '04'
			 when 'пятница' THEN '05'
			 when 'суббота' THEN '06'
			 when 'воскресенье' THEN '07'
		   end 
		   as ДеньНеделиДляСортировки,
		   datepart(yy,CONVERT(datetime,День)) as Год

	  from (-- дни
			select 40177 + (ROW_NUMBER() over(ORDER BY v1.number)-1) as День from master.dbo.spt_values v1 full join (SELECT code=1 UNION SELECT code=2 UNION SELECT code=3) v2 on 1=1
		   ) as t1
	  where CONVERT(datetime,День) >= '20140101' and
			CONVERT(datetime,День) <= getdate()+100
END