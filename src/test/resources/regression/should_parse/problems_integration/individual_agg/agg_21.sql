select mid,
max(case when store_type_id = 'NT' then first_date else null end) as first_purchase_niketown,
max(case when store_type_id = 'NT' then last_date else null end) as last_purchase_niketown,
max(case when store_type_id = 'FAC' then first_date else null end) as first_purchase_factory, 
max(case when store_type_id = 'FAC' then last_date else null end) as last_purchase_factory,
max(case when store_type_id = 'WMS' then first_date else null end) as first_purchase_nikewomen, 
max(case when store_type_id = 'WMS' then last_date else null end) as last_purchase_nikewomen,
max(case when store_type_id = 'FAC' and first_date is not null then 1 else 0 end) as factory_buyer, --added by TForhad on 02/26/2007
max(case when store_type_id = 'WMS' and first_date is not null then 1 else 0 end) as nikewomen_buyer, --added by TForhad on 02/26/2007
max(case when store_type_id = 'NT' and first_date is not null then 1 else 0 end) as niketown_buyer,  --added by TForhad on 02/26/2007
max(case when store_type_id = 'FAC' and last_date > dateadd(mm, -3, @maxorder) then 1
	when store_type_id = 'FAC' and last_date > dateadd(mm, -6, @maxorder) then 2
	when store_type_id = 'FAC' and last_date > dateadd(mm, -9, @maxorder) then 3
	when store_type_id = 'FAC' and last_date > dateadd(mm, -12, @maxorder) then 4
	when store_type_id = 'FAC' and last_date > dateadd(mm, -18, @maxorder) then 5
	when store_type_id = 'FAC' and last_date > dateadd(mm, -24, @maxorder) then 6
	when store_type_id = 'FAC' and last_date > dateadd(mm, -36, @maxorder) then 7
        when store_type_id = 'FAC' and last_date <= dateadd(mm, -36, @maxorder) then 8
	else 0 end) as factory_recency, --added by TForhad on 02/26/2007
max(case when store_type_id = 'WMS' and last_date > dateadd(mm, -3, @maxorder) then 1
	when store_type_id = 'WMS' and last_date > dateadd(mm, -6, @maxorder) then 2
	when store_type_id = 'WMS' and last_date > dateadd(mm, -9, @maxorder) then 3
	when store_type_id = 'WMS' and last_date > dateadd(mm, -12, @maxorder) then 4
	when store_type_id = 'WMS' and last_date > dateadd(mm, -18, @maxorder) then 5
	when store_type_id = 'WMS' and last_date > dateadd(mm, -24, @maxorder) then 6
	when store_type_id = 'WMS' and last_date > dateadd(mm, -36, @maxorder) then 7
        when store_type_id = 'WMS' and last_date <= dateadd(mm, -36, @maxorder) then 8
	else 0 end) as nikewomen_recency, --added by TForhad on 02/26/2007
max(case when store_type_id = 'NT' and last_date > dateadd(mm, -3, @maxorder) then 1
	when store_type_id = 'NT' and last_date > dateadd(mm, -6, @maxorder) then 2
	when store_type_id = 'NT' and last_date > dateadd(mm, -9, @maxorder) then 3
	when store_type_id = 'NT' and last_date > dateadd(mm, -12, @maxorder) then 4
	when store_type_id = 'NT' and last_date > dateadd(mm, -18, @maxorder) then 5
	when store_type_id = 'NT' and last_date > dateadd(mm, -24, @maxorder) then 6
	when store_type_id = 'NT' and last_date > dateadd(mm, -36, @maxorder) then 7
        when store_type_id = 'NT' and last_date <= dateadd(mm, -36, @maxorder) then 8
	else 0 end) as niketown_recency, --added by TForhad on 02/26/2007
sum(case when store_type_id = 'FAC' then demand else 0 end) as factory_demand, --added by TForhad on 02/26/2007
sum(case when store_type_id = 'WMS' then demand else 0 end) as nikewomen_demand, --added by TForhad on 02/26/2007
sum(case when store_type_id = 'NT' then demand else 0 end) as niketown_demand, --added by TForhad on 02/26/2007
sum(case when store_type_id = 'FAC' then order_count else 0 end) as factory_frequency, --added by TForhad on 02/26/2007
sum(case when store_type_id = 'WMS' then order_count else 0 end) as nikewomen_frequency, --added by TForhad on 02/26/2007
sum(case when store_type_id = 'NT' then order_count else 0 end) as niketown_frequency --added by TForhad on 02/26/2007
into  agg.dbo.retail_store_concept
from agg.dbo.retail_store_concept_temp 
group by mid