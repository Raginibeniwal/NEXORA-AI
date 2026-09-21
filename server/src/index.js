/**
 * NEXORA-AI — Server Entry Point
 *
 * This is what runs when you type `npm run dev`.
 *
 * It does three things:
 * 1. Load .env file (must be FIRST, before any other imports)
 * 2. Import the configured Express app
 * 3. Start listening for HTTP requests
 *
 * ES Module note:
 * We use `import` instead of `require()` because this project
 * uses "type": "module" in package.json (the modern standard).
 *
 * Why is dotenv imported first?
 * Because config/index.js reads process.env when it's imported.
 * If we import config BEFORE loading .env, the variables won't be there.
 * Order matters!
 */

// Step 1: Load environment variables from .env file
// This MUST come before any other imports that use process.env
import 'dotenv/config';

// Step 2: Import config and app (now .env is loaded, so config reads real values)
import config from './config/index.js';
import app from './app.js';

// Step 3: Start the server
app.listen(config.port, () => {
  console.log(`
  ╔══════════════════════════════════════════╗
  ║         NEXORA-AI Server Running         ║
  ╠══════════════════════════════════════════╣
  ║  Port:  ${String(config.port).padEnd(31)}║
  ║  Mode:  ${config.nodeEnv.padEnd(31)}║
  ║  URL:   http://localhost:${String(config.port).padEnd(14)}║
  ╚══════════════════════════════════════════╝
  `);
});
