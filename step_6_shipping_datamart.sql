DROP VIEW IF EXISTS public.shipping_datamart;
CREATE VIEW public.shipping_datamart as
	select 
		si.shipping_id,
		si.vendor_id,
		st.transfer_type,
		(ss.shipping_end_fact_datetime-ss.shipping_start_fact_datetime) full_day_at_shipping,
		case 
			when ss.shipping_end_fact_datetime > si.shipping_plan_datetime 
			then 1
			else 0
		end as is_delay,
		case 
			when ss.status = 'finished'
			then 1
			else 0
		end as is_shipping_finish,
		case 
			when ss.shipping_end_fact_datetime > si.shipping_plan_datetime
			then EXTRACT(DAY FROM ss.shipping_end_fact_datetime-si.shipping_plan_datetime)
			else 0
		end as delay_day_at_shipping,
		si.payment_amount,
		(si.payment_amount*(scr.shipping_country_base_rate+sa.agreement_rate+st.shipping_transfer_rate)) vat,
		(si.payment_amount*sa.agreement_commission) profit
	from 
		public.shipping_info si 
	join public.shipping_transfer st 
		on si.shipping_transfer_id = st.id 
	join public.shipping_status ss 
		on si.shipping_id = ss.shipping_id 
	join public.shipping_country_rates scr 
		on si.shipping_country_rate_id = scr.id 
	join public.shipping_agreement sa 
		on si.shipping_agreement_id = sa.agreement_id 
;

