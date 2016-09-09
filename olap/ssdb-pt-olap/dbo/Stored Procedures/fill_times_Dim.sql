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