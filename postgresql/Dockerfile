FROM postgres:12-alpine

# Allow connections; we don't map out any ports so only linked docker containers can connect
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf

ARG PG_HOST_AUTH_METHOD

# Customize default user/pass/db
ENV POSTGRES_DB ckan
ENV POSTGRES_USER ckan
ENV POSTGRES_HOST_AUTH_METHOD=${PG_HOST_AUTH_METHOD}
ARG POSTGRES_PASSWORD
ARG DATASTORE_READONLY_PASSWORD

# Include extra setup scripts (eg datastore)
ADD docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
