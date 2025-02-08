FROM bitnami/postgresql:17.2.0-debian-12-r10

USER root

# Install build dependencies
RUN install_packages \
    libcurl4-openssl-dev \
    make \
    gcc \
    git \
    build-essential
    
# Build and install pgsql-http
RUN cd /tmp && \
    git clone https://github.com/pramsey/pgsql-http.git && \
    cd pgsql-http && \
    export PG_CONFIG=/opt/bitnami/postgresql/bin/pg_config && \
    make && \
    make install && \
    # Clean up build dependencies
    rm -rf /tmp/pgsql-http && \
    apt-get remove -y \
        make \
        gcc \
        git \
        build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions for the extension
RUN chmod g+rwX /usr/lib/postgresql/17/lib/http.so /usr/share/postgresql/17/extension/http*

USER 1001
