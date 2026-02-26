@echo off
REM libsql HTTP API Examples for Windows
REM Replace YOUR_RAILWAY_URL with your actual Railway domain

set BASE_URL=https://YOUR_RAILWAY_URL.up.railway.app

echo ============================================
echo 1. Create users table
echo ============================================
curl -X POST "%BASE_URL%/v1/sql" -H "Content-Type: application/json" -d "{\"statements\": [\"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)\"]}"

echo.
echo ============================================
echo 2. Insert data
echo ============================================
curl -X POST "%BASE_URL%/v1/sql" -H "Content-Type: application/json" -d "{\"statements\": [\"INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com'), ('Bob', 'bob@example.com')\"]}"

echo.
echo ============================================
echo 3. Query data
echo ============================================
curl -X POST "%BASE_URL%/v1/sql" -H "Content-Type: application/json" -d "{\"statements\": [\"SELECT * FROM users\"]}"

echo.
echo ============================================
echo 4. Count records
echo ============================================
curl -X POST "%BASE_URL%/v1/sql" -H "Content-Type: application/json" -d "{\"statements\": [\"SELECT COUNT(*) as total FROM users\"]}"

echo.
echo ============================================
echo 5. List all tables
echo ============================================
curl -X POST "%BASE_URL%/v1/sql" -H "Content-Type: application/json" -d "{\"statements\": [\"SELECT name FROM sqlite_master WHERE type='table'\"]}"

echo.
echo Done!
