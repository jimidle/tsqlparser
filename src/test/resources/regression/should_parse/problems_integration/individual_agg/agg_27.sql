select a.mid, 
a.hid, 
a.deceased, 
a.dma_pander, 
a.ncoa, 
a.unuseable, 
a.vulgar as vulgar_name, 
a.fraud, 
convert(bit, case when a.employee = 1 or c.hid is not null then 1 else 0 end) as employee,
a.customer, 
--household suppression fields
b.dsf,
b.state,
b.zip,
b.ziprc,
b.zip4,
b.zip4rc,
b.vulgar as vulgar_addr,
b.prison,
b.ci,
case when b.adhoc = 1 or d.mid is not null then 1 else 0 end as adhoc,
b.apo,
b.gov,
b.military
into agg.dbo.individual_agg_base
from kc.dbo.individual_suppression a 
join kc.dbo.household_suppression b
on a.hid = b.hid
left join agg.dbo.employee_rollup c
on b.hid = c.hid
left join kc..adhoc_suppression_individual d on a.mid = d.mid
union all
select distinct a.mid, NULL, convert(bit, 0), convert(bit, 0), convert(bit, 0), convert(bit, 0),
convert(bit, 0), convert(bit, 0), convert(bit, 0), convert(bit, 1), 
--household suppression place holders
convert(bit, 0), convert(bit, 0), convert(bit, 0), convert(bit, 0), convert(bit, 0),
convert(bit, 0), convert(bit, 0), convert(bit, 0), convert(bit, 0), case when c.mid is not null then 1 else 0 end,
convert(bit, 0), convert(bit, 0), convert(bit, 0)
from kc.dbo.email_only a 
left join kc.dbo.individual b  on a.mid = b.mid
left join kc..adhoc_suppression_individual c on a.mid = c.mid
where b.mid is null