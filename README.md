# libsql on Railway

Self-hosted libsql (sqld) server deployment for Railway.

## Quick Start

### 1. Generate JWT Keys

Run the key generator to create authentication keys:

```bash
node jwtgen.js
```

This will output:
- `SQLD_AUTH_JWT_KEY` - Add this to Railway environment variables
- Connection strings with JWT tokens for your application

### 2. Deploy to Railway

**Option A: Railway CLI**

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Deploy
railway up
```

**Option B: GitHub**

1. Push this code to a GitHub repository
2. Go to [Railway](https://railway.com)
3. Click "New Project" → "Deploy from GitHub repo"
4. Select your repository
5. Add environment variables (see below)
6. Deploy

### 3. Configure Environment Variables

In Railway dashboard, add these variables:

| Variable | Value | Description |
|----------|-------|-------------|
| `SQLD_AUTH_JWT_KEY` | (from `node jwtgen.js`) | JWT public key for authentication |
| `SQLD_NODE` | `primary` | Node type (primary/replica/standalone) |
| `SQLD_HTTP_LISTEN_ADDR` | `0.0.0.0:8080` | HTTP listen address |
| `SQLD_GRPC_LISTEN_ADDR` | `0.0.0.0:5001` | gRPC listen address |

### 4. Add Persistent Volume

1. Go to your Railway project
2. Click on your service
3. Go to "Volumes" tab
4. Click "New Volume"
5. Mount path: `/var/lib/sqld`
6. Size: 1GB recommended (adjust as needed)

### 5. Connect Your Application

**Node.js:**
```javascript
import { createClient } from '@libsql/client';

const client = createClient({
  url: 'https://your-app.up.railway.app',
  authToken: 'your-jwt-token-here'
});

const result = await client.execute('SELECT 1');
console.log(result);
```

**Go:**
```go
import (
    "database/sql"
    _ "github.com/tursodatabase/libsql-client-go/libsql"
)

dsn := "libsql://your-app.up.railway.app?authToken=your-jwt-token"
db, err := sql.Open("libsql", dsn)
```

**Python:**
```python
from libsql_client import create_client

client = create_client(
    url="https://your-app.up.railway.app",
    auth_token="your-jwt-token"
)
```

## Files

- `Dockerfile` - Uses official libsql server image
- `railway.json` - Railway deployment configuration
- `jwtgen.js` - JWT key and token generator

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SQLD_NODE` | `primary` | Instance type: primary, replica, or standalone |
| `SQLD_PRIMARY_URL` | - | gRPC URL of primary (required for replicas) |
| `SQLD_DB_PATH` | `/var/lib/sqld/iku.db` | Database file location |
| `SQLD_HTTP_LISTEN_ADDR` | `0.0.0.0:8080` | HTTP listen address |
| `SQLD_GRPC_LISTEN_ADDR` | `0.0.0.0:5001` | gRPC listen address |
| `SQLD_AUTH_JWT_KEY` | - | JWT public key (base64 URL-safe encoded) |

## Ports

- **8080** - HTTP (libsql client connections)
- **5001** - gRPC (replication)

## Troubleshooting

### Connection fails
1. Check that `SQLD_AUTH_JWT_KEY` is set correctly
2. Verify your JWT token was generated with the matching private key
3. Ensure the volume is mounted at `/var/lib/sqld`

### Database not persisting
1. Verify volume is mounted at `/var/lib/sqld`
2. Check Railway deployment logs for volume mount confirmation

### Replica setup
For read replicas, set:
- `SQLD_NODE=replica`
- `SQLD_PRIMARY_URL=https://<token>@<primary-url>`

## License

MIT
