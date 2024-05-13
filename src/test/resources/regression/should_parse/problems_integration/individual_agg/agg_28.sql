select a.*,
convert(bit, case when b.mid is not null then 1 else 0 end) as special_program,
convert(bit, isnull(c.registered, 0)) as registered,
convert(bit, isnull(c.us_registered, 0)) as us_registered,
convert(char(1), c.registration_country) as registration_country,
convert(bit, isnull(d.optin, 0)) as optin,
convert(bit, isnull(d.us_optin, 0)) as us_optin,
convert(bit, isnull(c.email_only, 0)) as email_only,
convert(bit, isnull(c.email_valid, 0)) as email_valid,
convert(bit, case when j.mid is not null then 1 else 0 end) as email_responsive,
convert(bit, isnull(e.buyer, 0)) as buyer,
convert(bit, case when f.mid is not null then 1 else 0 end) as payer,
convert(bit, case when g.mid is not null then 1 else 0 end) as shipto,
convert(bit, coalesce(g.gift_recipient, 0)) as gift_recipient,
convert(bit, isnull(e.web_buyer, 0)) as web_buyer,

convert(bit, isnull(e.online_buyer, 0)) as online_buyer,

convert(bit, isnull(e.retail_buyer, 0)) as retail_buyer,
convert(bit, isnull(e.cs_buyer, 0)) as cs_buyer,
convert(bit, isnull(e.nike_id_buyer, 0)) as nike_id_buyer,
convert(bit, isnull(e.mens_buyer, 0)) as mens_buyer,
convert(bit, isnull(e.womens_buyer, 0)) as womens_buyer,convert(bit, isnull(e.catalog_buyer, 0)) as catalog_buyer,

convert(bit, isnull(e.clearance_store_buyer, 0)) as clearance_store_buyer,




convert(bit, isnull(e.clientele_buyer, 0)) as clientele_buyer,

convert(bit, isnull(e.dm_buyer, 0)) as dm_buyer,
convert(bit, isnull(e.returner, 0)) as returner,
convert(bit, case when r.mid is not null then 1 else 0 end) as clientele_customer,
convert(bit, case when h.mid is not null then 1 else 0 end) as catalog_requester,
convert(bit, case when i.mid is not null then 1 else 0 end) as store_requester,
convert(bit, case when k.mid is not null then 1 else 0 end) as siebel_contact,
convert(bit, isnull(l.siebel_positive, 0)) as siebel_positive,
convert(bit, isnull(l.siebel_negative, 0)) as siebel_negative,
convert(bit, case when l.catalog_opt_out = 1 or q.mid is not null or h.catalog_opt_out = 1 then 1 else 0 end) as catalog_opt_out,
convert(bit, case when isnull(e.buyer, 0) = 0 and g.mid is null and n.mid is null then 1 else 0 end) as orphan,
convert(bit, isnull(m.prospect, 0)) as prospect,
convert(bit, isnull(m.rental, 0)) as rental,
convert(int, p.age) as age,
convert(char(1), p.gender) as gender,
o.last_communication,
o.last_communication_email,
c.first_registration,
c.last_registration,
d.first_optin,
d.last_optin,
h.first_request,
h.last_request,
l.first_siebel_contact,
l.last_siebel_contact,
e.first_order,
e.last_order,
e.first_purchase,
e.last_purchase
into agg.dbo.individual_agg_new_1
from agg.dbo.individual_agg_base a
left join agg.dbo.atg_promotion_rollup b on a.mid = b.mid
left join agg.dbo.email_rollup c on a.mid = c.mid
left join agg.dbo.email_opt_rollup d on a.mid = d.mid
left join agg.dbo.orders_rollup e on a.mid = e.mid
left join agg.dbo.orders_payer_rollup f on a.mid = f.mid
left join agg.dbo.orders_shipto_giftee g on a.mid = g.mid
left join agg.dbo.request_rollup h on a.mid = h.mid
left join agg.dbo.store_request_rollup i on a.mid = i.mid
left join agg.dbo.email_activity_rollup j on a.mid = j.mid
left join agg.dbo.siebel_contact_rollup k on a.mid = k.mid
left join agg.dbo.siebel_event_rollup l on a.mid = l.mid
left join agg.dbo.prospect_rollup m on a.mid = m.mid
left join agg.dbo.sports_interest_rollup n on a.mid = n.mid
left join agg.dbo.communication_rollup o on a.mid = o.mid
left join agg.dbo.demographic_rollup p on a.mid = p.mid
left join agg.dbo.siebel_supp_rollup q on a.mid = q.mid
left join agg.dbo.clientele_rollup r on a.mid = r.mid