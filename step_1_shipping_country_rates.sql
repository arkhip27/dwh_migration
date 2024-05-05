DROP TABLE IF EXISTS public.shipping_country_rates;
CREATE TABLE public.shipping_country_rates(
	id     BIGINT ,
	shipping_country text,
	shipping_country_base_rate NUMERIC(14,3),
	PRIMARY KEY (id)
);
CREATE INDEX id_index ON public.shipping_country_rates(id);

CREATE SEQUENCE id_sequence start 1;
INSERT INTO public.shipping_country_rates
(id, shipping_country, shipping_country_base_rate)
select
	nextval('id_sequence') as id,
	shipping_country, 
	shipping_country_base_rate 
from shipping
group by shipping_country, shipping_country_base_rate 
;
DROP SEQUENCE id_sequence;