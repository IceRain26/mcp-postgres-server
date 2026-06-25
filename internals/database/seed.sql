-- =============================================
-- SCHEMA: E-commerce Database
-- =============================================

-- Drop tables if they exist (clean slate)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- 1. Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    country TEXT NOT NULL,
    registered_at TIMESTAMP DEFAULT NOW()
);

-- 2. Products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 3. Orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT NOW(),
    total_amount DECIMAL(10, 2) NOT NULL,
    status TEXT CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')) DEFAULT 'pending'
);

-- 4. Order items table (join table for many-to-many between orders and products)
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    price_at_time DECIMAL(10, 2) NOT NULL  -- Saves the product price at the time of order
);

-- =============================================
-- SEED DATA
-- =============================================

-- Insert 10 users
INSERT INTO users (first_name, last_name, email, country, registered_at) VALUES
('Alice', 'Johnson', 'alice.j@email.com', 'USA', '2025-01-15 10:30:00'),
('Bob', 'Smith', 'bob.smith@email.com', 'UK', '2025-02-20 14:45:00'),
('Charlie', 'Brown', 'charlie.b@email.com', 'Canada', '2025-03-01 09:00:00'),
('Diana', 'Prince', 'diana.p@email.com', 'USA', '2025-03-15 16:20:00'),
('Eve', 'Davis', 'eve.davis@email.com', 'Australia', '2025-04-01 11:10:00'),
('Frank', 'Wilson', 'frank.w@email.com', 'Germany', '2025-04-10 13:30:00'),
('Grace', 'Lee', 'grace.lee@email.com', 'South Korea', '2025-05-05 08:45:00'),
('Henry', 'Taylor', 'henry.t@email.com', 'UK', '2025-05-20 17:00:00'),
('Ivy', 'Martinez', 'ivy.m@email.com', 'Mexico', '2025-06-01 12:15:00'),
('Jack', 'Anderson', 'jack.a@email.com', 'USA', '2025-06-15 19:30:00');

-- Insert 20 products across 4 categories
INSERT INTO products (name, category, price, stock_quantity, created_at) VALUES
-- Electronics
('Wireless Headphones Pro', 'Electronics', 79.99, 150, '2025-01-01 10:00:00'),
('Bluetooth Speaker X', 'Electronics', 45.50, 200, '2025-01-05 12:00:00'),
('Smart Watch V3', 'Electronics', 199.00, 80, '2025-02-01 09:00:00'),
('USB-C Dock Station', 'Electronics', 120.00, 60, '2025-02-15 14:00:00'),
('Gaming Mechanical Keyboard', 'Electronics', 89.99, 45, '2025-03-01 11:00:00'),

-- Clothing
('Running Sneakers', 'Clothing', 65.00, 120, '2025-01-10 10:00:00'),
('Wool Winter Jacket', 'Clothing', 150.00, 40, '2025-02-10 09:30:00'),
('Cotton T-Shirt (Pack of 3)', 'Clothing', 24.99, 300, '2025-03-05 15:00:00'),
('Denim Jeans - Slim Fit', 'Clothing', 59.99, 90, '2025-04-01 08:00:00'),
('Leather Boots', 'Clothing', 120.00, 35, '2025-05-01 16:00:00'),

-- Home & Kitchen
('Stainless Steel Cookware Set', 'Home', 250.00, 25, '2025-01-20 10:00:00'),
('Coffee Maker Deluxe', 'Home', 89.99, 50, '2025-02-20 11:00:00'),
('4K Action Camera', 'Electronics', 99.99, 70, '2025-03-10 13:00:00'),
('Memory Foam Pillow', 'Home', 39.99, 100, '2025-04-10 14:00:00'),
('Robot Vacuum Cleaner', 'Home', 299.00, 15, '2025-05-10 09:00:00'),

-- Books
('Mastering Go Programming', 'Books', 45.00, 200, '2025-01-25 10:00:00'),
('The Art of AI', 'Books', 30.00, 150, '2025-02-25 12:00:00'),
('Designing Data-Intensive Apps', 'Books', 65.00, 80, '2025-03-20 09:00:00'),
('Clean Code: A Handbook', 'Books', 52.00, 110, '2025-04-20 16:00:00'),
('Cloud Native Patterns', 'Books', 48.00, 60, '2025-05-20 11:00:00');

-- Insert 50 orders spread across June 2025 - June 2026
INSERT INTO orders (user_id, order_date, total_amount, status) VALUES
-- June 2025
(1, '2025-06-01 10:00:00', 79.99, 'delivered'),
(2, '2025-06-01 14:00:00', 45.50, 'delivered'),
(3, '2025-06-03 09:00:00', 89.99, 'delivered'),
(4, '2025-06-05 16:00:00', 199.00, 'delivered'),
(5, '2025-06-07 11:00:00', 65.00, 'shipped'),
(1, '2025-06-10 13:00:00', 250.00, 'delivered'),
(2, '2025-06-12 08:00:00', 120.00, 'shipped'),
(6, '2025-06-15 17:00:00', 45.00, 'delivered'),
(7, '2025-06-18 10:30:00', 30.00, 'processing'),
(8, '2025-06-20 15:00:00', 150.00, 'delivered'),
(9, '2025-06-22 12:00:00', 59.99, 'pending'),
(10, '2025-06-25 09:00:00', 299.00, 'shipped'),
(3, '2025-06-28 14:00:00', 24.99, 'delivered'),
(4, '2025-06-30 11:00:00', 99.99, 'delivered'),
(5, '2025-06-30 18:00:00', 39.99, 'delivered'),
-- July 2025
(6, '2025-07-02 10:00:00', 65.00, 'delivered'),
(7, '2025-07-05 09:00:00', 120.00, 'shipped'),
(8, '2025-07-08 13:00:00', 89.99, 'delivered'),
(9, '2025-07-10 16:00:00', 199.00, 'processing'),
(10, '2025-07-12 11:00:00', 79.99, 'delivered'),
(1, '2025-07-15 14:00:00', 52.00, 'delivered'),
(2, '2025-07-18 08:00:00', 250.00, 'cancelled'),
(3, '2025-07-20 17:00:00', 45.50, 'delivered'),
(4, '2025-07-22 10:30:00', 30.00, 'shipped'),
(5, '2025-07-25 15:00:00', 120.00, 'delivered'),
-- Aug 2025 - Jan 2026 (sparse to show time range)
(6, '2025-08-01 09:00:00', 150.00, 'delivered'),
(7, '2025-08-10 11:00:00', 65.00, 'delivered'),
(8, '2025-09-05 14:00:00', 299.00, 'delivered'),
(9, '2025-09-15 10:00:00', 89.99, 'shipped'),
(10, '2025-10-01 16:00:00', 199.00, 'delivered'),
(1, '2025-10-20 08:00:00', 45.00, 'delivered'),
(2, '2025-11-11 13:00:00', 79.99, 'processing'),
(3, '2025-12-01 09:00:00', 120.00, 'delivered'),
(4, '2025-12-15 17:00:00', 250.00, 'shipped'),
(5, '2025-12-25 12:00:00', 24.99, 'delivered'),
-- 2026 (recent)
(6, '2026-01-05 10:00:00', 59.99, 'delivered'),
(7, '2026-01-15 14:00:00', 99.99, 'delivered'),
(8, '2026-02-01 09:00:00', 150.00, 'delivered'),
(9, '2026-02-14 16:00:00', 45.50, 'shipped'),
(10, '2026-03-01 11:00:00', 199.00, 'processing'),
(1, '2026-03-20 13:00:00', 52.00, 'delivered'),
(2, '2026-04-05 08:00:00', 65.00, 'delivered'),
(3, '2026-04-18 17:00:00', 120.00, 'delivered'),
(4, '2026-05-01 10:30:00', 299.00, 'shipped'),
(5, '2026-05-15 15:00:00', 89.99, 'delivered'),
(6, '2026-06-01 09:00:00', 79.99, 'pending'),
(7, '2026-06-05 14:00:00', 45.00, 'processing'),
(8, '2026-06-10 11:00:00', 250.00, 'pending'),
(9, '2026-06-15 18:00:00', 30.00, 'shipped'),
(10, '2026-06-20 10:00:00', 99.99, 'pending');

-- Insert 100+ order items (connecting orders to products with quantities)
INSERT INTO order_items (order_id, product_id, quantity, price_at_time)
SELECT 
    o.id AS order_id,
    p.id AS product_id,
    FLOOR(RANDOM() * 3 + 1)::INT AS quantity,
    p.price AS price_at_time
FROM orders o
CROSS JOIN LATERAL (
    SELECT id, price FROM products ORDER BY RANDOM() LIMIT FLOOR(RANDOM() * 3 + 1)::INT
) p
WHERE RANDOM() > 0.2  -- Ensure most orders have items (some might have 0, but we skip those)
LIMIT 120;  -- Generate ~120 order items across the orders