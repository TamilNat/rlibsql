# libsql sqld server for Railway
FROM ghcr.io/tursodatabase/libsql-server:latest

# HTTP listen address (required for Railway)
ENV SQLD_HTTP_LISTEN_ADDR=0.0.0.0:8080

# Node type: primary
ENV SQLD_NODE=primary

# Expose HTTP port for libsql client connections
EXPOSE 8080

CMD ["sqld"]
