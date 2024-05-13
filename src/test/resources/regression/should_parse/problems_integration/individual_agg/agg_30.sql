select a.mid,

max(case when a.category in (0,2,3) and (a.last_optout is null or a.last_optin>a.last_optout) then 1 else 0 end) as email_optin,
max(case when (b.mid is not null) and (b.last_optout is null or b.last_optin>b.last_optout) then 1 else 0 end) as deemed_rac_optin,
a.eml_only_topic