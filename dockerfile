# Use the official PostgreSQL image from Docker Hub
FROM postgres

# Set environment variables
ENV POSTGRES_USER keldb
ENV POSTGRES_PASSWORD admin
ENV POSTGRES_DB BAULOG

# Expose the PostgreSQL port
EXPOSE 5432