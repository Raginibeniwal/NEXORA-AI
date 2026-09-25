/**
 * NEXORA-AI — Database Setup Script
 *
 * This script initializes the database by:
 * 1. Connecting to PostgreSQL
 * 2. Running schema.sql (creates all tables)
 * 3. Running seed.sql (inserts test data)
 *
 * Run with: npm run db:setup
 *
 * Prerequisites:
 * - PostgreSQL must be running
 * - The database specified in DATABASE_URL must exist
 * - DATABASE_URL must be set in server/.env
 *
 * This script is idempotent: it drops existing tables before
 * recreating them (see DROP TABLE statements in schema.sql).
 */

// Load .env first (same pattern as index.js)
import 'dotenv/config';

import { readFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';
import { pool } from './index.js';

// ES Module equivalent of __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

/**
 * Read a .sql file and execute it against the database.
 * @param {string} filename - Name of the SQL file (e.g., 'schema.sql')
 */
async function runSQLFile(filename) {
  const filePath = join(__dirname, filename);
  const sql = readFileSync(filePath, 'utf-8');

  console.log(`\n📄 Running ${filename}...`);
  await pool.query(sql);
  console.log(`✅ ${filename} completed successfully.`);
}

/**
 * Main setup function.
 * Runs schema first (creates tables), then seed (inserts data).
 */
async function setup() {
  console.log('╔══════════════════════════════════════════╗');
  console.log('║     NEXORA-AI — Database Setup           ║');
  console.log('╚══════════════════════════════════════════╝');

  try {
    // Test the connection first
    const result = await pool.query('SELECT NOW()');
    console.log(`\n🔗 Connected to PostgreSQL at ${result.rows[0].now}`);

    // Step 1: Create tables
    await runSQLFile('schema.sql');

    // Step 2: Insert seed data
    await runSQLFile('seed.sql');

    // Step 3: Verify by counting rows in each table
    console.log('\n📊 Verifying seed data...');
    const tables = ['merchants', 'products', 'inventory', 'customers', 'sales', 'sale_items', 'expenses'];

    for (const table of tables) {
      const count = await pool.query(`SELECT COUNT(*) FROM ${table}`);
      console.log(`   ${table}: ${count.rows[0].count} rows`);
    }

    console.log('\n🎉 Database setup complete!');
  } catch (err) {
    console.error('\n❌ Database setup failed:\n');
    console.error(`   Error: ${err.message}`);

    // Provide helpful hints for common errors
    if (err.code === 'ECONNREFUSED') {
      console.error('\n   💡 Is PostgreSQL running? Check with:');
      console.error('      pg_isready');
    } else if (err.code === '3D000') {
      console.error('\n   💡 Database does not exist. Create it with:');
      console.error('      createdb nexora_dev');
    } else if (err.code === '28P01') {
      console.error('\n   💡 Authentication failed. Check your DATABASE_URL in .env');
    }

    process.exit(1);
  } finally {
    // Always close the pool so the script exits cleanly
    await pool.end();
  }
}

setup();
