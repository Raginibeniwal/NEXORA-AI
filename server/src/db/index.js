/**
 * NEXORA-AI — Database Connection Module
 *
 * This file creates a PostgreSQL connection pool and exports
 * helper functions for running queries.
 *
 * Why a pool?
 * Opening a new database connection for every query is slow.
 * A pool keeps a set of connections open and reuses them.
 * pg.Pool handles this automatically.
 *
 * Usage in route files:
 *   import db from '../db/index.js';
 *   const result = await db.query('SELECT * FROM products');
 *   const rows = result.rows;
 *
 * Usage for cleanup (e.g., in setup scripts):
 *   import { pool } from '../db/index.js';
 *   await pool.end(); // closes all connections
 */

import pg from 'pg';
import config from '../config/index.js';

const { Pool } = pg;

// Create the connection pool using individual parameters from config
// The pool manages multiple connections and reuses them efficiently
const pool = new Pool({
  host: config.db.host,
  port: config.db.port,
  database: config.db.name,
  user: config.db.user,
  password: config.db.password,
});

// Log when a new client connects (helpful during development)
pool.on('connect', () => {
  if (config.isDev) {
    console.log('[DB] New client connected to PostgreSQL');
  }
});

// Log pool errors (e.g., connection lost)
// Without this handler, unhandled pool errors crash the process
pool.on('error', (err) => {
  console.error('[DB] Unexpected pool error:', err.message);
});

/**
 * Run a SQL query against the database.
 *
 * @param {string} text - The SQL query string (use $1, $2 for parameters)
 * @param {Array} params - Parameter values (prevents SQL injection)
 * @returns {Promise<pg.QueryResult>} The query result
 *
 * Example:
 *   const result = await db.query('SELECT * FROM products WHERE id = $1', [productId]);
 */
const query = (text, params) => pool.query(text, params);

// Default export: the query function (most common use case)
// Named export: the pool itself (for scripts that need to close it)
export { pool };
export default { query, pool };
