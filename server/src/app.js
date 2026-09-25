/**
 * NEXORA-AI — Express Application Setup
 *
 * This file creates and configures the Express app.
 * It does NOT start the server — that's index.js's job.
 *
 * Why separate? So we can import `app` in tests
 * without starting a real server on a port.
 *
 * What happens here:
 * 1. Create the Express app
 * 2. Attach middleware (JSON parsing, CORS)
 * 3. Mount route files
 * 4. Export the app
 */

import express from 'express';
import cors from 'cors';

// Import route files
import healthRoutes from './routes/health.js';
import productRoutes from './routes/products.js';
import customerRoutes from './routes/customers.js';
import salesRoutes from './routes/sales.js';
import inventoryRoutes from './routes/inventory.js';

// Create the Express app
const app = express();

// ========================
// Middleware
// ========================

// Parse incoming JSON request bodies
// Without this, req.body would be undefined on POST/PUT requests
app.use(express.json());

// Enable CORS — allows the React frontend (running on a different port)
// to make requests to this API without being blocked by the browser
app.use(cors());

// ========================
// Routes
// ========================

// Mount the health route at /api/health
// When someone visits GET /api/health, Express runs the health router
app.use('/api/health', healthRoutes);

// Phase 2: Data endpoints
app.use('/api/products', productRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/sales', salesRoutes);
app.use('/api/inventory', inventoryRoutes);

// ========================
// 404 Handler
// ========================

// If no route matched, return a clear 404 error
// This runs AFTER all routes, so it only fires for unknown paths
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.originalUrl} does not exist`,
  });
});

export default app;
