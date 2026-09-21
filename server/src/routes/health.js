/**
 * NEXORA-AI — Health Check Route
 *
 * GET /api/health
 *
 * Purpose: Confirms the server is running and responsive.
 * This is the simplest possible route and serves as
 * the pattern for all future route files.
 *
 * How Express routing works:
 * 1. Create a Router (a mini-app that groups related routes)
 * 2. Define endpoints on it (router.get, router.post, etc.)
 * 3. Export it so app.js can mount it at a path
 */

import { Router } from 'express';

const router = Router();

// GET /api/health
// Returns a simple JSON object confirming the server is alive
router.get('/', (req, res) => {
  res.json({
    status: 'ok',
    service: 'nexora-api',
    timestamp: new Date().toISOString(),
  });
});

export default router;
