select  a.mid,1 as retail_catalog_buyer
into agg.dbo.retail_catalog_buyer
from campaign.dbo.communication a
join agg.dbo.orders_agg b on a.mid=b.mid_buyer
join campaign.dbo.lkp_keycode c
on a.keycode = c.keycode 
join kc..lkp_store d on d.store_id=b.store_id
where DATEDIFF( dd ,a.inhome_date , b.order_date ) between 0 and 30 
and d.store_type_id in ('NT','WMS')
and b.qty_ship > 0
group by a.mid
