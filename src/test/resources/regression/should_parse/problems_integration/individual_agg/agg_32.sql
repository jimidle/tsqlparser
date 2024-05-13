select a.mid
into agg.dbo.onlinecontactable_rollup
from agg.dbo.individual_agg_new_1 a
left join agg.dbo.email_rollup b on a.mid=b.mid
left join inputs.dbo.competitor_email_temp d on d.mid=a.mid
left join agg.dbo.email_opt_temp e on e.mid=a.mid
where (b.registered=1 or (e.mid is not null and e.deemed_rac_optin=1) or b.email_only=1)
and b.email_valid=1 
and d.mid is null


and  special_program = 0
and (a.vulgar_name = 0 and a.fraud = 0)
and a.deceased = 0
and (a.age is null or a.age>12)
and (e.mid is not null and e.email_optin=1)

and a.mid  in (select mid from agg..email_country_agg b where email is not null)

and adhoc=0
group by a.mid