# ARM GCC (arm-none-eabi) build image for embedded firmware (STM32, Dragino LA66/ASR6601...).
# One Dockerfile, one image per toolchain version, selected with --build-arg GCC_VERSION:
#   9-2020-q2   GNU Arm Embedded Toolchain 9-2020-q2-update (9.3.1)  -> Dragino LA66
#   12.2.rel1   Arm GNU Toolchain 12.2.Rel1 (12.2.1)                 -> STM32 projects
# Supports x86_64 and ARM64 (Apple Silicon) hosts. Every download is verified against
# the checksum Arm publishes for it.

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    tar \
    bzip2 \
    make \
    git \
    python3 \
    python3-pip \
    unzip \
    xz-utils \
    file \
    && rm -rf /var/lib/apt/lists/*

# Declared after the apt layer, so both versions share it (and its build cache)
ARG GCC_VERSION=12.2.rel1

WORKDIR /opt

# Per version: archive name, URL, extracted folder and the checksum published by Arm
# (MD5 for the old "gnu-rm" releases, SHA256 for the newer ones).
RUN set -e; \
    ARCH=$(uname -m); \
    case "$ARCH" in \
        x86_64)        TC_ARCH=x86_64 ;; \
        aarch64|arm64) TC_ARCH=aarch64 ;; \
        *) echo "Unsupported architecture: $ARCH"; exit 1 ;; \
    esac; \
    case "$GCC_VERSION/$TC_ARCH" in \
        9-2020-q2/x86_64)  SUM_TOOL=md5sum;    SUM=2b9eeccc33470f9d3cda26983b9d2dc6 ;; \
        9-2020-q2/aarch64) SUM_TOOL=md5sum;    SUM=000b0888cbe7b171e2225b29be1c327c ;; \
        12.2.rel1/x86_64)  SUM_TOOL=sha256sum; SUM=84be93d0f9e96a15addd490b6e237f588c641c8afdf90e7610a628007fc96867 ;; \
        12.2.rel1/aarch64) SUM_TOOL=sha256sum; SUM=7ee332f7558a984e239e768a13aed86c6c3ac85c90b91d27f4ed38d7ec6b3e8c ;; \
        *) echo "Unsupported GCC_VERSION: $GCC_VERSION"; exit 1 ;; \
    esac; \
    case "$GCC_VERSION" in \
        9-2020-q2) \
            FILE="gcc-arm-none-eabi-9-2020-q2-update-${TC_ARCH}-linux.tar.bz2"; \
            URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/${FILE}"; \
            DIR="gcc-arm-none-eabi-9-2020-q2-update" ;; \
        12.2.rel1) \
            FILE="arm-gnu-toolchain-12.2.rel1-${TC_ARCH}-arm-none-eabi.tar.xz"; \
            URL="https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/${FILE}"; \
            DIR="arm-gnu-toolchain-12.2.rel1-${TC_ARCH}-arm-none-eabi" ;; \
    esac; \
    echo "Downloading ARM GCC $GCC_VERSION for $TC_ARCH..."; \
    wget -q "$URL"; \
    echo "$SUM  $FILE" | $SUM_TOOL -c -; \
    tar -xf "$FILE"; \
    rm "$FILE"; \
    mv "$DIR" arm-gnu-toolchain

ENV PATH="/opt/arm-gnu-toolchain/bin:${PATH}"

RUN arm-none-eabi-gcc --version

# Lets GHCR link the package to its repository
LABEL org.opencontainers.image.source="https://github.com/smartnexus/ARM-GCC-toolchain" \
      org.opencontainers.image.description="arm-none-eabi GCC ${GCC_VERSION} build environment" \
      org.opencontainers.image.version="${GCC_VERSION}"

WORKDIR /workspace
CMD ["/bin/bash"]
