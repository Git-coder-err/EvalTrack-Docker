// ============================================
// EvalTrack Backend with Enhanced Security
// ============================================

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const Database = require('better-sqlite3');
const path = require('path');
require('dotenv').config();

const app = express();

// ============================================
// SECURITY MIDDLEWARE (Applied First)
// ============================================

// 1. Helmet: Security headers (CSP, X-Frame-Options, etc.)
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "http://localhost:*", "https://*.firebase.com", "https://*.google.com"],
      frameSrc: ["'none'"],
      objectSrc: ["'none'"],
      upgradeInsecureRequests: process.env.NODE_ENV === 'production' ? ['always'] : []
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  },
  frameguard: { action: 'deny' },
  noSniff: true,
  referrerPolicy: { policy: 'strict-origin-when-cross-origin' }
}));

// 2. CORS: Cross-Origin Resource Sharing
const corsOptions = {
  origin: process.env.CORS_ORIGIN?.split(',') || ['http://localhost:3000', 'http://localhost:3001'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  maxAge: 86400
};

app.use(cors(corsOptions));

// 3. Compression: Gzip response compression
app.use(compression());

// 4. Body parsers
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// 5. Rate Limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP, please try again later.',
  standardHeaders: true, // Return rate limit info in headers
  legacyHeaders: false // Disable X-RateLimit-* headers
});

// Apply rate limiter to all requests
app.use(limiter);

// Create stricter limiter for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5, // 5 requests per 15 minutes
  skipSuccessfulRequests: true, // Don't count successful responses
  message: 'Too many login attempts, please try again later.'
});

// 6. HTTPS Redirect middleware (for production)
if (process.env.NODE_ENV === 'production' && process.env.USE_HTTPS === 'true') {
  app.use((req, res, next) => {
    if (!req.secure && req.headers['x-forwarded-proto'] !== 'https') {
      res.redirect(301, `https://${req.headers.host}${req.url}`);
    } else {
      next();
    }
  });
}

// 7. Security response headers
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  next();
});

console.log('\n🔒 ========== SECURITY CONFIGURATION ==========');
console.log(`✓ Helmet: Enabled (CSP, X-Frame-Options, HSTS)`);
console.log(`✓ CORS: Enabled (${corsOptions.origin.join(', ')})`);
console.log(`✓ Compression: Enabled`);
console.log(`✓ Rate Limiting: ${process.env.RATE_LIMIT_MAX_REQUESTS || 100} requests per ${process.env.RATE_LIMIT_WINDOW_MS || 900}ms`);
console.log(`✓ Auth Limiter: 5 requests per 15 minutes`);
console.log(`🔓 =============================================\n`);

// ============================================
// ENVIRONMENT CONFIGURATION
// ============================================

const NODE_ENV = process.env.NODE_ENV || 'development';
const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || '0.0.0.0';
const useSQLite = "true"; // Using SQLite for now

console.log("=== ENVIRONMENT CONFIGURATION ===");
console.log("Environment:", NODE_ENV);
console.log("Port:", PORT);
console.log("Using SQLite:", useSQLite);

// ============================================
// DATABASE INITIALIZATION
// ============================================

let db;

if (useSQLite === "true") {
    try {
        console.log("✔ Using better-sqlite3...");

        db = new Database('./database.sqlite');

        console.log("✔ SQLite connected");

        // Create sample table
        db.prepare(`
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                email TEXT UNIQUE,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        `).run();

        console.log("✔ Table initialized");

    } catch (err) {
        console.error("❌ Database error:", err);
    }
}

// ============================================
// ROUTES
// ============================================

// Apply auth limiter to login/register endpoints
app.post('/api/auth/login', authLimiter, (req, res) => {
  res.json({ 
    message: 'Login endpoint',
    security: 'Rate limited and protected'
  });
});

app.post('/api/auth/register', authLimiter, (req, res) => {
  res.json({ 
    message: 'Register endpoint',
    security: 'Rate limited and protected'
  });
});

// Health check endpoint
app.get('/', (req, res) => {
    res.json({
      status: '✓ EvalTrack Backend Running',
      environment: NODE_ENV,
      database: 'SQLite',
      security: {
        helmet: 'enabled',
        cors: 'enabled',
        rateLimit: 'enabled',
        compression: 'enabled'
      }
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({ 
    error: process.env.NODE_ENV === 'production' ? 'Internal server error' : err.message
  });
});

// ============================================
// START SERVER
// ============================================

const server = app.listen(PORT, HOST, () => {
    console.log(`\n🔥 EvalTrack Backend Server`);
    console.log(`📍 Running on ${NODE_ENV === 'production' ? 'https' : 'http'}://${HOST}:${PORT}`);
    console.log(`⏰ Started at: ${new Date().toISOString()}\n`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    if (db) db.close();
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    if (db) db.close();
    process.exit(0);
  });
});