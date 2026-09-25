/**
 * NEXORA-AI — Inventory Route
 *
 * GET /api/inventory
 *
 * Returns inventory levels for all products,
 * with a computed `is_low_stock` flag.
 *
 * GET /api/inventory/low-stock
 *
 * Returns only products where current stock is
 * at or below the low-stock threshold.
 * This is a key feature for NEXORA's inventory monitoring.
 */

import { Router } from 'express';
import db from '../db/index.js';

const router = Router();

// GET /api/inventory
// Returns all inventory with product name and low-stock flag
router.get('/', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT
        i.id,
        p.name AS product_name,
        p.category,
        i.quantity,
        i.low_stock_threshold,
        (i.quantity <= i.low_stock_threshold) AS is_low_stock,
        i.last_restocked_at,
        i.updated_at
      FROM inventory i
      JOIN products p ON i.product_id = p.id
      ORDER BY i.quantity ASC
    `);

    res.json({
      count: result.rows.length,
      inventory: result.rows,
    });
  } catch (err) {
    console.error('[Inventory] Error fetching inventory:', err.message);
    res.status(500).json({ error: 'Failed to fetch inventory' });
  }
});

// GET /api/inventory/low-stock
// Returns only products that are at or below their low-stock threshold
router.get('/low-stock', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT
        i.id,
        p.name AS product_name,
        p.category,
        i.quantity,
        i.low_stock_threshold,
        i.last_restocked_at
      FROM inventory i
      JOIN products p ON i.product_id = p.id
      WHERE i.quantity <= i.low_stock_threshold
      ORDER BY i.quantity ASC
    `);

    res.json({
      count: result.rows.length,
      alert: result.rows.length > 0 ? `${result.rows.length} product(s) need restocking` : 'All stock levels are healthy',
      products: result.rows,
    });
  } catch (err) {
    console.error('[Inventory] Error fetching low-stock:', err.message);
    res.status(500).json({ error: 'Failed to fetch low-stock products' });
  }
});

export default router;
