select a.mid,
max(case when b.mid is not null or (a.source_flag > 'A128' 
	and allowable_uses = 0) then 1 else 0 end) as prospect,
min(case when b.mid is null and ((a.source_flag > 'A128' and a.allowable_uses > 0) 
	or a.source_flag between 'A001' and 'A128') then 1 else 0 end) as rental
into agg.dbo.prospect_rollup
from kc.dbo.source_history_vertical a (nolock)
left join agg.dbo.experian_promo b on a.mid = b.mid
group by a.mid