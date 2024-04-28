select b.mid,
min(case when left(a.cid, 4) in ('ATGU','RACN') and gender = '1' then 'F' else
	(case when left(a.cid, 4) in ('ATGU','RACN') and gender = '2' then 'M' else
		(case when gender in ('M','F') then gender else NULL end) end) end) as gender,
convert(int, max(round(datediff(dd, birth_date, getdate()) / 365.25, 0, 1))) as age 
into agg.dbo.demographic_self_rollup
from kc.dbo.demographic a join kc.dbo.crm_individual_view b
on a.cid = b.cid
where birth_date is not null or nullif(gender, '') is not null
group by b.mid