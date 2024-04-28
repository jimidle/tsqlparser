select a.mid,
max(case when a.country='UNITED STATES' 
	and c.email_valid = 1 
	and b.opt = 1
        and b.category = 0
	then 1 else 0 end) as current_us_origin_optin  
into agg.dbo.current_us_origin_optin
from kc.dbo.email_view a
left join kc.dbo.email_opt_view b
on a.mid = b.mid
left join agg.dbo.email_rollup c
on a.mid = c.mid
group by a.mid