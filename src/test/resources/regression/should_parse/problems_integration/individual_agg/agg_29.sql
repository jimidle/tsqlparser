select a.mid,b.topic_id as topic_id,
max(in_date) as last_optin,
max(out_date) as last_optout
into  inputs.dbo.deemed_rac_optin_temp
from  kc.dbo.temp_crm_ind_v_mid_cid a 
join kc.dbo.email_opt b on a.cid = b.cid
--join kc.dbo.participation c on c.cid=b.cid and c.topic_id=b.topic_id
join meta..ctl_deemed_opt c on c.topic_id = b.topic_id and  substring(b.cid,1,4) = c.source_flag
where  substring(b.cid,1,4)  <> 'ATGU'
group by a.mid,b.topic_id
union 
--RAC optin topic
select a.mid,b.topic_id as topic_id,
max(in_date) as last_optin,
max(out_date) as last_optout
from  kc.dbo.temp_crm_ind_v_mid_cid a 
join kc.dbo.email_opt b on a.cid = b.cid
where b.cid like 'RAC%'
group by a.mid,b.topic_id