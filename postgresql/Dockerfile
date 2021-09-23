
FROM postgres:9.6
# FROM mdillon/postgis

# Allow connections; we don't map out any ports so only linked docker containers can connect
# RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/postgresql/data/pg_hba.conf

# Customize default user/pass/db
ARG PG_DB
ARG PG_USER
ARG PG_PASSWORD
ARG PG_HOST_AUTH_METHOD

ENV POSTGRES_DB=${PG_DB}
ENV POSTGRES_USER=${PG_USER}
ENV POSTGRES_PASSWORD=${PG_PASSWORD}
ENV POSTGRES_HOST_AUTH_METHOD=${PG_HOST_AUTH_METHOD}


# Include datastore setup scripts
ADD  docker-entrypoint-initdb.d /docker-entrypoint-initdb.d