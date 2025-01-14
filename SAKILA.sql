--CUSTOMER & SALES ANALYSIS

--What is the total revenue generated by each customer?

SELECT c.customer_id,c.first_name,c.last_name,SUM(p.amount) Customer_Total_Revenue
FROM customer c
JOIN payment p ON p.customer_id=c.customer_id
GROUP BY 1,2,3
ORDER BY 4 DESC;

--Which customer has rented the most films and how many?

SELECT c.customer_id,c.first_name,c.last_name,COUNT(r.rental_id) Total_Rentals
FROM customer c
JOIN rental r ON r.customer_id=c.customer_id
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 1;

--What is the total revenue generated by each city?

SELECT c.city_id,c.city,SUM(p.amount) City_Total_Revenue
FROM city c
JOIN address a ON c.city_id=a.city_id
JOIN customer cu ON cu.address_id=a.address_id
JOIN payment p ON p.customer_id=cu.customer_id
GROUP BY 1,2
ORDER BY 3 DESC

--FILM & INVENTORY ANALYSIS

--Which films are rented out the most and how often?

SELECT f.film_id,f.title,COUNT(r.rental_id) Total_Rentals
FROM film f
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 32;

--What are the least 5 rented out films?

SELECT f.film_id,f.title,COUNT(r.rental_id) Total_Rentals
FROM film f
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
GROUP BY 1,2
ORDER BY 3 
LIMIT 5;

--What is the total revenue generated by each film category ?

SELECT c.category_id,c.name Catgeory,SUM(p.amount) Category_Total_Revenue
FROM category c 
JOIN film_category fc ON fc.category_id=c.category_id
JOIN film f ON f.film_id=fc.film_id
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN payment p ON p.rental_id=r.rental_id
GROUP BY 1,2
ORDER BY 3 DESC;

--Which films have not been rented in the past year?

SELECT f.film_id,f.title 
FROM inventory i
LEFT JOIN film f ON i.film_id=f.film_id
LEFT JOIN rental r ON r.inventory_id=i.inventory_id
WHERE rental_date IS NULL;

--How many films are currently avaliable in each store?

SELECT s.store_id,COUNT(f.film_id) Store_Film_Count
FROM store s 
JOIN inventory i ON i.store_id=s.store_id
JOIN film f ON f.film_id=i.film_id
GROUP BY 1
ORDER BY 2 DESC;

--What is the variability in the number of rentals across different months

SELECT STDDEV(RENTALS) Rental_Standard_Deviation
FROM(SELECT DATE_FORMAT(rental_date,'%Y-%M') Month,SUM(rental_id) RENTALS
FROM rental
GROUP BY 1
ORDER BY 2 DESC)SUB


--STORE PERFORMANCE

--What is the total revenue generated by each store?

SELECT s.store_id,SUM(p.amount) Store_Total_Revenue
FROM store s
JOIN inventory i ON i.store_id=s.store_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN payment p ON p.rental_id=r.rental_id
GROUP BY 1
ORDER BY 2 DESC;

--Which store has the highest number of rentals

SELECT s.store_id,COUNT(r.rental_id) Store_Total_Rentals
FROM store s
JOIN inventory i ON i.store_id=s.store_id
JOIN rental r ON r.inventory_id=i.inventory_id
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1;

--What is the average rental revenue per transaction for each store?

SELECT s.store_id,r.rental_id,ROUND(AVG(p.amount),2) Average_Rev_Trans
FROM store s
JOIN inventory i ON i.store_id=s.store_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN payment p ON p.rental_id=r.rental_id
GROUP BY 1,2
ORDER BY 3 DESC;

--Which staff member has processed the most rentals?

SELECT s.staff_id,CONCAT(s.first_name,' ',s.last_name) Staff_Name,COUNT(r.rental_id) Total_Rentals
FROM staff s
JOIN rental r ON s.staff_id=r.staff_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

--How consistent the is the revenue across different stores?

SELECT var_pop(Total_Revenue) Store_Revenue_Variance
FROM (SELECT s.store_id,SUM(p.amount) Total_Revenue
FROM store s
JOIN inventory i ON i.store_id=s.store_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN payment p ON p.rental_id=r.rental_id
GROUP BY 1)sub;

--CATEGORY ANALYSIS

--What is the average rental duration for each film category?

SELECT f.film_id,f.title Title,c.name Category,ROUND(AVG(f.rental_duration),2) Avg_rental_Duration
FROM category c
JOIN film_category fc ON c.category_id=fc.category_id
JOIN film f ON f.film_id=fc.film_id
GROUP BY 1,2,3;

--Which film category generates the hightest revenue?

SELECT c.name Category,SUM(p.amount) Category_Total_Revenue
FROM category c
JOIN film_category fc ON c.category_id=fc.category_id
JOIN film f ON f.film_id=fc.film_id
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN payment p ON r.rental_id=p.rental_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--which category have the lowest rental rate?

SELECT c.name Category,COUNT(r.rental_id) Rentals
FROM category c
JOIN film_category fm ON c.category_id=fm.category_id
JOIN film f ON f.film_id=fm.film_id
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
GROUP BY 1
ORDER BY 2 ASC
LIMIT 3;

--How much does the rental revenue vary across different film categories?

SELECT ROUND(STDDEV(Total_Revenue),4) Category_Standard_Deviation
FROM(SELECT c.name Category,SUM(p.amount) Total_Revenue
FROM category c
JOIN film_category fc ON c.category_id=fc.category_id
JOIN film f ON f.film_id=fc.film_id
JOIN inventory i ON i.film_id=f.film_id
JOIN rental r ON r.inventory_id=i.inventory_id
JOIN payment p ON r.rental_id=p.rental_id
GROUP BY 1)sub;

--CUSTOMER BEHAVIOR & MARKETING 

--what is the demographic breakdown of the top 10 customers by revenue?

SELECT c.customer_id,CONCAT(c.first_name,' ',c.last_name) Customer_Name,ci.city,SUM(p.amount) Revenue
FROM customer c
JOIN payment p ON p.customer_id=c.customer_id
JOIN address a ON a.address_id=c.address_id
JOIN city ci ON ci.city_id=a.city_id
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 10;

--How many customers are repeat renters?

SELECT COUNT(*) Repeaters_Count
FROM(SELECT DISTINCT c.customer_id,COUNT(r.rental_id) Rentals
FROM customer c 
JOIN rental r ON r.customer_id=c.customer_id
GROUP BY 1
HAVING COUNT(r.rental_id)>1)sub;

