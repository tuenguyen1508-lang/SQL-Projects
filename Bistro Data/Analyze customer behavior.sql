-- Use both tables to understand how customers are reacting to the new menu

-- 1. Combine the menu_items and order_details tables into a single table
SELECT * FROM menu_items;
SELECT * FROM order_details;

SELECT *
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id;
-- 2. What were the least and most ordered items? What categories were they in?
SELECT item_name, category, COUNT(order_details_id) AS num_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
    GROUP BY item_name, category
    ORDER BY num_purchases DESC;

-- 3. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
    GROUP BY order_id
    ORDER BY total_spend DESC
    LIMIT 5;
    
-- 4. View the details of highest spent orders. What insights can you gather
SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id = '440'
GROUP BY category;

-- 5. View the details of the top 5 spend orders
SELECT category, order_id, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category,order_id;

-- note: In SQL, every column in the SELECT list must either: Appear in the GROUP BY, or Be inside an aggregate function like COUNT(), SUM(), AVG(), etc.