select (sum(case when status = 'open' 
    and country = 'USA' then 1 else 0 end)*1.00)
    /count(*)*100 as share
from fb_active_users
