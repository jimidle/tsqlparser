select mid
,hid
,deceased
,dma_pander
,ncoa
,unuseable
,vulgar_name
,fraud
,employee
,employee_in_hh
,customer
,dsf
,state
,zip
,ziprc
,zip4
,zip4rc
,vulgar_addr
,prison
,ci
,adhoc
,apo
,gov
,military
,special_program
,registered
,us_registered
,registration_country
,current_us_origin_optin
,us_topic_optin
,online_contactable
,us_online_marketable
,foreign_online_marketable
,emea_ecomm_nikeid
,emea_ecomm_nikestore
,optin
,us_optin
,email_only
,email_valid
,email_responsive
--Added by TForhad on 06262007
,email
,preferred_country
,buyer
,payer
,shipto
,gift_recipient
,web_buyer
,online_buyer
,retail_buyer
,factory_buyer
,nikewomen_buyer
,niketown_buyer
,cs_buyer
,nike_id_buyer
,mens_buyer
,womens_buyer
,catalog_buyer
--Added by Deepu Jose 6/6/2007
,clientele_buyer
,dm_buyer
,clientele_customer
,clearance_store_buyer
,buyer_level
,activity_level
,retail_catalog_buyer
,retail_restricted
,returner
,catalog_requester
,ecatalog_requester
,store_requester
,case when nw_store_requester_tmp = 1 
	and convert(bit, case when dsf = 0 and state = 0 and zip = 0 and ziprc = 0		--offline_contactable
	and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0		--offline_contactable
	and adhoc = 0 and apo = 0 and gov = 0 and military = 0 and deceased = 0 and ncoa = 0	--offline_contactable
	and (dma_pander = 0 or customer = 1) and unuseable = 0 and vulgar_name = 0		--offline_contactable
	and fraud = 0 and employee = 0 and special_program = 0 and mid < 2000000000 		--offline_contactable
	and employee_in_hh = 0    -- Added by DStamper 11/24/2006				--offline contactable
	and retail_restricted = 0 -- Changed by pyoung 3/23/2006				--offline_contactable
	and catalog_opt_out = 0	-- Added by pyoung 8/10/2007 					--offline_contactable
        and returned_mail=0      --Added by TForhad 1/15/2008                                    --offline_contactable
	then 1 else 0 end) 									--offline_contactable
	= 1 then 1 else 0 end as nw_store_requester
,case when nt_store_requester_tmp = 1 
	and convert(bit, case when dsf = 0 and state = 0 and zip = 0 and ziprc = 0		--offline_contactable
	and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0		--offline_contactable
	and adhoc = 0 and apo = 0 and gov = 0 and military = 0 and deceased = 0 and ncoa = 0	--offline_contactable
	and (dma_pander = 0 or customer = 1) and unuseable = 0 and vulgar_name = 0		--offline_contactable
	and fraud = 0 and employee = 0 and special_program = 0 and mid < 2000000000 		--offline_contactable
	and employee_in_hh = 0    -- Added by DStamper 11/24/2006				--offline contactable
	and retail_restricted = 0 -- Changed by pyoung 3/23/2006				--offline_contactable
	and catalog_opt_out = 0	-- Added by pyoung 8/10/2007 					--offline_contactable
        and returned_mail=0      --Added by TForhad 1/15/2008                                    --offline_contactable
	then 1 else 0 end) 									--offline_contactable
	= 1 then 1 else 0 end as nt_store_requester
,siebel_contact
,siebel_positive
,siebel_negative
,catalog_opt_out
,orphan,prospect
,rental
,age
,gender
,last_communication
,last_communication_email
,first_registration
,last_registration
,first_optin
,last_optin
,two_year_inactive
,first_request
,last_request
,first_siebel_contact
,last_siebel_contact
,first_order
,last_order
,first_purchase
,last_purchase
,first_purchase_niketown
,last_purchase_niketown
,first_purchase_factory
,last_purchase_factory
,first_purchase_nikewomen
,last_purchase_nikewomen
,factory_recency
,factory_demand
,factory_frequency
,nikewomen_recency
,nikewomen_frequency
,nikewomen_demand
,niketown_recency
,niketown_demand
,niketown_frequency 
,convert(bit, case when dsf = 0 and state = 0 and zip = 0 and ziprc = 0
	and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0
	and apo = 0 and gov = 0 and military = 0 and hid is not null
	then 1 else 0 end) as address_valid
,convert(bit, case when catalog_requester = 1 or store_requester = 1 
	or last_registration > '4/18/2004' or last_purchase > '4/18/2004'
	or last_order > '4/18/2004'
	then 0 else 1 end) as restricted
,convert(bit, case when dsf = 0 and state = 0 and zip = 0 and ziprc = 0
	and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0
	and adhoc = 0 and apo = 0 and gov = 0 and military = 0 and deceased = 0 and ncoa = 0
	and (dma_pander = 0 or customer = 1) and unuseable = 0 and vulgar_name = 0
	and fraud = 0 and employee = 0 and special_program = 0 and mid < 2000000000 
	and employee_in_hh = 0    	-- Added by DStamper 11/24/2006				--offline contactable
	and retail_restricted = 0 	-- Changed by pyoung 3/23/2006
	and catalog_opt_out = 0		--  Added by pyoung 8/9/2007
        and returned_mail=0             --Added by TForhad 1/2/2008
	then 1 else 0 end) as offline_contactable
--Added by DStamper 11/19/2006
--offline_marketable=1 if offline_contactable=1 and restricted=0, else 0
,convert(bit, case when dsf = 0 and state = 0 and zip = 0 and ziprc = 0				--offline_contactable
	and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0		--offline_contactable
	and adhoc = 0 and apo = 0 and gov = 0 and military = 0 and deceased = 0 and ncoa = 0	--offline_contactable
	and (dma_pander = 0 or customer = 1) and unuseable = 0 and vulgar_name = 0		--offline_contactable
	and fraud = 0 and employee = 0 and special_program = 0 and mid < 2000000000 		--offline_contactable
	and employee_in_hh = 0    -- Added by DStamper 11/24/2006				--offline contactable
	and retail_restricted = 0 -- Changed by pyoung 3/23/2006				--offline_contactable
	and catalog_opt_out = 0	-- Added by pyoung 8/9/2007					--offline_contactable
        and returned_mail=0      --Added by TForhad 1/2/2008                                    --offline_contactable
	and (catalog_requester = 1 or store_requester = 1 					--Restricted
	or last_registration > '4/18/2004' or last_purchase > '4/18/2004'			--Restricted
	or last_order > '4/18/2004')								--Restricted
	then 1 else 0 end) as offline_marketable
,convert(bit, case when deceased = 0 and (dma_pander = 0 or customer = 1)
	and vulgar_name = 0 and fraud = 0 and employee = 0 and adhoc = 0 and email_valid = 1 
	and (email_only = 1 or (registered = 1 and optin = 1))
	and us_optin = 1
	then 1 else 0 end) as online_us_active
,retail_only
,convert(bit, case when employee = 1 or
	(buyer = 0 and first_registration is not null and registered = 0) or
	(buyer = 0 and email_only = 1 and optin = 0) or
	(buyer = 0 and catalog_requester = 0 and store_requester = 0 
		and (us_registered = 0 or us_optin = 0)) or
	(buyer = 0 and email_valid = 0 and
		dsf = 0 and state = 0 and zip = 0 and ziprc = 0
		and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0
		and apo = 0 and gov = 0 and military = 0 and hid is not null) or
	(buyer = 0 and catalog_requester = 0 and store_requester = 0 
		and ((payer = 1 and shipto = 0) or (payer = 0 and shipto = 1))) or
	(buyer = 0 and catalog_requester = 0 and store_requester = 0 
		and payer = 0 and shipto = 0 and rental = 0 and prospect = 1) or
	(buyer = 0 and catalog_requester = 0 and store_requester = 0 
		and payer = 0 and shipto = 0 and rental = 1 and prospect = 0)
	then 0 else 1 end) as analyzable
-- ,convert(bit, case when 
-- 	(
-- 		(dsf = 0 and state = 0 and zip = 0 and ziprc = 0
-- 		and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0
-- 		and adhoc = 0 and apo = 0 and gov = 0 and military = 0 and deceased = 0 and ncoa = 0
-- 		and (dma_pander = 0 or customer = 1) and unuseable = 0 and vulgar_name = 0
-- 		and fraud = 0 and employee = 0 and special_program = 0 and mid < 2000000000 
-- 		and retail_restricted = 0)
-- 		and 
-- 		(catalog_requester = 1 or store_requester = 1 
-- 		or last_registration > '4/18/2004' or last_purchase > '4/18/2004'
-- 		or last_order > '4/18/2004')
-- 	) 
-- 	or current_us_origin_optin = 1 or us_topic_optin = 1 then 1 else 0 end
-- 	) as us_marketable


-- Update to US Marketable Definition  
-- 1) Anyone that is offline contactable and not privacy restricted
-- or
-- 2) has US_online_marketable flag=1  
,convert(bit,case when 
	(case when dsf = 0 and state = 0 and zip = 0 and ziprc = 0			       --offline contactable
	and zip4 = 0 and zip4rc = 0 and vulgar_addr = 0 and prison = 0 and ci = 0		--offline contactable
	and adhoc = 0 and apo = 0 and gov = 0 and military = 0 and deceased = 0 and ncoa = 0	--offline contactable
	and (dma_pander = 0 or customer = 1) and unuseable = 0 and vulgar_name = 0		--offline contactable
	and fraud = 0 and employee = 0 and special_program = 0 and mid < 2000000000 		--offline contactable
	and employee_in_hh = 0    -- Added by DStamper 11/24/2006				--offline contactable
	and retail_restricted = 0 -- Changed by pyoung 3/23/2006				--offline contactable
	and catalog_opt_out = 0	-- Added by pyoung 8/9/2007					--offline_contactable
        and returned_mail=0   --Added by TForhad 01/15/2008                                     --offline contactable
	then 1 else 0 end = 1									
	AND
	case when catalog_requester = 1 or store_requester = 1 			--restricted
	or last_registration > '4/18/2004' or last_purchase > '4/18/2004'			--restricted
	or last_order > '4/18/2004'								--restricted
	then 0 else 1 end = 0)									--restricted
	OR
	us_online_marketable = 1 then 1 else 0 end )
	as us_marketable,
        returned_mail
into agg.dbo.individual_agg_new1
from agg.dbo.individual_agg_new