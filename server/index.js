const express = require('express');
const Database = require('better-sqlite3');
const path = require('path');

const app = express();
app.use(express.json());

// ============================
// FORCE SQLITE (NO MYSQL)
// ============================
const useSQLite = "true";
const isProduction = false;

console.log("=== DATABASE CONFIGURATION ===");
console.log("Using SQLite:", useSQLite);

// ============================
// INIT DATABASE
// ============================
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
                email TEXT
            )
        `).run();

        console.log("✔ Table initialized");

    } catch (err) {
        console.error("❌ Database error:", err);
    }
}

// ============================
// TEST ROUTE
// ============================
app.get('/', (req, res) => {
    res.send("🚀 EvalTrack Backend Running (SQLite Mode)");
});

// ============================
// SERVER LISTEN
// ============================
const PORT = 3000;

// 🔥 VERY IMPORTANT FOR DOCKER
app.listen(PORT, "0.0.0.0", () => {
    console.log(`🔥 Server running on http://localhost:${PORT}`);
});