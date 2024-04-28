select coalesce(a.mid, b.mid, c.mid) as mid,
coalesce(a.gender, 
case when b.gender in ('M','F') then b.gender else NULL end, 
case when c.gender in ('M','F') then c.gender else NULL end) as gender,
coalesce(a.age, c.age) as age
into agg.dbo.demographic_rollup
from agg.dbo.demographic_self_rollup a
full outer join kc.dbo.individual b
on a.mid = b.mid
full outer join kc.dbo.datasource c
on b.mid = c.mid