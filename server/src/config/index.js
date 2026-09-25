/**
 * NEXORA-AI — Centralized Configuration
 *
 * This is the ONLY file that reads process.env directly.
 * Every other file imports config from here.
 *
 * Why? If an env variable name changes, you update one file.
 * It also lets us add defaults and validation in one place.
 */

const config = {
  // Server settings
  port: parseInt(process.env.PORT, 10) || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',

  // Returns true when running in development mode
  isDev: (process.env.NODE_ENV || 'development') === 'development',

  // Database (Phase 2)
  // Individual connection parameters from .env
  // The password is NEVER hardcoded — it must be set in .env
  db: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    name: process.env.DB_NAME || 'nexora',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD,
  },

  // AI Service (Phase 6 — will be added here)
  // ai: { apiKey: process.env.OPENAI_API_KEY }
};

// ES module: use `export default` instead of `module.exports`
export default config;
