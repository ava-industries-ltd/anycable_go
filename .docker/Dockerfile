# syntax=docker/dockerfile:1.3
#####################################
# Stage 1: AMD64 Builder            #
#####################################
FROM golang:1.23-bullseye AS builder

# Install ARM64 cross-compiler and Ruby for MRuby build
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
      ruby2.7 ruby2.7-dev build-essential bison zip git \
 && rm -rf /var/lib/apt/lists/*

# Set up cross-compilation environment
ENV CGO_ENABLED=1 \
    GO111MODULE=on \
    CC=aarch64-linux-gnu-gcc \
    AR=aarch64-linux-gnu-ar \
    RANLIB=aarch64-linux-gnu-ranlib

WORKDIR /src
COPY . .

# Vendor Go modules
RUN go mod vendor

# Build MRuby static lib for ARM64
RUN cd vendor/github.com/mitchellh/go-mruby \
 && MRUBY_CONFIG=../../../../../../etc/build_config.rb make libmruby.a

# Cross-compile the AnyCable-Go binary for linux/arm64
RUN GOOS=linux GOARCH=arm64 \
    go build -tags mrb \
      -ldflags "\
        -s -w \
        -X github.com/anycable/anycable-go/version.version=$(git describe --tags --always --dirty) \
        -X github.com/anycable/anycable-go/version.sha=$(git rev-parse --short HEAD)" \
      -o anycable-go-mrb \
      cmd/anycable-go/main.go

#####################################
# Stage 2: ARM64 Runtime            #
#####################################
FROM --platform=linux/arm64 debian:bullseye-slim

# Only copy the pre-built ARM64 binary (no RUN steps)
COPY --from=builder /src/anycable-go-mrb /usr/local/bin/anycable-go

USER nobody
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/anycable-go"]
