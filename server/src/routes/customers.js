/**
 * NEXORA-AI — Customers Route
 *
 * GET /api/customers
 *
 * Returns all customers for the merchant.
 * In future phases, this will include purchase history
 * and customer lifetime value calculations.
 */

import { Router } from 'express';
import db from '../db/index.js';

const router = Router();

// GET /api/customers
// Returns all customers, ordered by name
router.get('/', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT
        id,
        name,
        email,
        phone,
        created_at
      FROM customers
      ORDER BY name
    `);

    res.json({
      count: result.rows.length,
      customers: result.rows,
    });
  } catch (err) {
    console.error('[Customers] Error fetching customers:', err.message);
    res.status(500).json({ error: 'Failed to fetch customers' });
  }
});

export default router;
