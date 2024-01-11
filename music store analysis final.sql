create schema Music_store;
use Music_store;
describe employee;
select * from track;
/* Senior most employee based on designation*/
select first_name,levels,title from employees order by levels desc limit 1;
/* Which countries have the most invoices(TOP 3)?*/
select billing_country, count(*) as invoices from invoice group by billing_country order by invoices desc limit 3;
/* Top 3 value of total invoice*/
select total from invoice order by total desc limit 3;
/*Which city has the best customers?*/
 select billing_city,sum(total) as total_amount from invoice group by billing_city order by total_amount desc limit 1;
/* Who is the best customer?*/
select c.first_name,sum(i.total) as amount from customer c join invoice i on c.customer_id=i.customer_id group by c.first_name order by amount desc limit 1;
/* Details of all Rock music listeners*/
select distinct c.first_name,c.last_name,c.email from customer c join invoice i on c.customer_id=i.customer_id join invoice_line l on l.invoice_id=i.invoice_id where l.track_id in (select t.track_id from track t join genre g on t.genre_id=g.genre_id where g.name='Rock') order by c.email;
/*Artist name and total track count of the top 5 rock bands:*/
select a.name as artist_name, count(a.artist_id) as number_of_songs 
from artist a join album al on a.artist_id=al.artist_id 
join track t on t.album_id= al.album_id where t.track_id in 
(select t.track_id from track t join genre g on t.genre_id=g.genre_id where g.name='Rock') 
group by artist_name 
order by number_of_songs desc limit 5;
/*all the track names that have a song length longer than the average song length*/
select name,milliseconds from track where milliseconds>
(select avg(milliseconds) from track) 
order by milliseconds desc;
/*most popular genre of music*/
select g.name,count(l.quantity) as no_times_sold 
from genre g join track t on g.genre_id=t.genre_id 
join invoice_line l on l.track_id=t.track_id 
where l.invoice_id in 
(select l.invoice_id from invoice_line l join invoice i on l.invoice_id=i.invoice_id) 
group by g.name
order by no_times_sold desc limit 1;
/* How much amount spent by each customer on most popular artist?*/
with best_seller as (
select a.artist_id,a.name as artist_name,sum(inv.unit_price*inv.quantity) as total from
artist a join album al on a.artist_id=al.artist_id join
track t on t.album_id=al.album_id join invoice_line inv on
inv.track_id=t.track_id join invoice i on i.invoice_id=inv.invoice_id
group by 1,2 order by 3
desc limit 1)
select c.first_name,c.last_name,bs.artist_name,sum(inv.unit_price*inv.quantity) as total from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line inv on inv.invoice_id=i.invoice_id
join track t on t.track_id=inv.track_id join
album al on al.album_id=t.album_id join 
best_seller bs on bs.artist_id=al.artist_id join
artist a on a.artist_id=bs.artist_id
group by 1,2,3
order by 4 desc;
/* Most popular music genre of each country*/
with most_popular as(
select g.name,c.country,count(l.quantity) as purchases,
row_number() over(partition by c.country order by count(l.quantity)) as rownum
from invoice_line l join invoice i on i.invoice_id=l.invoice_id
join customer c on c.customer_id=i.customer_id join 
track t on t.track_id=l.track_id join 
genre g on g.genre_id=t.genre_id
group by 1,2 order by 2 asc, 3 desc)
select * from most_popular where rownum=1;











