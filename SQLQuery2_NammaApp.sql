select count(*) from trips;

-- Trips details table contains all the details of search happened or not,any search we do is recorded in the trips details but on trips
-- table there is only that trip recorded which actually started and ended.Only for successful trip data is recorded in trip table

select count(*) from trips_details1
where end_ride = 1;


-- total trips

select count(distinct tripid) from trips_details1;

select tripid, count(tripid) as cnt from trips_details1
group by tripid
having count(tripid) > 1;


-----total drivers
select count(distinct driverid) as total_drivers from trips;


-- total earnings

select sum(fare) from trips;



-- total Completed trips

select count(distinct tripid) from trips;

-- total searches

select sum(searches) from trips_details1;

-- total searches which got fare estimate price

select sum(searches_got_estimate) from trips_details1;

-- total searches for quotes (After seeing the fare how many searches been made for drivers)

select sum(searches_for_quotes) from trips_details1;

-- total trips cancelled by drivers side

select count(*) - sum(driver_not_cancelled) from trips_details1;

-- total otp entered

select sum(otp_entered) from trips_details1;

-- total end ride

select sum(end_ride) from trips_details1;

-- average distance per trip

select avg(distance) from trips;

-- average fare per trip

select avg(fare) from trips;

--distance travelled

select sum(distance) from trips;

-- what is the most used payment method

select a.method from payment a inner join

(select top 1 faremethod, count(distinct tripid) cnt from trips
group by faremethod
order by count(distinct tripid) desc) b
on a.id = b.faremethod;

-- the highest payment was made through which instrument

select a.method from payment a inner join


(select top 1 * from trips
order by fare desc) b

on a.id = b.faremethod;



-- which two location has the most trip

select * from
(select *, dense_rank() over(order by trip desc) rnk
from
(select loc_from,loc_to,count(distinct tripid) trip from trips
group by loc_from, loc_to
)a)b
where rnk = 1;

-- top 5 earning drivers

select * from
(select *, dense_rank() over (order by fare desc) rnk
from
(select driverid, sum(fare) fare from trips
group by driverid)b)c
where rnk < 6;

-- which duration had more trips

select * from
(select *, rank() over(order by cnt desc) rnk from
(select duration, count(distinct tripid) cnt from dbo.trips
group by duration)b)c
where rnk = 1;

-- which driver customer pair had more orders

select * from
(select *, rank() over(order by cnt desc) rnk from
(select driverid, custid, count(distinct tripid) cnt from trips
group by driverid, custid)c)d
where rnk = 1;

-- search to estimate rate

select SUM(searches_got_estimate)*100.0/SUM(searches) from trips_details;

-- estimate to search for quote rates



-- quote acceptance rate


--quote to booking rate



-- booking cancellation rate


-- conversion rate


-- which area got highest number of trips in which duration

select * from
(select *, RANK() over(partition by duration order by cnt desc) rnk from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)a)c
where rnk = 1;



-- which duration got the highest number of trips in each of the location present

select * from
(select *, RANK() over(partition by loc_from order by cnt desc) rnk from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)a)c
where rnk = 1;


-- which areas got the highest fares, cancellations,trips

select * from (select *, RANK() over(order by fare desc) rnk
from
(select loc_from, SUM(fare) fare from trips
group by loc_from)b)c
where rnk = 1;

-- driver cancellation

select * from (select *, RANK() over (order by can desc) rnk
from
(
select loc_from, COUNT(*) - SUM(driver_not_cancelled) can
from trips_details
group by loc_from)b)c
where rnk = 1;

-- customer cancellation


select * from (select *, RANK() over (order by can desc) rnk
from
(
select loc_from, COUNT(*) - SUM(customer_not_cancelled) can
from trips_details
group by loc_from)b)c
where rnk = 1;


-- which duration got the highest trips and fares

-- highest fare
select * from (select *, RANK() over (order by fare desc) rnk
from
(
select duration, SUM(fare) fare
from trips
group by duration)b)c
where rnk = 1;

-- highest trips

select * from (select *, RANK() over (order by fare desc) rnk
from
(
select duration, COUNT(distinct tripid) fare
from trips
group by duration)b)c
where rnk = 1;