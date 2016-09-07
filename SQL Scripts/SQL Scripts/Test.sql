select * from t_sales_fact
where unit not in (select ID from t_units_dim)

select * from t_stock_fact
where store not in (select ID from t_stores_dim)