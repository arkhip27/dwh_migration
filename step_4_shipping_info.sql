DROP TABLE IF EXISTS public.shipping_info;
CREATE TABLE public.shipping_info(
	shipping_id   					 BIGINT,
	vendor_id                        BIGINT,
	payment_amount                   NUMERIC(14,2),
	shipping_plan_datetime           TIMESTAMP,
	shipping_transfer_id			 BIGINT,
	shipping_agreement_id			 BIGINT,
	shipping_country_rate_id		 BIGINT,
	PRIMARY KEY (shipping_id),
	FOREIGN KEY (shipping_transfer_id) REFERENCES shipping_transfer(id) ON UPDATE cascade,
	FOREIGN KEY (shipping_agreement_id) REFERENCES shipping_agreement(agreement_id) ON UPDATE cascade,
	FOREIGN KEY (shipping_country_rate_id) REFERENCES shipping_country_rates(id) ON UPDATE cascade
);
CREATE INDEX shipping_id_index ON public.shipping_info(shipping_id);

INSERT INTO public.shipping_info
(shipping_id, vendor_id, payment_amount, shipping_plan_datetime, shipping_transfer_id, shipping_agreement_id, shipping_country_rate_id)
select distinct 
	s.shipping_id,
	s.vendor_id,
	s.payment_amount,
	s.shipping_plan_datetime,
	t.id,
	a.agreement_id,
	c.id 
from public.shipping s
join shipping_transfer t on s.shipping_transfer_description = t.transfer_type ||':'|| t.transfer_model
join shipping_agreement a on s.vendor_agreement_description = a.agreement_id ||':'|| a.agreement_number ||':'|| a.agreement_rate ||':'|| a.agreement_commission
join shipping_country_rates c on s.shipping_country = c.shipping_country 
;
