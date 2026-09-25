-- ============================================================
-- NEXORA-AI — Database Schema (Phase 2)
--
-- This file creates all 7 core tables for the MVP.
-- Run with: npm run db:setup
--
-- Tables are created in dependency order:
-- 1. merchants     (no dependencies)
-- 2. products      (depends on merchants)
-- 3. inventory     (depends on products)
-- 4. customers     (depends on merchants)
-- 5. sales         (depends on merchants, customers)
-- 6. sale_items    (depends on sales, products)
-- 7. expenses      (depends on merchants)
--
-- DROP TABLE order is reversed to respect foreign keys.
-- ============================================================

-- Drop tables if they exist (reverse dependency order)
DROP TABLE IF EXISTS sale_items CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS expenses CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS merchants CASCADE;

-- ============================================================
-- 1. MERCHANTS — The root entity
-- ============================================================
-- Every other table belongs to a merchant.
-- This enables multi-tenant data isolation.
CREATE TABLE merchants (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  business_name   VARCHAR(255) NOT NULL,
  owner_name      VARCHAR(255) NOT NULL,
  email           VARCHAR(255) UNIQUE,
  phone           VARCHAR(20),
  business_type   VARCHAR(100),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 2. PRODUCTS — What the merchant sells
-- ============================================================
-- cost_price and selling_price enable profit margin calculation.
-- category enables grouping for analytics dashboards.
-- is_active enables soft-delete (hide without losing data).
CREATE TABLE products (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  name            VARCHAR(255) NOT NULL,
  description     TEXT,
  cost_price      DECIMAL(10,2) NOT NULL CHECK (cost_price >= 0),
  selling_price   DECIMAL(10,2) NOT NULL CHECK (selling_price >= 0),
  category        VARCHAR(100),
  unit            VARCHAR(50) DEFAULT 'piece',
  is_active       BOOLEAN DEFAULT true,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 3. INVENTORY — Stock levels for each product
-- ============================================================
-- Separate from products because stock changes on every sale/restock.
-- low_stock_threshold enables automated low-stock alerts.
-- last_restocked_at tracks restocking patterns for demand forecasting.
CREATE TABLE inventory (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id            UUID NOT NULL UNIQUE REFERENCES products(id) ON DELETE CASCADE,
  quantity              INTEGER NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  low_stock_threshold   INTEGER NOT NULL DEFAULT 10,
  last_restocked_at     TIMESTAMPTZ,
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 4. CUSTOMERS — Who buys from the merchant
-- ============================================================
-- Tracks customer information for purchase history and analysis.
-- customer_id on sales is nullable (walk-in customers).
CREATE TABLE customers (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  name            VARCHAR(255) NOT NULL,
  email           VARCHAR(255),
  phone           VARCHAR(20),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 5. SALES — Each transaction/purchase
-- ============================================================
-- customer_id is nullable: walk-in customers don't have IDs.
-- total_amount is denormalized from sale_items for fast dashboard queries.
-- payment_method tracks how the customer paid (cash, card, upi).
-- sale_date is the business timestamp; created_at is the record timestamp.
CREATE TABLE sales (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  customer_id     UUID REFERENCES customers(id) ON DELETE SET NULL,
  total_amount    DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
  payment_method  VARCHAR(50) DEFAULT 'cash',
  sale_date       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- 6. SALE_ITEMS — Line items within a sale (junction table)
-- ============================================================
-- Resolves the many-to-many between sales and products.
-- unit_price stores the price AT TIME OF SALE (prices change over time).
-- subtotal = quantity × unit_price (denormalized for fast reports).
CREATE TABLE sale_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sale_id         UUID NOT NULL REFERENCES sales(id) ON DELETE CASCADE,
  product_id      UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity        INTEGER NOT NULL CHECK (quantity > 0),
  unit_price      DECIMAL(10,2) NOT NULL,
  subtotal        DECIMAL(10,2) NOT NULL
);

-- ============================================================
-- 7. EXPENSES — Business costs
-- ============================================================
-- Combined with sales data, enables profit calculation:
-- Profit = Revenue (from sales) − Expenses
-- category enables expense breakdown (rent, utilities, salary).
CREATE TABLE expenses (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  merchant_id     UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
  category        VARCHAR(100) NOT NULL,
  amount          DECIMAL(10,2) NOT NULL CHECK (amount > 0),
  description     TEXT,
  expense_date    DATE NOT NULL,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- INDEXES
-- ============================================================
-- These speed up the most common queries:
-- filtering by merchant, looking up sales by date, etc.

CREATE INDEX idx_products_merchant ON products(merchant_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_customers_merchant ON customers(merchant_id);
CREATE INDEX idx_sales_merchant ON sales(merchant_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sale_items_sale ON sale_items(sale_id);
CREATE INDEX idx_sale_items_product ON sale_items(product_id);
CREATE INDEX idx_expenses_merchant ON expenses(merchant_id);
CREATE INDEX idx_expenses_date ON expenses(expense_date);
