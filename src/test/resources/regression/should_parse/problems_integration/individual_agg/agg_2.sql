select a.mid,
min(registration_date) as first_registration,
max(registration_date) as last_registration,
-- update by Pyoung on 1/11/2006. Takes into account the never registered people.
max(case when ((registration_date > deregistration_date)
	or deregistration_date is null)
	and invalid is null then 1 else 0 end) as email_valid,
--max(case when registration_date is not null
--	and deregistration_date is null
--	and invalid is null then 1 else 0 end) as email_valid,
min(case when left(cid, 4) = 'ATGU'
	and first_name = 'EMAILONLYUSER'
	and last_name = 'EMAILONLYUSER' then 1 else 0 end) as email_only,
max(case when (isnull(first_name, '') <> 'EMAILONLYUSER' or isnull(last_name, '') <> 'EMAILONLYUSER')
	and (b.last_deregistration is null or b.last_registration>b.last_deregistration)
        and b.mid is not null 
	then 1 else 0 end) as registered,
max(us_active) as us_registered,
max(case when country = 'UNITED STATES' then 'U'
	when country is not null then 'F'
	else NULL end) as registration_country
into agg.dbo.email_rollup
from kc.dbo.email_view a
left join agg.dbo.email_rollup_temp b on a.mid=b.mid
group by a.mid