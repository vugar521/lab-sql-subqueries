-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;

select * from film;
select * from inventory;

select count(f.film_id) from film as f
join inventory as i on f.film_id = i.film_id
where f.title="Hunchback Impossible";


-- 2. List all films whose length is longer than the average of all the films.
select * from film;
select avg(length) from film;  -- 115.

select * from film
where length > (select avg(length) from film)
;


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

select * from film_actor as fa
join actor as a on fa.actor_id = a.actor_id
where film_id =17;

select film_id from film
where title = "Alone Trip";


-- 4. Solution with subquery
select * from (select first_name, last_name from film_actor as fa
join actor as a on fa.actor_id = a.actor_id
join film as f on fa.film_id = f.film_id
where title = "Alone Trip") as sub1;


-- 5. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select * from film;
select category_id from category
where name = "Family";  -- category_id =8

select f.title from film_category as fa
join film as f on fa.film_id = f.film_id
where category_id = (select category_id from category
where name = "Family");

-- 6. Get name and email from customers from Canada using subqueries. 
--    Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.


select * from customer;
select * from address; -- city_id
select * from city; -- city_id

select country_id from country
where country ="Canada";

select cr.first_name,cr.last_name, cr.email from address as a
join city as c on a.city_id=c.city_id
join country as co on c.country_id =co.country_id
join customer as cr on a.address_id = cr.address_id
where c.country_id = (select country_id from country
where country ="Canada");


-- 7. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
--    First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select a.actor_id,count(a.actor_id) as film_count
from actor as a 
join film_actor as f on a.actor_id = f.actor_id
group by a.actor_id
order by film_count desc
limit 1; -- actor_id=107

select title from film_actor as fa
join film as f on fa.film_id = f.film_id
join actor as a on fa.actor_id = a.actor_id
where fa.actor_id =107;



-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select * from payment;
select * from customer;

-- using the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select c.customer_id, max(p.amount) as highest_amount from customer as c
join payment as p on c.customer_id = p.customer_id
group by c.customer_id
order by highest_amount desc
limit 1;  -- customer_id = 13 , 


select max(p.amount) as highest_amount from customer as c
join payment as p on c.customer_id = p.customer_id
order by highest_amount desc;  -- highest_amount = 11.99

-- Films rented by most profitable customer

select f.title from inventory as i
join rental as r on i.inventory_id = r.inventory_id
join film as f on i.film_id = f.film_id
where customer_id =13;



-- 8. Customers who spent more than the average payments.

select c.first_name, c.last_name from customer as c
join payment as p on c.customer_id = p.customer_id
where p.amount > (select avg(amount) from payment as p)
order by amount desc;



