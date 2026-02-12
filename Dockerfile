# Dockerfile for building STM32 Firmware
# Based on ARM GCC toolchain (arm/amd)

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

WORKDIR /opt
RUN ARCH=$(uname -m) && \
    echo "Detected architecture: $ARCH" && \
    if [ "$ARCH" = "x86_64" ]; then \
        TOOLCHAIN_ARCH="x86_64"; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        TOOLCHAIN_ARCH="aarch64"; \
    else \
        echo "Unsupported architecture: $ARCH"; \
        exit 1; \
    fi && \
    echo "Downloading ARM GCC toolchain for $TOOLCHAIN_ARCH..." && \
    wget -q https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-${TOOLCHAIN_ARCH}-arm-none-eabi.tar.xz && \
    tar -xf arm-gnu-toolchain-12.2.rel1-${TOOLCHAIN_ARCH}-arm-none-eabi.tar.xz && \
    rm arm-gnu-toolchain-12.2.rel1-${TOOLCHAIN_ARCH}-arm-none-eabi.tar.xz && \
    mv arm-gnu-toolchain-12.2.rel1-${TOOLCHAIN_ARCH}-arm-none-eabi arm-gnu-toolchain

ENV PATH="/opt/arm-gnu-toolchain/bin:${PATH}"
RUN arm-none-eabi-gcc --version
WORKDIR /workspace
CMD ["/bin/bash"]
