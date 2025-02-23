ARG ALPINE_VERSION="3.21"

# Stage 1 - build the app
FROM docker.io/alpine:${ALPINE_VERSION} AS builder

RUN apk add --update \
    make \
    gcc \
    g++ \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /fiche/src

WORKDIR /fiche/src
COPY . .

RUN make \
    && make install \
    && make clean \
    && cp build/fiche /usr/local/bin/fiche


# Stage 2 - move the app into little image
FROM alpine:${ALPINE_VERSION}
RUN adduser -u 10000 -D -g "fiche" fiche \
    && mkdir -p /fiche \
    && chown -R fiche:fiche /fiche
COPY --from=builder --chmod=755 /usr/local/bin/fiche /usr/local/bin/fiche
COPY --chmod=755 docker-entrypoint.sh /entrypoint.sh

USER fiche
WORKDIR /fiche

ENTRYPOINT ["/entrypoint.sh"]
