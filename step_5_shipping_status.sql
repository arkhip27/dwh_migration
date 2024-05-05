DROP TABLE IF EXISTS public.shipping_status;
CREATE TABLE public.shipping_status(
	shipping_id    					BIGINT ,
	status							text,
	state							text,
	shipping_start_fact_datetime    TIMESTAMP,
	shipping_end_fact_datetime      TIMESTAMP,
	PRIMARY KEY (shipping_id)
);
--CREATE INDEX shipping_id2_index ON public.shipping_status(shipping_id);

INSERT INTO public.shipping_status
(shipping_id, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
with 
	max_datetime as (
		select 
			shipping_id, 
			max(state_datetime) state_datetime
		from public.shipping
		group by 
			shipping_id			
	),
	shipping_start as (
		select 
			shipping_id, 
			state_datetime
		from public.shipping
		where state = 'booked'
	),
	shipping_end as (
		select 
			shipping_id, 
			state_datetime
		from public.shipping
		where state = 'received'
	)
select 
	s.shipping_id,
	s.status,
	s.state,
	ss.state_datetime shipping_start_fact_datetime,
	se.state_datetime shipping_end_fact_datetime
from public.shipping s
	join max_datetime m 
		on s.shipping_id = m.shipping_id and s.state_datetime = m.state_datetime
	join shipping_start ss 
		on s.shipping_id = ss.shipping_id
	left join shipping_end se 
		on s.shipping_id = se.shipping_id
;

	
	




