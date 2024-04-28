select a.mid,
max(case when (c.email_valid = 1 and a.topic_category=0 and (a.topic_country_or_Region =0 or a.topic_id = '680') and isnull(a.topic_opt,0)=1)  then 1 else 0 end) as us_topic_optin  
into agg.dbo.us_topic_optin
from agg.dbo.email_opt_agg a
left join agg.dbo.email_rollup c
on a.mid = c.mid
group by a.mid