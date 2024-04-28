select 
a.mid,
a.hid,
a.deceased,a.dma_pander,
a.ncoa,
a.unuseable,
a.vulgar_name,
a.fraud,
a.employee,
--Added by DStamper 11/24/2006
convert(bit,case when ehh.mid is not null then 1 else 0 end) as employee_in_hh,
a.customer,
a.dsf,
a.state,
a.zip,
a.ziprc,
a.zip4,
a.zip4rc,
a.vulgar_addr,
a.prison,
a.ci,
a.adhoc,
a.apo,
a.gov,
a.military
,a.special_program
,a.registered
,a.us_registered
,a.registration_country
-- Added by pyoung on 5/2/2006 
,convert(bit, isnull(u.current_us_origin_optin,0)) as current_us_origin_optin
-- Added by pyoung on 5/2/2006, modified by djose 10162006
,convert(bit, case when isnull(v.us_topic_optin,0)=1 or (isnull(y.us_online_marketable,0)=1 and isnull(u.current_us_origin_optin,0)=0) then 1 else 0 end) as us_topic_optin
-- Added by TForhad on 09/04/2006
,convert(bit,case when x.mid is not null then 1 else 0 end) as online_contactable
-- Added by TForhad on 09/04/2006
,convert(bit,isnull(y.us_online_marketable,0)) as us_online_marketable
-- Added by TForhad on 09/04/2006
,convert(bit,isnull(y.foreign_online_marketable,0)) as foreign_online_marketable
,convert(bit,isnull(y.emea_ecomm_nikeid,0)) as emea_ecomm_nikeid
,convert(bit,isnull(y.emea_ecomm_nikestore,0)) as emea_ecomm_nikestore
--,convert(bit,isnull(w.foreign_online_marketable,0)) as foreign_online_marketable
,a.optin
,a.us_optin
,a.email_only
,a.email_valid
,a.email_responsive
-- Added by TForhad on 06262007
,ec.email 
,convert(varchar(50),ec.preferred_country) as preferred_country
,a.buyer
,a.payer
,a.shipto
,a.gift_recipient
,a.web_buyer
,a.online_buyer
,a.retail_buyer
,convert(bit, isnull(s.factory_buyer,0)) as factory_buyer
,convert(bit, isnull(s.nikewomen_buyer,0)) as nikewomen_buyer
,convert(bit, isnull(s.niketown_buyer,0)) as niketown_buyer
,a.cs_buyer
,a.nike_id_buyer
,a.mens_buyer
,a.womens_buyer
,a.catalog_buyer
--Added by Deepu Jose 6/6/2007
,a.clientele_buyer
,a.dm_buyer
,a.clientele_customer
--added by TForhad on 03/19/2007
,a.clearance_store_buyer
-- added by pyoung on 2/27/2007
,isnull(bl.buyer_level,'NON-BUYER') as buyer_level
,isnull(bl.activity_level,'NON-BUYER') as activity_level
,convert(bit, isnull(t.retail_catalog_buyer, 0)) as retail_catalog_buyer
-- Added by pyoung on 3/23/2006
,convert(bit,case when r.opt_in = 0 then 1 else 0 end) as retail_restricted
,a.returner
,a.catalog_requester
,convert(bit, case when a1.mid is not null then 1 else 0 end) as ecatalog_requester --changed by David Stamper 20060906
,a.store_requester
,a.siebel_contact
,a.siebel_positive
,a.siebel_negative
,a.catalog_opt_out
,a.orphan
,a.prospect
,a.rental
,a.age
,a.gender
,a.last_communication
,a.last_communication_email
,a.first_registration
,a.last_registration
,a.first_optin
,a.last_optin
--added by DStamper 6/27/06
,convert(bit, case when 
	(a.last_communication is not null and a.last_communication >= DATEADD(year, -2, @update))
	or (a.last_communication_email is not null and a.last_communication_email >= DATEADD(year, -2, @update))
	or (a.last_registration is not null and a.last_registration >= DATEADD(year, -2, @update))
	or (a.last_optin is not null and a.last_optin >= DATEADD(year, -2, @update))
	or (a.last_request is not null and a.last_request >= DATEADD(year, -2, @update))
	or (a.last_siebel_contact is not null and a.last_siebel_contact >= DATEADD(year, -2, @update))
	or (a.last_order is not null and a.last_order >= DATEADD(year, -2, @update))
	or (a.last_purchase is not null and a.last_purchase >= DATEADD(year, -2, @update))
	or (s.last_purchase_niketown is not null and s.last_purchase_niketown >= DATEADD(year, -2, @update))
	or (s.last_purchase_factory is not null and s.last_purchase_factory >= DATEADD(year, -2, @update))
	or (s.last_purchase_nikewomen is not null and s.last_purchase_nikewomen >= DATEADD(year, -2, @update))
	then 0 else 1 end ) as two_year_inactive
,a.first_request
,a.last_request
,a.first_siebel_contact
,a.last_siebel_contact
,a.first_order
,a.last_order
,a.first_purchase
,a.last_purchase
,s.first_purchase_niketown
,s.last_purchase_niketown
,s.first_purchase_factory 
,s.last_purchase_factory
,s.first_purchase_nikewomen 
,s.last_purchase_nikewomen
,isnull(s.factory_recency,0) as factory_recency
,isnull(s.nikewomen_recency,0) as nikewomen_recency
,isnull(s.niketown_recency,0) as niketown_recency
,convert(numeric(11,2),isnull(s.factory_demand,0)) as factory_demand
,convert(numeric(11,2),isnull(s.nikewomen_demand,0)) as nikewomen_demand
,convert(numeric(11,2),isnull(s.niketown_demand,0)) as niketown_demand
,isnull(s.factory_frequency,0) as factory_frequency
,isnull(s.nikewomen_frequency,0) as nikewomen_frequency
,isnull(s.niketown_frequency,0) as niketown_frequency
,convert(bit, isnull(z.nt_store_requester,0)) as nt_store_requester_tmp --added by David Stamper 20060906
,convert(bit, isnull(z.nw_store_requester,0)) as nw_store_requester_tmp --added by David Stamper 20060906
,convert(bit, case when ro.mid is not null then 1 else 0 end) as retail_only --added by Deepu Jose 20061012
,convert(bit, case when rm.mid is not null then 1 else 0 end) as returned_mail --added by TForhad 01/03/2008
into agg.dbo.individual_agg_new
from agg.dbo.individual_agg_new_1 a
-- Added by pyoung on 3/23/2006
left join agg.dbo.retail_opt_rollup r on a.mid = r.mid
-- Added by pyoung on 3/24/2006
left join agg.dbo.retail_store_concept s on a.mid = s.mid
-- Added by pyoung on 3/30/2006
left join agg.dbo.retail_catalog_buyer t on a.mid = t.mid
-- Added by pyoung 5/2/2006
left join agg.dbo.current_us_origin_optin u on a.mid = u.mid
left join agg.dbo.us_topic_optin v on a.mid = v.mid
-- Added by pyoung 5/23/2006
--left join agg.dbo.foreign_online_marketable w on a.mid=w.mid 
--Added by TForhad 09/04/2006
left join agg.dbo.onlinecontactable_rollup x on a.mid=x.mid
--Added by TForhad 09/04/2006
left join agg.dbo.onlinemarketable_rollup  y on a.mid=y.mid
left join agg.dbo.nt_nw_store_request_rollup z on a.mid = z.mid --added by David Stamper 20060906
left join agg.dbo.ecatalog_request_rollup a1 on a.mid = a1.mid --added by David Stamper 20060906
left join agg.dbo.retail_only ro on a.mid=ro.mid --added by Deepu Jose 10122006
left join agg.dbo.employee_in_hh_temp ehh on a.mid = ehh.mid  --Added by DStamper 11/24/2006
left join agg.dbo.buyer_level_temp bl on a.mid = bl.mid
left join agg.dbo.email_country_agg ec on a.mid=ec.mid -- Added by TForhad on 06262007
left join agg.dbo.return_mail_rollup rm on a.mid=rm.mid --Added by TForhad 01/03/2008
