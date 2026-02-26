# libsql HTTP API Examples
# Replace YOUR_RAILWAY_URL with your actual Railway domain

# Base URL (get from Railway dashboard)
BASE_URL="https://YOUR_RAILWAY_URL.up.railway.app"

# ============================================
# 1. Create a table
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE, created_at DATETIME DEFAULT CURRENT_TIMESTAMP)"]}'

# ============================================
# 2. Insert data
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["INSERT INTO users (name, email) VALUES (\"Alice\", \"alice@example.com\"), (\"Bob\", \"bob@example.com\")"]}'

# ============================================
# 3. Query data
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["SELECT * FROM users"]}'

# ============================================
# 4. Update data
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["UPDATE users SET email = \"alice.new@example.com\" WHERE name = \"Alice\"]}'

# ============================================
# 5. Delete data
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["DELETE FROM users WHERE name = \"Bob\"]}'

# ============================================
# 6. Count records
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["SELECT COUNT(*) as total FROM users"]}'

# ============================================
# 7. Create another table (posts)
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["CREATE TABLE IF NOT EXISTS posts (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, title TEXT NOT NULL, content TEXT, FOREIGN KEY (user_id) REFERENCES users(id))"]}'

# ============================================
# 8. Insert posts
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["INSERT INTO posts (user_id, title, content) VALUES (1, \"Hello World\", \"This is my first post\")"]}'

# ============================================
# 9. Join query
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["SELECT u.name, p.title, p.content FROM users u JOIN posts p ON u.id = p.user_id"]}'

# ============================================
# 10. List all tables
# ============================================
curl -X POST "$BASE_URL/v1/sql" \
  -H "Content-Type: application/json" \
  -d '{"statements": ["SELECT name FROM sqlite_master WHERE type=\"table\""]}'
