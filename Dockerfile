FROM bitnami/postgresql:17.2.0-debian-12-r10

USER root

# Install build dependencies
RUN install_packages \
    postgresql-server-dev-17 \
    libcurl4-openssl-dev \
    make \
    gcc \
    git

# Build and install pgsql-http
RUN cd /tmp && \
    git clone https://github.com/pramsey/pgsql-http.git && \
    cd pgsql-http && \
    make && \
    make install && \
    # Clean up build dependencies
    rm -rf /tmp/pgsql-http && \
    apt-get remove -y \
        postgresql-server-dev-17 \
        make \
        gcc \
        git && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Fix permissions for the extension
RUN chmod g+rwX /usr/lib/postgresql/17/lib/http.so /usr/share/postgresql/17/extension/http*

USER 1001
