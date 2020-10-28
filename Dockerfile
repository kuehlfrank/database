FROM postgres:13-alpine
COPY ./scripts/1-schema.sql /docker-entrypoint-initdb.d/1-schema.sql
COPY ./scripts/2-testdata.sql /docker-entrypoint-initdb.d/2-testdata.sql
