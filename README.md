# ARM-GCC-toolchain
This repository holds the code for building a Docker image with required tools in order to build STM32 ARM code for embedded devices.

**NOTICE**: Use it at your own risk.

## Available tags
One image is published per toolchain version (`GCC_VERSION` build-arg in the `Dockerfile`):

| Tag | Toolchain | Intended for |
|-----|-----------|--------------|
| `12.2.rel1`, `latest` | Arm GNU Toolchain 12.2.Rel1 (GCC 12.2.1) | STM32 projects |
| `9-2020-q2` | GNU Arm Embedded Toolchain 9-2020-q2-update (GCC 9.3.1) | Dragino LA66 / ASR6601 |

Every build is also tagged `<version>-sha-<commit>` (e.g. `12.2.rel1-sha-48d91a7`), and release tags `vX.Y.Z` publish `<version>-X.Y.Z`.

## Pull image
```bash
docker pull ghcr.io/smartnexus/arm-gcc-toolchain:latest      # 12.2.rel1
docker pull ghcr.io/smartnexus/arm-gcc-toolchain:9-2020-q2
```

## Build locally
```bash
docker build --build-arg GCC_VERSION=9-2020-q2 -t arm-gcc-toolchain:9-2020-q2 .
```

## Invoking compiler from your environment
```bash
docker run --rm -v "$pwd:/workspace" -w /workspace ghcr.io/smartnexus/arm-gcc-toolchain make clean install
```

Use `ghcr.io/smartnexus/arm-gcc-toolchain:9-2020-q2` instead to build Dragino LA66 firmware.
