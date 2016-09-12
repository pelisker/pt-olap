  
  update [OLAP_DATA].[dbo].[t_tovars_dim]
  set cat_2=cat_1 WHERE cat_2=''
  
  update [OLAP_DATA].[dbo].[t_tovars_dim]
  set cat_3=cat_2 WHERE cat_3=''
  
  update [OLAP_DATA].[dbo].[t_tovars_dim]
  set cat_4=cat_3 WHERE cat_4=''
  
  
  update [OLAP_DATA].[dbo].[t_tovars_dim]
  set IDcat_2=IDcat_1 WHERE IDcat_2=''
  
  update [OLAP_DATA].[dbo].[t_tovars_dim]
  set IDcat_3=IDcat_2 WHERE IDcat_3=''
  
  update [OLAP_DATA].[dbo].[t_tovars_dim]
  set IDcat_4=IDcat_3 WHERE IDcat_4=''  