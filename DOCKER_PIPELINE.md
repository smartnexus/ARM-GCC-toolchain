# Docker Build Pipeline

This repository includes a GitHub Actions workflow that automatically builds and pushes Docker images to the GitHub Container Registry (ghcr.io).

## Workflow Details

**File:** `.github/workflows/docker-build-push.yml`

### Triggers

The workflow runs on:
- **Push to main/master branch**: Builds and pushes image with `latest` tag
- **Push tags** (e.g., `v1.0.0`): Builds and pushes image with semantic version tags
- **Pull Requests**: Builds the image but does not push (for validation)
- **Manual trigger**: Can be run manually via workflow_dispatch

### Image Registry

Images are pushed to: `ghcr.io/smartnexus/arm-gcc-toolchain`

### Tagging Strategy

The workflow automatically generates tags based on the trigger:
- `latest` - for pushes to the default branch
- `v1.2.3`, `v1.2`, `v1` - for version tags
- `sha-<sha>` - for specific commits
- `main`, `master` - for branch names
- `pr-<number>` - for pull requests (not pushed)

### Prerequisites

1. A `Dockerfile` must exist in the repository root
2. The workflow uses `GITHUB_TOKEN` (automatically provided by GitHub Actions)
3. No additional secrets configuration needed

### Permissions

The workflow requires:
- `contents: read` - to checkout the repository
- `packages: write` - to push images to ghcr.io

### Features

- **Docker Buildx**: Uses advanced build features
- **Layer caching**: Speeds up builds using GitHub Actions cache
- **Metadata extraction**: Automatically generates proper labels and tags
- **Multi-architecture support**: Ready for multi-platform builds (if needed)

## Usage

Once a Dockerfile is added to the repository, the workflow will automatically:
1. Build the Docker image
2. Tag it appropriately based on the trigger
3. Push it to ghcr.io (except for PRs)

To pull the image:
```bash
docker pull ghcr.io/smartnexus/arm-gcc-toolchain:latest
```

## Next Steps

- Add a `Dockerfile` to the repository root
- The workflow will run automatically on the next push
