DROP TABLE IF EXISTS public.shipping_transfer;
CREATE TABLE public.shipping_transfer(
	id     BIGINT ,
	transfer_type text,
	transfer_model text,
	shipping_transfer_rate NUMERIC(14,3),
	PRIMARY KEY (id)
);
CREATE INDEX transfer_id_index ON public.shipping_transfer(id);

CREATE SEQUENCE id_sequence start 1;
INSERT INTO public.shipping_transfer
(id, transfer_type , transfer_model, shipping_transfer_rate)
select
	nextval('id_sequence') as id,
	shipping_transfer_description[1] as transfer_type,
	shipping_transfer_description[2] as transfer_model,
	shipping_transfer_rate
from(
	select distinct  
		regexp_split_to_array(shipping_transfer_description, ':+') as shipping_transfer_description, 
		shipping_transfer_rate 
	from public.shipping ) regexp;
DROP SEQUENCE id_sequence;

