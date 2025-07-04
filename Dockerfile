FROM golang:latest AS builder

WORKDIR /app

RUN git clone https://github.com/tailscale/tailscale.git

RUN sed -i '/if hi\.ServerName != m\.hostname && !m\.noHostname {/,/}/ { \
    s/^/\/\//; \
    s/^/\/\//; \
    s/^/\/\//; \
}' /app/tailscale/cmd/derper/cert.go

RUN cd /app/tailscale/cmd/derper/ && CGO_ENABLED=0 /usr/local/go/bin/go build -buildvcs=false -ldflags "-s -w" -o /app/derper

FROM ubuntu:24.04

WORKDIR /app

ENV DERP_ADDR :443
ENV DERP_HTTP_PORT 80
ENV DERP_HOST=127.0.0.1
ENV DERP_CERTS=/app/certs/
ENV DERP_STUN true
ENV DERP_VERIFY_CLIENTS false

RUN apt-get update && \
    apt-get install -y openssl curl

COPY --from=builder /app/derper /app/derper
COPY build_cert.sh /app/build_cert.sh

CMD bash /app/build_cert.sh $DERP_HOST $DERP_CERTS /app/san.conf && \
    /app/derper \
    --hostname=$DERP_HOST \
    --certmode=manual \
    --certdir=$DERP_CERTS \
    --stun=$DERP_STUN  \
    --a=$DERP_ADDR \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS
