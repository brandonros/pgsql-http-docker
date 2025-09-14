FROM bitnami/postgresql:17.6.0-debian-12-r4

USER root

# Install build dependencies
RUN install_packages \
    libcurl4-openssl-dev \
    libssl-dev \
    curl \
    unzip \
    make \
    gcc \
    build-essential
    
# Build and install pgsql-http
RUN cd /tmp && \
    curl -L -o pgsql-http.zip https://github.com/pramsey/pgsql-http/archive/refs/tags/v1.7.0.zip && \
    unzip pgsql-http.zip && \
    cd pgsql-http-1.7.0 && \
    export PG_CONFIG=/opt/bitnami/postgresql/bin/pg_config && \
    make && \
    make install && \
    rm -rf /tmp/pgsql-http*

# Build and install pglogical
RUN cd /tmp && \
    curl -L -o pglogical.zip https://github.com/2ndQuadrant/pglogical/archive/refs/tags/REL2_4_6.zip && \
    unzip pglogical.zip && \
    cd pglogical-* && \
    export PG_CONFIG=/opt/bitnami/postgresql/bin/pg_config && \
    make && \
    make install && \
    rm -rf /tmp/pglogical*

# Clean up build dependencies
RUN apt-get remove -y \
        make \
        gcc \
        build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions for the extension
RUN chmod g+rwX /opt/bitnami/postgresql/lib/http.so /opt/bitnami/postgresql/share/extension/http*

USER 1001
