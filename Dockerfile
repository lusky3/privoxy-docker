# Use Alpine as base for small size
FROM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    autoconf \
    automake \
    gcc \
    make \
    musl-dev \
    pcre-dev \
    zlib-dev \
    curl \
    git

# Arguments for source selection
ARG BUILD_SOURCE=sourceforge
ARG PRIVOXY_VERSION=4.1.0

# Download and build Privoxy based on source
WORKDIR /usr/src
RUN if [ "$BUILD_SOURCE" = "sourceforge" ]; then \
        curl -L "https://sourceforge.net/projects/ijbswa/files/Sources/${PRIVOXY_VERSION}%20%28stable%29/privoxy-${PRIVOXY_VERSION}-stable-src.tar.gz" -o privoxy.tar.gz && \
        tar xzf privoxy.tar.gz && \
        cd privoxy-${PRIVOXY_VERSION}-stable; \
    else \
        git clone https://www.privoxy.org/git/privoxy.git && \
        cd privoxy; \
    fi && \
    autoheader && \
    autoconf && \
    ./configure --prefix=/usr/local && \
    make && \
    make install

# Final image
FROM alpine:latest

# Install runtime dependencies
RUN apk add --no-cache \
    pcre \
    zlib \
    curl

# Copy Privoxy from builder
COPY --from=builder /usr/local /usr/local

# Copy config file
COPY config.conf /etc/privoxy/config

# Expose Privoxy port
EXPOSE 8118

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -x http://localhost:8118 http://detectportal.firefox.com/success.txt || exit 1

# Run Privoxy
ENTRYPOINT ["privoxy", "--no-daemon"]
CMD ["/etc/privoxy/config"]

# Set version label
ARG BUILD_SOURCE
ARG PRIVOXY_VERSION
LABEL privoxy.source="${BUILD_SOURCE}" \
      privoxy.version="${PRIVOXY_VERSION:-nightly}"