CREATE TYPE u_role as enum('buyer','seller','admin'); 

create table Users(
	user_ID serial primary key,
	name text not null,
	Email varchar(255) unique,
	address text,
	phone_number bigint,
	registration_date date,
	user_role u_role
);

INSERT INTO Users (name, Email, address, phone_number, registration_date, user_role)  
VALUES   
('Alice', 'alice@example.com', '123 Main St', 1234567890, '2023-01-01', 'buyer'),  
('Bob', 'bob@example.com', '456 Side St', 9876543210, '2023-02-01', 'seller'),  
('Charlie', 'charlie@example.com', '789 Center Ave', 5432167890, '2023-01-15', 'buyer'),  
('Diana', 'diana@example.com', '321 North St', 3216549870, '2023-02-20', 'buyer'),  
('Ethan', 'ethan@example.com', '654 East Blvd', 9871234560, '2023-03-10', 'seller'),  
('Fiona', 'fiona@example.com', '987 West Rd', 6549873210, '2023-03-15', 'admin'); 

select * from Users;

create table Categories(
	Category_ID serial primary key,
	Category_name varchar not null
);

INSERT INTO Categories (Category_name)  
VALUES   
('Electronics'),   
('Books'),   
('Clothing'),   
('Home Appliances'),   
('Sports Equipment'),   
('Toys');

select * from Categories;

create table products(
	product_ID serial primary key,
	name text not null,
	Description text,
	price integer,
	Stock_Quantity integer,
	Creation_Date date,
	category_ID int REFERENCES Categories(Category_ID),
	seller_ID int REFERENCES users(user_id)
);

INSERT INTO Products (name, Description, price, Stock_Quantity, Creation_Date, category_ID, seller_ID)  
VALUES   
('Laptop', 'High-performance laptop', 1000, 50, '2023-03-01', 1, 2),  
('Novel', 'Best selling novel', 20, 100, '2023-03-05', 2, 1),  
('T-shirt', 'Casual cotton t-shirt', 15, 200, '2023-03-10', 3, 2),  
('Blender', 'High-speed blender', 50, 30, '2023-03-12', 4, 2),  
('Soccer Ball', 'Official size soccer ball', 25, 150, '2023-03-15', 5, 2),  
('Puzzle', '1000-piece puzzle', 30, 80, '2023-03-20', 6, 1),  
('Headphones', 'Noise-cancelling headphones', 150, 40, '2023-03-22', 1, 2),  
('Jacket', 'Winter jacket', 75, 120, '2023-03-25', 3, 2);

select * from products;

CREATE TYPE status as enum('pending', 'shipped', 'delivered', 'canceled'); 
CREATE TYPE p_status as enum('pending', 'completed', 'failed');

create table Orders(
	Order_ID serial primary key,
	buyer_id int REFERENCES Users (user_ID),
	name text not null,
	order_Date date,
	status status,
	Payment_Status p_status
	
);

INSERT INTO Orders (buyer_id, name, order_Date, status, Payment_Status)  
VALUES   
(1, 'Order for Laptop', '2023-04-01', 'pending', 'pending'),  
(2, 'Order for Novel', '2023-04-02', 'shipped', 'completed'),  
(3, 'Order for T-shirt', '2023-04-03', 'pending', 'pending'),  
(1, 'Order for Blender', '2023-04-04', 'delivered', 'completed'),  
(4, 'Order for Soccer Ball', '2023-04-05', 'pending', 'pending'),  
(5, 'Order for Puzzle', '2023-04-06', 'shipped', 'completed');

select * from Orders;

create table Order_Products(
	Order_Product_ID serial primary key,
	order_ID int REFERENCES orders (order_ID),
	product_ID int REFERENCES products (product_ID),
	Quantity integer
	
);

INSERT INTO Order_Products (order_ID, product_ID, Quantity)  
VALUES   
(1, 1, 1),  -- 1  
(2, 2, 2),  -- 2   
(3, 3, 3),  -- 3   
(4, 4, 1),  -- 1    
(5, 5, 1),  -- 1    
(6, 6, 2);  -- 2 

select * from Order_Products;

CREATE TYPE p_method as enum('credit_card', 'PayPal', 'bank_transfer');

create table Payments(
	Payments_ID serial primary key,
	order_ID int REFERENCES orders(order_ID),
	Payments_amount integer,
	Payments_date date,
	Payments_method p_method
	
);

INSERT INTO Payments (Payments_amount, Payments_date, Payments_method, order_ID)  
VALUES   
(1020, '2023-04-02', 'credit_card', 1),  
(40, '2023-04-03', 'PayPal', 2),  
(45, '2023-04-04', 'bank_transfer', 4),  
(25, '2023-04-05', 'credit_card', 5),  
(60, '2023-04-06', 'PayPal', 6); 

select * from Payments;

CREATE TYPE rating as enum('1', '2', '3','4','5');

create table Reviews(
	Reviews_ID serial primary key,
	product_ID int REFERENCES products (product_ID),
	user_ID int REFERENCES users (user_ID),
	rating rating,
	review_comment rating,
	review_date date
	
);
alter table reviews
alter column review_comment type text;

INSERT INTO Reviews (rating, review_comment, review_date, product_ID, user_ID)  
VALUES   
('5', 'Excellent product!', '2023-04-03', 1, 1),   
('4', 'Good book but a bit long.', '2023-04-04', 2, 1),  
('5', 'Very comfortable!', '2023-04-05', 3, 1),     
('3', 'Blender works well, but a bit noisy.', '2023-04-06', 4, 2),      
('4', 'Great for outdoor games!', '2023-04-07', 5, 3),        
('5', 'Challenging and fun!', '2023-04-08', 6, 4);

select * from Reviews;

SELECT p.product_ID, p.name, SUM(op.Quantity) AS total_quantity_sold
FROM products p
JOIN Order_Products op ON p.product_ID = op.product_ID
GROUP BY p.product_ID, p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;


SELECT 
    o.Order_ID,
    o.order_Date,
    o.status AS order_status,
    o.Payment_Status,
    op.product_ID,
    p.name AS product_name,
    op.Quantity,
    (op.Quantity * p.price) AS product_total_price,
    SUM(op.Quantity * p.price) OVER(PARTITION BY o.Order_ID) AS total_order_amount
FROM Orders o
JOIN Order_Products op ON o.Order_ID = op.order_ID
JOIN Products p ON op.product_ID = p.product_ID
WHERE o.buyer_id = 3; 


SELECT 
    p.category_ID,
    c.Category_name,
    p.product_ID,
    p.name AS product_name,
    AVG(
        CASE 
            WHEN r.rating = '1' THEN 1
            WHEN r.rating = '2' THEN 2
            WHEN r.rating = '3' THEN 3
            WHEN r.rating = '4' THEN 4
            WHEN r.rating = '5' THEN 5
        END
    ) AS avg_rating
FROM Products p
JOIN Reviews r ON p.product_ID = r.product_ID
JOIN Categories c ON p.category_ID = c.Category_ID
GROUP BY p.category_ID, c.Category_name, p.product_ID, p.name
HAVING AVG(
        CASE 
            WHEN r.rating = '1' THEN 1
            WHEN r.rating = '2' THEN 2
            WHEN r.rating = '3' THEN 3
            WHEN r.rating = '4' THEN 4
            WHEN r.rating = '5' THEN 5
        END
    ) >= 4.0
ORDER BY p.category_ID, avg_rating DESC;


UPDATE Products
SET Stock_Quantity = Stock_Quantity - 2
WHERE product_ID = 1 AND Stock_Quantity >= 2;


SELECT 
    u.user_ID AS seller_id,
    u.name AS seller_name,
    SUM(op.Quantity * p.price) AS total_sales_amount
FROM Users u
JOIN Products p ON u.user_ID = p.seller_ID
JOIN Order_Products op ON p.product_ID = op.product_ID
JOIN Orders o ON op.order_ID = o.Order_ID
WHERE EXTRACT(MONTH FROM o.order_Date) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM o.order_Date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY u.user_ID, u.name
ORDER BY total_sales_amount DESC;

