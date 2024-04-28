select distinct coalesce(a.mid,b.mid) mid
,case isnull(a.mid,0) when 0 then 0 else 1 end as nw_store_requester
,case isnull(b.mid,0) when 0 then 0 else 1 end as nt_store_requester
into agg.dbo.nt_nw_store_request_rollup
from
(select b.mid                 -- akqa cids opted into rac270w
from kc.dbo.crm_individual_view b
join kc.dbo.email_opt a 
            on a.cid = b.cid
            where a.topic_id = 'aka270w'
            and (out_date is null or in_date > out_date)
union all
select b.mid                  -- rac
from kc.dbo.crm_individual_view b
join kc..rac_contact d 
            on d.cid = b.cid
            join kc..lkp_store e
            on e.store_id = d.store_id
            where store_type_id in ('WMS')
) a
full join 
(select b.mid                 -- akqa cids opted into rac270t
from kc.dbo.crm_individual_view b
join kc.dbo.email_opt a 
            on a.cid = b.cid
            where a.topic_id = 'aka270t'
            and (out_date is null or in_date > out_date)
union all
select b.mid                  -- rac
from kc.dbo.crm_individual_view b
join kc..rac_contact d 
            on d.cid = b.cid
            join kc..lkp_store e
            on e.store_id = d.store_id
            where store_type_id in ('NT','CLOSED')
) b on a.mid = b.mid