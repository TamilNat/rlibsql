# libsql HTTP API - cURL Examples

**Base URL:** `https://rlibsql-production.up.railway.app`

Replace with your actual Railway domain.

---

## API Endpoints

### v2/pipeline (Recommended)

The `/v2/pipeline` endpoint is the main API for executing SQL statements.

---

## Quick Start

### 1. Test Connection
```bash
curl https://rlibsql-production.up.railway.app/
```

### 2. Simple Query
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT 1\"}]}"
```

---

## Table Operations

### Create Table
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)\"}]}"
```

### List All Tables
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT name FROM sqlite_master WHERE type='table'\"}]}"
```

### Drop Table
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"DROP TABLE IF EXISTS users\"}]}"
```

---

## CRUD Operations

### Insert Data
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com'), ('Bob', 'bob@example.com')\"}]}"
```

### Select All
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT * FROM users\"}]}"
```

### Select with WHERE
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT * FROM users WHERE name = 'Alice'\"}]}"
```

### Update Data
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"UPDATE users SET email = 'alice.new@example.com' WHERE name = 'Alice'\"}]}"
```

### Delete Data
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"DELETE FROM users WHERE name = 'Bob'\"}]}"
```

### Count Records
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT COUNT(*) as total FROM users\"}]}"
```

---

## Parameterized Queries (Prevent SQL Injection)

### Insert with Parameters
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"INSERT INTO users (name, email) VALUES (?, ?)\", \"args\": [\"Charlie\", \"charlie@example.com\"]}]}"
```

### Select with Parameters
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT * FROM users WHERE id = ?\", \"args\": [1]}]}"
```

---

## Multiple Statements in One Request

```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"INSERT INTO users (name) VALUES ('Dave')\"}, {\"stmt\": \"INSERT INTO users (name) VALUES ('Eve')\"}, {\"stmt\": \"SELECT * FROM users\"}]}"
```

---

## Advanced Examples

### Create Posts Table with Foreign Key
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"CREATE TABLE IF NOT EXISTS posts (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, title TEXT NOT NULL, content TEXT, FOREIGN KEY (user_id) REFERENCES users(id))\"}]}"
```

### Insert Post
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"INSERT INTO posts (user_id, title, content) VALUES (1, 'Hello World', 'This is my first post')\"}]}"
```

### Join Query
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT u.name, p.title, p.content FROM users u JOIN posts p ON u.id = p.user_id\"}]}"
```

### Order By
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT * FROM users ORDER BY created_at DESC\"}]}"
```

### Limit Results
```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT * FROM users LIMIT 5\"}]}"
```

---

## With JWT Authentication

If you enabled JWT auth, add the `Authorization` header:

```bash
curl -X POST "https://rlibsql-production.up.railway.app/v2/pipeline" ^
  -H "Content-Type: application/json" ^
  -H "Authorization: Bearer YOUR_JWT_TOKEN" ^
  -d "{\"batch\": [{\"stmt\": \"SELECT 1\"}]}"
```

---

## PowerShell (Windows) - Here-String Format

For complex queries, use PowerShell here-strings:

```powershell
$body = @"
{
  "batch": [
    {
      "stmt": "SELECT * FROM users"
    }
  ]
}
"@

Invoke-RestMethod -Uri "https://rlibsql-production.up.railway.app/v2/pipeline" `
  -Method Post `
  -ContentType "application/json" `
  -Body $body
```

---

## Response Format

Success response:
```json
{
  "results": [
    {
      "success": true,
      "columns": ["id", "name", "email"],
      "rows": [
        [1, "Alice", "alice@example.com"]
      ]
    }
  ]
}
```

Error response:
```json
{
  "results": [
    {
      "error": "table users does not exist"
    }
  ]
}
```

---

## Troubleshooting

### 404 Not Found
- Make sure you're using `/v2/pipeline` endpoint
- Check if Railway deployment is complete

### Connection Refused
- Wait for Railway deployment to finish
- Check Railway logs for errors

### Authentication Required
- Add `Authorization: Bearer YOUR_JWT_TOKEN` header
- Generate JWT token using `node jwtgen.js`
