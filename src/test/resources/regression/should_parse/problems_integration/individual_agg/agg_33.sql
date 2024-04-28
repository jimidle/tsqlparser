select a.mid,
max(case when d.mid is not null --online contactable
and a.email_optin=1----category=0,2 or 3 and opt_out date is null or latest opt_in date>most recent opt_out date
-- updated by pyoung on 2/21/07 to add the additional requirements and remove the commented ones.
--and (c.country_or_region= 0 or c.topic_id= '680' or e.country='United States')
and ( 
	(c.topic_opt = 1 and c.topic_country_or_region= 0 and c.topic_id not in ('999')) OR 
	(c.topic_opt = 1 and c.topic_country_or_region=4 and isnull(e.preferred_country,'United States')in ('US','United States')) OR
	( (c.topic_opt = 1 and c.topic_country_or_region in (1,2,3) or c.topic_country_or_region is null) and e.preferred_country in ('US','United States')) OR
	(a.eml_only_topic = 1 and isnull(e.preferred_country,'United States') in ('US','United States'))
	)
and b.email_valid=1 
then 1 else 0 end) as us_online_marketable,
max(case when d.mid is not null --online contactable
and a.email_optin=1	--category=0 and opt_out date is null or latest opt_in date>most recent opt_out date
-- update by pyoung on 2/21/07.
--and ( (c.country_or_region in (1,2,3) or ( (c.country_or_region=4 and c.topic_id <> '680') and (e.country<>'United States' or e.country is null)))
and ( 
	-- Changed by pyoung 6/2/2008, added 0
	(c.topic_opt = 1 and c.topic_country_or_region in (0,1,2,3)) OR 
	(c.topic_opt = 1 and c.topic_country_or_region=4 and (e.preferred_country not in ('US','United States') and nullif(e.preferred_country,'') is not null)) OR
	(c.topic_opt = 1 and c.topic_id='999' and (e.preferred_country not in  ('US','United States')  and nullif(e.preferred_country,'') is not null)) 
	)
and b.email_valid=1 
then 1 else 0 end) as foreign_online_marketable,
-- added by pyoung 6/2/2008
max(case when d.mid is not null --online contactable
and emea_ecomm_nikeid = 1
and (c.topic_opt = 1 and c.topic_country_or_region in (0,1,2,3,4) and g.optin_category = 'NIKEID' )
then 1 else 0 end) as emea_ecomm_nikeid,
-- added by pyoung 6/2/2008
max(case when d.mid is not null --online contactable
and emea_ecomm_nikestore = 1
and (c.topic_opt = 1 and c.topic_country_or_region in (0,1,2,3,4) and g.optin_category = 'NIKESTORE.COM' )
then 1 else 0 end) as emea_ecomm_nikestore
into agg.dbo.onlinemarketable_rollup
from agg.dbo.email_opt_temp a 
left join agg.dbo.email_rollup b on a.mid = b.mid
--left join kc.dbo.email_opt_view c on a.mid = c.mid
left join agg..email_opt_agg c on a.mid = c.mid
left join agg.dbo.onlinecontactable_rollup d on d.mid=a.mid
--left join kc.dbo.email_view e on a.mid = e.mid
-- Changed by pyoung 6/2/2008
left join agg.dbo.email_country_agg e on a.mid = e.mid
left join kc..lkp_iso_country_code f on e.preferred_country = f.global_country_name
left join kc..lkp_topic g on c.topic_id = g.topic_id
group by a.mid
--changed a.topic_id <> 680 to a.topic_id <> '680' DSTAMPER 09072006
