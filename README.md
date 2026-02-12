# ARM-GCC-toolchain
This repository holds the code for building a Docker image with required tools in order to build STM32 ARM code for embedded devices.

**NOTICE**: Use it at your own risk.

## Pull image
```bash
docker pull ghcr.io/smartnexus/arm-gcc-toolchain:latest
```

## Invoking compiler from your environment
```bash
docker run --rm -v "$pwd:/workspace" -w /workspace ghcr.io/smartnexus/arm-gcc-toolchain make clean install
```
