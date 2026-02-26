# libsql sqld server for Railway
FROM ghcr.io/tursodatabase/libsql-server:latest

# HTTP listen address (required for Railway)
ENV SQLD_HTTP_LISTEN_ADDR=0.0.0.0:8080

# Database path
ENV SQLD_DB_PATH=/var/lib/sqld/db.sqlite

# Node type: primary
ENV SQLD_NODE=primary

# Enable HTTP endpoint
ENV SQLD_ENABLE_HTTP_API=1

# Expose HTTP port for libsql client connections
EXPOSE 8080

CMD ["sqld", "--http-listen-addr", "0.0.0.0:8080"]
