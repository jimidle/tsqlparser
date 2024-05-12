select mid_buyer as mid,
min(case when qty_ship > 0 then order_date else NULL end) as first_purchase,
max(case when qty_ship > 0 then order_date else NULL end) as last_purchase,
min(order_date) as first_order,
max(order_date) as last_order,
max(case when qty_ship > 0 and keycode_source is not null then 1 else 0 end) as catalog_buyer,
max(case when qty_ship > 0 then 1 else 0 end) as buyer,

max(case when qty_ship > 0 and order_type = 'W' and channel is null then 1 else 0 end) as web_buyer,

max(case when qty_ship > 0 and order_type = 'W' then 1 else 0 end) as online_buyer,

max(case when qty_ship > 0 and order_type = 'R' then 1 else 0 end) as retail_buyer,
max(case when qty_ship > 0 and channel = 'ACMS' then 1 else 0 end) as cs_buyer,
max(case when qty_ship > 0 and nike_id = 1 then 1 else 0 end) as nike_id_buyer,
max(case when qty_ship > 0 and b.gender = 'MENS' then 1 else 0 end) as mens_buyer,
max(case when qty_ship > 0 and b.gender = 'WOMENS' then 1 else 0 end) as womens_buyer,
max(case when qty_ship > 0 and a.clearance_store_id is not null then 1 else 0 end) as clearance_store_buyer,
case when max(qty_return) > 0 and max(isnull(qty_ship, 0)) = 0 then 1 else 0 end as returner,

max(case when qty_ship > 0  and clientele_order = 1 then 1 else 0 end) as clientele_buyer,

max(case when qty_ship > 0  and keycode_attributed_retail is not null then 1 else 0 end) as dm_buyer
into agg.dbo.orders_rollup
from agg.dbo.orders_agg a (nolock) left join kc.dbo.lkp_custom_class b
on a.custom_class_id = b.custom_class_id
group by mid_buyer