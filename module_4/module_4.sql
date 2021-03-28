-- Задание 4.1
select a.city, count(a.airport_code) as cnt_airport
from airports a
group by a.city
having count(a.airport_code) > 1
;

-- Задание 4.2
select count(distinct f.status) as cnt_status
from flights f
;

select count(f.flight_id) as cnt_flight
from flights f
where f.status = 'Departed'
;

select count(s.aircraft_code) as cnt_seat
from seats s
    join aircrafts a
        on a.aircraft_code = s.aircraft_code
            and a.model = 'Boeing 777-300'
;

select count(f.flight_id) as cnt_flight
from flights f
where f.status = 'Arrived'
        and f.actual_arrival between '2017-04-1' and '2017-09-1'
;

-- Задание 4.3
select count(f.flight_id) as cnt_flight
from flights f
where f.status = 'Cancelled'
;

select count(a.aircraft_code) as cnt_aircraft
from aircrafts a
where a.model like 'Boeing%'
;
select count(a.aircraft_code) as cnt_aircraft
from aircrafts a
where a.model like 'Sukhoi Superjet%'
;
select count(a.aircraft_code) as cnt_aircraft
from aircrafts a
where a.model like 'Airbus%'
;

select a.timezone, count (a.airport_code) as count_airport
from airports a
group by  a.timezone
order by count_airport desc

select f.flight_id,
        (f.actual_arrival - f.scheduled_arrival) as delta
from flights f
where actual_arrival is not null
order by delta desc
limit 1
;

-- Задание 4.4


