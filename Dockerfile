FROM bitnami/postgresql:17.6.0-debian-12-r4

USER root

# Install build dependencies
RUN install_packages \
    libcurl4-openssl-dev \
    curl \
    unzip \
    make \
    gcc \
    build-essential
    
# Build and install pgsql-http
RUN cd /tmp && \
    curl -L -o pgsql-http.zip https://github.com/pramsey/pgsql-http/archive/refs/tags/v1.7.0.zip && \
    unzip pgsql-http.zip && \
    cd pgsql-http-* && \
    export PG_CONFIG=/opt/bitnami/postgresql/bin/pg_config && \
    make && \
    make install && \
    rm -rf /tmp/pgsql-http*

# Clean up build dependencies
RUN apt-get remove -y \
        make \
        gcc \
        curl \
        unzip \
        build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions for the extensions
RUN chmod g+rwX /opt/bitnami/postgresql/lib/http.so /opt/bitnami/postgresql/share/extension/http*

USER 1001
