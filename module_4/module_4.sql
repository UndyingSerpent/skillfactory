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

-- Задание 4.5
/*
 Вопрос 1 звучит: Мест какого класса у SU9 больше всего?
 Су-9 — советский однодвигательный всепогодный истребитель-перехватчик ;)
 Конечно же комфорт! ;)))
 Так разу и не поймешь, что SU9 - это aircraft_code
*/
select s.fare_conditions,
       count (s.aircraft_code) as cnt_class
from dst_project.seats s
where s.aircraft_code = 'SU9'
group by s.fare_conditions
order by cnt_class desc
limit 1
;

select *
from dst_project.bookings b
order by b.total_amount asc
limit 1
;

select b.seat_no
from dst_project.tickets t
    join dst_project.boarding_passes b on b.ticket_no = t.ticket_no
where t.passenger_id = '4313 788533'

-- Задание 5.1
select count(flight_id) as cnt_flight
from dst_project.flights f
    join dst_project.airports a
        on a.airport_code = f.arrival_airport
        and a.city = 'Anapa'
--where (date_trunc('year', f.actual_arrival) in ('2017-01-01'))
where (date_part('year', f.actual_arrival) = 2017)
;

select count(f.flight_id) as cnt_flight
from dst_project.flights f
    join dst_project.airports a
        on a.airport_code = f.departure_airport
        and a.city = 'Anapa'
where (date_trunc('month', f.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
        AND status not in ('Cancelled')
;

select count(flight_id) as cnt_flight
from dst_project.flights f
    join dst_project.airports a
        on a.airport_code = f.departure_airport
        and a.city = 'Anapa'
where f.status = 'Cancelled'
;

select count(f.flight_id) as cnt_flight
from dst_project.flights f
    join dst_project.airports a
        on a.airport_code = f.departure_airport
        and a.city = 'Anapa'
    join dst_project.airports aa
        on aa.airport_code = f.arrival_airport
        and aa.city not in ('Moscow')
;

select a.model,
       count(distinct s.seat_no) as cnt_seat
from dst_project.seats s
    join dst_project.aircrafts a
        on a.aircraft_code = s.aircraft_code
    join dst_project.flights f
        on f.aircraft_code = s.aircraft_code
        and f.departure_airport = 'AAQ'
group by a.model
order by cnt_seat desc
limit 1
;

-- 6. Переходим к реальной аналитике
/*
Данные полученные из интернета
Расход топлива 737-300 = 2600 кг/ч = 43,3 кг/мин
Расход топлива Superjet-100 = 1700 кг/ч = 28,3 кг/мин
стоимость топлива на январь 2017 в Анапе = 41435 за тонну = 41,4 за кг
*/

-- Не понятно по заданию, надо ли в запрос добавлять данные по раходу или нет
-- Пусть останется для истории, а выгрузим мы "аналитикам" только то, что есть в базе

/*
SELECT f.flight_id,
       f.flight_no,
       --f.departure_airport,
       air_d.city as departure_city,
       --f.arrival_airport,
       air_a.city as arrival_city,
       f.scheduled_departure,
       f.scheduled_arrival,
       date_part('hour', f.actual_arrival - f.actual_departure)*60
        + date_part('minute', f.actual_arrival - f.actual_departure) as flight_time_minutes,
       a.model,
       s.count_seats,
       coalesce(b.count_seats, 0) as boarding_seats,
       coalesce(t.amount, 0) as total_amount,
       fc.fuel_consuption * 41.4 *
            (
               date_part('hour', f.actual_arrival - f.actual_departure)*60
             + date_part('minute', f.actual_arrival - f.actual_departure)
            ) as cost,  -- Общая стоимость полета (Расход * стоимость * время)
       coalesce(t.amount, 0)
           - (fc.fuel_consuption * 41.4 *
            (
               date_part('hour', f.actual_arrival - f.actual_departure)*60
             + date_part('minute', f.actual_arrival - f.actual_departure)
            )) as profit  -- Выручка
FROM dst_project.flights f
    join dst_project.aircrafts a -- Самолет
        on a.aircraft_code = f.aircraft_code
    join dst_project.airports air_d -- Аэропорт вылета
        on air_d.airport_code = f.departure_airport
    join dst_project.airports air_a -- Аэропорт прилета
        on air_a.airport_code = f.arrival_airport
    join (select s.aircraft_code, count(seat_no) as count_seats -- Кол-во мест в самолете
            from dst_project.seats s
            group by s.aircraft_code) s
        on s.aircraft_code = f.aircraft_code
    left join (select b.flight_id, count(b.seat_no) as count_seats -- Сколько мест занято в самолете
            from dst_project.boarding_passes b
            group by b.flight_id) b
        on b.flight_id = f.flight_id
    left join (select t.flight_id, sum(t.amount) as amount -- Общая сумма
            from dst_project.ticket_flights t
            group by t.flight_id) t
        on t.flight_id = f.flight_id
    join (
            select '733' as aircraft_code, 43.3 as fuel_consuption -- Расход топлива для Boeing
            union
            select 'SU9' as aircraft_code, 28.3 as fuel_consuption) fc -- Расход топлива для Superjet
        on fc.aircraft_code = f.aircraft_code
WHERE f.departure_airport = 'AAQ'
  AND (date_trunc('month', f.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
  AND f.status not in ('Cancelled')
order by profit asc
;
 */

SELECT f.flight_id, -- ID рейса
       f.flight_no, -- Номер рейса
       air_d.city as departure_city, -- Город вылета (Анапа, в нашем случае)
       air_a.city as arrival_city, -- Город прилета
       f.scheduled_departure, -- Дата запалнированного вылета
       f.scheduled_arrival, -- Дата запланированного прилета
       date_part('hour', f.actual_arrival - f.actual_departure)*60
        + date_part('minute', f.actual_arrival - f.actual_departure) as flight_time_minutes, -- Время в пути
       a.model, -- Модель самолета
       s.count_economy, -- Количество мест в самолете
       coalesce(t.count_economy, 0) as boarding_economy, -- Количество занятых мест в самолете
       s.count_comfort, -- Количество мест в самолете
       coalesce(t.count_comfort, 0) as boarding_comfort, -- Количество занятых мест в самолете
       s.count_business, -- Количество мест в самолете
       coalesce(t.count_business, 0) as boarding_business, -- Количество занятых мест в самолете
       coalesce(t.amount, 0) as total_amount -- Сумма проданных билетов на рейст
FROM dst_project.flights f
    join dst_project.aircrafts a -- Самолет
        on a.aircraft_code = f.aircraft_code
    join dst_project.airports air_d -- Аэропорт вылета
        on air_d.airport_code = f.departure_airport
    join dst_project.airports air_a -- Аэропорт прилета
        on air_a.airport_code = f.arrival_airport
    join (select s.aircraft_code, -- Кол-во мест в самолете
                count (CASE WHEN s.fare_conditions = 'Economy' THEN s.seat_no END) as count_economy,
                count (CASE WHEN s.fare_conditions = 'Comfort' THEN s.seat_no END) as count_comfort,
                count (CASE WHEN s.fare_conditions = 'Business' THEN s.seat_no END) as count_business
            from dst_project.seats s
            group by s.aircraft_code) s
        on s.aircraft_code = f.aircraft_code
    left join (select t.flight_id,
                      sum(t.amount) as amount, -- Общая сумма
                      count (CASE WHEN t.fare_conditions = 'Economy' THEN t.fare_conditions END) as count_economy,
                      count (CASE WHEN t.fare_conditions = 'Comfort' THEN t.fare_conditions END) as count_comfort,
                      count (CASE WHEN t.fare_conditions = 'Business' THEN t.fare_conditions END) as count_business
                from dst_project.ticket_flights t
                group by t.flight_id) t
        on t.flight_id = f.flight_id
WHERE f.departure_airport = 'AAQ'
  AND (date_trunc('month', f.scheduled_departure) in ('2017-01-01','2017-02-01', '2017-12-01'))
  AND f.status not in ('Cancelled')
order by f.flight_id
;
