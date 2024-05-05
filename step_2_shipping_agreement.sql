DROP TABLE IF EXISTS public.shipping_agreement;
CREATE TABLE public.shipping_agreement(
	agreement_id     BIGINT ,
	agreement_number text,
	agreement_rate NUMERIC(10,2),
	agreement_commission NUMERIC(10,2),
	PRIMARY KEY (agreement_id)
);
CREATE INDEX agreement_id_index ON public.shipping_agreement(agreement_id);

INSERT INTO public.shipping_agreement
(agreement_id, agreement_number, agreement_rate, agreement_commission)
select
	cast(vendor_agreement_description[1] as BIGINT) agreement_id, 
	vendor_agreement_description[2] agreement_number, 
	cast(vendor_agreement_description[3] as NUMERIC(10,2)) agreement_rate, 
	cast(vendor_agreement_description[4] as NUMERIC(10,2)) agreement_commission
from
	(select distinct  regexp_split_to_array(vendor_agreement_description, ':+') as vendor_agreement_description
	from public.shipping) as regexp
	order by agreement_id