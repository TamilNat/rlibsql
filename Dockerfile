# libsql sqld server for Railway
FROM ghcr.io/tursodatabase/libsql-server:latest

# Default database path
ENV SQLD_DB_PATH=/var/lib/sqld/iku.db

# HTTP listen address (required for Railway)
ENV SQLD_HTTP_LISTEN_ADDR=0.0.0.0:8080

# gRPC listen address (for replication, optional)
ENV SQLD_GRPC_LISTEN_ADDR=0.0.0.0:5001

# Node type: primary, replica, or standalone
ENV SQLD_NODE=primary

# Expose HTTP port for libsql client connections
EXPOSE 8080

# Expose gRPC port for replication (optional)
EXPOSE 5001

CMD ["sqld"]
