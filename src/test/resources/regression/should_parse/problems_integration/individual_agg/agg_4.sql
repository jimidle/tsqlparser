select distinct b.mid
into agg.dbo.email_activity_rollup
from kc.dbo.email_activity a (nolock) join campaign.dbo.communication_email b
on a.email_id = b.email_id
and a.campaign_id = b.campaign_id
where a.activity = 2