/**
 * NEXORA-AI — Sales Route
 *
 * GET /api/sales
 *
 * Returns all sales with customer name (if not a walk-in)
 * and a summary of total revenue.
 *
 * GET /api/sales/revenue
 *
 * Returns the total revenue calculated from all sales.
 * This is the first analytics endpoint — a preview of
 * what NEXORA's AI dashboard will surface.
 */

import { Router } from 'express';
import db from '../db/index.js';

const router = Router();

// GET /api/sales
// Returns all sales with optional customer name, newest first
router.get('/', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT
        s.id,
        s.total_amount,
        s.payment_method,
        s.sale_date,
        c.name AS customer_name
      FROM sales s
      LEFT JOIN customers c ON s.customer_id = c.id
      ORDER BY s.sale_date DESC
    `);

    res.json({
      count: result.rows.length,
      sales: result.rows,
    });
  } catch (err) {
    console.error('[Sales] Error fetching sales:', err.message);
    res.status(500).json({ error: 'Failed to fetch sales' });
  }
});

// GET /api/sales/revenue
// Returns total revenue from all sales
router.get('/revenue', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT
        COUNT(*) AS total_sales,
        COALESCE(SUM(total_amount), 0) AS total_revenue
      FROM sales
    `);

    res.json({
      total_sales: parseInt(result.rows[0].total_sales),
      total_revenue: parseFloat(result.rows[0].total_revenue),
    });
  } catch (err) {
    console.error('[Sales] Error calculating revenue:', err.message);
    res.status(500).json({ error: 'Failed to calculate revenue' });
  }
});

export default router;
