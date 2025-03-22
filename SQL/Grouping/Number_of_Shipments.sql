select to_char(shipment_date, 'YYYY-MM') as Month_
    , count(*) as number_of_shipments
from amazon_shipment
group by to_char(shipment_date, 'YYYY-MM')
