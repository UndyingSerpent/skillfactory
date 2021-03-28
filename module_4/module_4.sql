-- Задание 4.1
select a.city, count(a.airport_code) as cnt_airport
from dst_project.airports a
group by a.city
having count(a.airport_code) > 1
;

-- Задание 4.2
select count(distinct f.status) as cnt_status
from dst_project.flights f
;

select count(f.flight_id) as cnt_flight
from dst_project.flights f
where f.status = 'Departed'
;

select count(s.aircraft_code) as cnt_seat
from dst_project.seats s
    join dst_project.aircrafts a
        on a.aircraft_code = s.aircraft_code
            and a.model = 'Boeing 777-300'
;

select count(f.flight_id) as cnt_flight
from dst_project.flights f
where f.status = 'Arrived'
        and f.actual_arrival between '2017-04-1' and '2017-09-1'
;

-- Задание 4.3
select count(f.flight_id) as cnt_flight
from dst_project.flights f
where f.status = 'Cancelled'
;

select count(a.aircraft_code) as cnt_aircraft
from dst_project.aircrafts a
where a.model like 'Boeing%'
;
select count(a.aircraft_code) as cnt_aircraft
from dst_project.aircrafts a
where a.model like 'Sukhoi Superjet%'
;
select count(a.aircraft_code) as cnt_aircraft
from dst_project.aircrafts a
where a.model like 'Airbus%'
;

select a.timezone, count (a.airport_code) as count_airport
from dst_project.airports a
group by  a.timezone
order by count_airport desc

select f.flight_id,
        (f.actual_arrival - f.scheduled_arrival) as delta
from dst_project.flights f
where actual_arrival is not null
order by delta desc
limit 1
;

-- Задание 4.4
select f.scheduled_departure
from dst_project.flights f
order by f.scheduled_departure
limit 1
;

select (date_part('hour', f.scheduled_arrival - f.scheduled_departure)*60
        + date_part('minute', f.scheduled_arrival - f.scheduled_departure)) as duration_in_min,
       (f.scheduled_arrival - f.scheduled_departure) as duration
from dst_project.flights f
where f.scheduled_arrival is not null
--order by duration_in_min desc
order by duration desc
limit 1
;

select (date_part('hour', f.scheduled_arrival - f.scheduled_departure)*60
        + date_part('minute', f.scheduled_arrival - f.scheduled_departure)) as duration_in_min,
       f.departure_airport, f.arrival_airport
from dst_project.flights f
where f.scheduled_arrival is not null
--order by duration_in_min desc
order by duration_in_min desc
limit 1
;

select date_part('hour', avg(f.actual_arrival - f.actual_departure)) * 60
       + date_part('minute', avg(f.actual_arrival - f.actual_departure)) as avg_flight_time
from dst_project.flights f
;

