-- ============================================================
-- NEXORA-AI — Seed Data (Phase 2)
--
-- Creates realistic test data for a small Indian general store.
-- Designed to exercise analytics queries:
-- - Products across multiple categories
-- - Varying inventory levels (including low-stock items)
-- - Multiple customers with different purchase patterns
-- - Sales spread across several days
-- - Diverse expenses for profit calculation
--
-- Run with: npm run db:setup
-- ============================================================

-- ============================================================
-- 1. MERCHANT
-- ============================================================
INSERT INTO merchants (id, business_name, owner_name, email, phone, business_type)
VALUES (
  'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
  'Sharma General Store',
  'Rajesh Sharma',
  'rajesh@sharmastore.com',
  '+91-9876543210',
  'Retail'
);

-- ============================================================
-- 2. PRODUCTS (10 products across 4 categories)
-- ============================================================
-- Using fixed UUIDs so sale_items can reference them reliably.

-- Groceries
INSERT INTO products (id, merchant_id, name, description, cost_price, selling_price, category, unit)
VALUES
  ('p0000001-0000-0000-0000-000000000001', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Basmati Rice (5kg)', 'Premium aged basmati rice', 280.00, 350.00, 'Groceries', 'pack'),

  ('p0000001-0000-0000-0000-000000000002', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Toor Dal (1kg)', 'Unpolished toor dal', 110.00, 145.00, 'Groceries', 'pack'),

  ('p0000001-0000-0000-0000-000000000003', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Sunflower Oil (1L)', 'Refined sunflower cooking oil', 130.00, 165.00, 'Groceries', 'bottle');

-- Beverages
INSERT INTO products (id, merchant_id, name, description, cost_price, selling_price, category, unit)
VALUES
  ('p0000001-0000-0000-0000-000000000004', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Green Tea (25 bags)', 'Organic green tea bags', 95.00, 150.00, 'Beverages', 'box'),

  ('p0000001-0000-0000-0000-000000000005', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Cold Coffee (200ml)', 'Ready-to-drink cold coffee', 25.00, 40.00, 'Beverages', 'piece');

-- Personal Care
INSERT INTO products (id, merchant_id, name, description, cost_price, selling_price, category, unit)
VALUES
  ('p0000001-0000-0000-0000-000000000006', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Hand Soap (250ml)', 'Antibacterial liquid hand soap', 55.00, 80.00, 'Personal Care', 'bottle'),

  ('p0000001-0000-0000-0000-000000000007', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Toothpaste (150g)', 'Fluoride toothpaste', 65.00, 95.00, 'Personal Care', 'piece');

-- Snacks
INSERT INTO products (id, merchant_id, name, description, cost_price, selling_price, category, unit)
VALUES
  ('p0000001-0000-0000-0000-000000000008', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Masala Chips (100g)', 'Spicy potato chips', 15.00, 20.00, 'Snacks', 'pack'),

  ('p0000001-0000-0000-0000-000000000009', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Dark Chocolate (100g)', 'Premium 70% cocoa dark chocolate', 80.00, 120.00, 'Snacks', 'piece'),

  ('p0000001-0000-0000-0000-000000000010', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Mixed Nuts (250g)', 'Roasted and salted mixed nuts', 180.00, 250.00, 'Snacks', 'pack');

-- ============================================================
-- 3. INVENTORY (varying stock levels)
-- ============================================================
-- Some products are well-stocked, some are low, one is critically low.
-- This lets us test low-stock detection queries.

INSERT INTO inventory (product_id, quantity, low_stock_threshold, last_restocked_at)
VALUES
  ('p0000001-0000-0000-0000-000000000001', 45,  10, NOW() - INTERVAL '3 days'),    -- Rice: well stocked
  ('p0000001-0000-0000-0000-000000000002', 30,  10, NOW() - INTERVAL '5 days'),    -- Dal: well stocked
  ('p0000001-0000-0000-0000-000000000003', 8,   10, NOW() - INTERVAL '12 days'),   -- Oil: LOW STOCK
  ('p0000001-0000-0000-0000-000000000004', 15,  5,  NOW() - INTERVAL '7 days'),    -- Tea: ok
  ('p0000001-0000-0000-0000-000000000005', 3,   10, NOW() - INTERVAL '14 days'),   -- Coffee: CRITICALLY LOW
  ('p0000001-0000-0000-0000-000000000006', 22,  10, NOW() - INTERVAL '4 days'),    -- Soap: ok
  ('p0000001-0000-0000-0000-000000000007', 9,   10, NOW() - INTERVAL '10 days'),   -- Toothpaste: LOW STOCK
  ('p0000001-0000-0000-0000-000000000008', 60,  15, NOW() - INTERVAL '2 days'),    -- Chips: well stocked
  ('p0000001-0000-0000-0000-000000000009', 12,  5,  NOW() - INTERVAL '6 days'),    -- Chocolate: ok
  ('p0000001-0000-0000-0000-000000000010', 5,   8,  NOW() - INTERVAL '11 days'));  -- Nuts: LOW STOCK

-- ============================================================
-- 4. CUSTOMERS (5 regular customers)
-- ============================================================
INSERT INTO customers (id, merchant_id, name, email, phone)
VALUES
  ('c0000001-0000-0000-0000-000000000001', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Priya Patel', 'priya@email.com', '+91-9111111111'),

  ('c0000001-0000-0000-0000-000000000002', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Amit Kumar', 'amit@email.com', '+91-9222222222'),

  ('c0000001-0000-0000-0000-000000000003', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Sneha Gupta', 'sneha@email.com', '+91-9333333333'),

  ('c0000001-0000-0000-0000-000000000004', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Vikram Singh', NULL, '+91-9444444444'),

  ('c0000001-0000-0000-0000-000000000005', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
   'Meera Joshi', 'meera@email.com', NULL);

-- ============================================================
-- 5. SALES (8 sales over the past week)
-- ============================================================
-- Mix of registered customers and walk-ins (NULL customer_id).
-- Different payment methods. Spread across several days.

-- Sale 1: Priya buys groceries (2 days ago)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000001', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'c0000001-0000-0000-0000-000000000001', 660.00, 'upi', NOW() - INTERVAL '2 days');

-- Sale 2: Walk-in buys snacks (2 days ago)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000002', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        NULL, 60.00, 'cash', NOW() - INTERVAL '2 days');

-- Sale 3: Amit buys personal care + beverage (1 day ago)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000003', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'c0000001-0000-0000-0000-000000000002', 325.00, 'card', NOW() - INTERVAL '1 day');

-- Sale 4: Sneha buys groceries (1 day ago)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000004', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'c0000001-0000-0000-0000-000000000003', 495.00, 'upi', NOW() - INTERVAL '1 day');

-- Sale 5: Vikram buys snacks and chocolate (today)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000005', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'c0000001-0000-0000-0000-000000000004', 390.00, 'cash', NOW());

-- Sale 6: Walk-in buys cold coffee (today)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000006', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        NULL, 80.00, 'cash', NOW());

-- Sale 7: Priya returns for more groceries (today) — repeat customer!
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000007', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'c0000001-0000-0000-0000-000000000001', 500.00, 'upi', NOW());

-- Sale 8: Meera buys tea and nuts (3 days ago)
INSERT INTO sales (id, merchant_id, customer_id, total_amount, payment_method, sale_date)
VALUES ('s0000001-0000-0000-0000-000000000008', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        'c0000001-0000-0000-0000-000000000005', 400.00, 'card', NOW() - INTERVAL '3 days');

-- ============================================================
-- 6. SALE_ITEMS (line items for each sale)
-- ============================================================

-- Sale 1: Priya — Rice + Dal (₹350 + ₹145 + ₹165 = ₹660)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000001', 1, 350.00, 350.00),
  ('s0000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000002', 1, 145.00, 145.00),
  ('s0000001-0000-0000-0000-000000000001', 'p0000001-0000-0000-0000-000000000003', 1, 165.00, 165.00);

-- Sale 2: Walk-in — Chips x3 (3 × ₹20 = ₹60)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000002', 'p0000001-0000-0000-0000-000000000008', 3, 20.00, 60.00);

-- Sale 3: Amit — Soap + Toothpaste + Green Tea (₹80 + ₹95 + ₹150 = ₹325)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000006', 1, 80.00, 80.00),
  ('s0000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000007', 1, 95.00, 95.00),
  ('s0000001-0000-0000-0000-000000000003', 'p0000001-0000-0000-0000-000000000004', 1, 150.00, 150.00);

-- Sale 4: Sneha — Rice + Dal (₹350 + ₹145 = ₹495)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000004', 'p0000001-0000-0000-0000-000000000001', 1, 350.00, 350.00),
  ('s0000001-0000-0000-0000-000000000004', 'p0000001-0000-0000-0000-000000000002', 1, 145.00, 145.00);

-- Sale 5: Vikram — Chocolate ×2 + Green Tea ×1 (₹240 + ₹150 = ₹390)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000005', 'p0000001-0000-0000-0000-000000000009', 2, 120.00, 240.00),
  ('s0000001-0000-0000-0000-000000000005', 'p0000001-0000-0000-0000-000000000004', 1, 150.00, 150.00);

-- Sale 6: Walk-in — Cold Coffee ×2 (2 × ₹40 = ₹80)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000006', 'p0000001-0000-0000-0000-000000000005', 2, 40.00, 80.00);

-- Sale 7: Priya (repeat) — Rice ×1 + Green Tea ×1 (₹350 + ₹150 = ₹500)
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000007', 'p0000001-0000-0000-0000-000000000001', 1, 350.00, 350.00),
  ('s0000001-0000-0000-0000-000000000007', 'p0000001-0000-0000-0000-000000000004', 1, 150.00, 150.00);

-- Sale 8: Meera — Green Tea ×1 + Nuts ×1 (₹150 + ₹250 = ₹400) ✓
INSERT INTO sale_items (sale_id, product_id, quantity, unit_price, subtotal)
VALUES
  ('s0000001-0000-0000-0000-000000000008', 'p0000001-0000-0000-0000-000000000004', 1, 150.00, 150.00),
  ('s0000001-0000-0000-0000-000000000008', 'p0000001-0000-0000-0000-000000000010', 1, 250.00, 250.00);

-- ============================================================
-- 7. EXPENSES (business costs over the past month)
-- ============================================================
-- Multiple categories for expense breakdown analytics.

INSERT INTO expenses (merchant_id, category, amount, description, expense_date)
VALUES
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Rent',       15000.00, 'Monthly shop rent',                    CURRENT_DATE - INTERVAL '5 days'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Utilities',   2200.00, 'Electricity bill for September',        CURRENT_DATE - INTERVAL '4 days'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Salary',      8000.00, 'Part-time helper salary',               CURRENT_DATE - INTERVAL '3 days'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Supplies',     450.00, 'Carry bags, packaging material',        CURRENT_DATE - INTERVAL '2 days'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Transport',   1200.00, 'Goods delivery from wholesaler',        CURRENT_DATE - INTERVAL '1 day'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567890', 'Maintenance',  800.00, 'AC servicing and minor repairs',        CURRENT_DATE);

-- ============================================================
-- Seed Summary:
-- - 1 merchant (Sharma General Store)
-- - 10 products (4 categories: Groceries, Beverages, Personal Care, Snacks)
-- - 10 inventory records (3 low-stock, 1 critically low)
-- - 5 customers
-- - 8 sales (across 4 days, 3 payment methods, 2 walk-ins)
-- - 17 sale items
-- - 6 expenses (6 categories)
-- - Total revenue: ₹2,910
-- - Total expenses: ₹27,650
-- ============================================================
