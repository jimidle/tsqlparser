select mid,
	case when total_purchases = 0 then 'NON-BUYER'
		when total_purchases = 1 then 'ONE-TIME-BUYER' 
		else 'REPEAT BUYER' end as buyer_level,
	case    when last_purchase between dateadd(dd, 1, dateadd(m, -3, @maxorder)) and @maxorder then 'ACTIVE3' 
                when last_purchase between dateadd(dd, 1, dateadd(m, -6, @maxorder)) and dateadd(m,-3, @maxorder) then 'ACTIVE6' 
		when last_purchase between dateadd(dd, 1, dateadd(m, -12, @maxorder)) and dateadd(m,-6, @maxorder) then 'LAPSED'
		when last_purchase between dateadd(dd, 1, dateadd(m, -36, @maxorder)) and dateadd(m,-12, @maxorder) then 'INACTIVE'
		when last_purchase <=  dateadd(m,-36, @maxorder) then 'DEEP INACTIVE' else 'NON-BUYER' end as activity_level
into agg..buyer_level_temp
from agg..order_qty a