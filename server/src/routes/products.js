/**
 * NEXORA-AI — Products Route
 *
 * GET /api/products
 *
 * Returns all active products for the merchant,
 * including their category and pricing.
 *
 * This is one of the core data endpoints that will
 * feed the dashboard and AI analytics in later phases.
 */

import { Router } from 'express';
import db from '../db/index.js';

const router = Router();

// GET /api/products
// Returns all active products, ordered by category then name
router.get('/', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT
        id,
        name,
        description,
        cost_price,
        selling_price,
        category,
        unit,
        is_active,
        created_at
      FROM products
      WHERE is_active = true
      ORDER BY category, name
    `);

    res.json({
      count: result.rows.length,
      products: result.rows,
    });
  } catch (err) {
    console.error('[Products] Error fetching products:', err.message);
    res.status(500).json({ error: 'Failed to fetch products' });
  }
});

export default router;
