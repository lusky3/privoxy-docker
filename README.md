# Privoxy Docker

This repository provides Docker images for [Privoxy](https://www.privoxy.org/), a non-caching web proxy with advanced filtering capabilities. Two image variants are available:

- **`lusky3/privoxy:latest`** and **`lusky3/privoxy:<version>`** (e.g., `4.0.0`): Built from stable releases on [SourceForge](https://sourceforge.net/projects/ijbswa/files/Sources/).
- **`lusky3/privoxy:nightly`**: Built daily from the latest commit in the [Privoxy Git repository](https://www.privoxy.org/git/privoxy.git).

Images are available on both [DockerHub](https://hub.docker.com/r/lusky3/privoxy) and [GitHub Container Registry](https://ghcr.io/lusky3/privoxy-docker).

## Features

- Multi-architecture support: `linux/amd64` and `linux/arm64`.
- Built from source for both stable and nightly variants.
- Lightweight Alpine Linux base image.
- Docker healthcheck.
- Automated updates and builds via GitHub Actions.

## Usage

### Pulling the Image

- Stable (latest release):

  ```bash
  docker pull lusky3/privoxy:latest
  ```

- Specific stable version (e.g., 4.0.0):

  ```bash
  docker pull lusky3/privoxy:4.0.0
  ```

- Nightly (latest Git commit):

  ```bash
  docker pull lusky3/privoxy:nightly
  ```

### Running the Container

Run Privoxy on port 8118 (default):

```bash
docker run -d -p 8118:8118 lusky3/privoxy:latest
```

To use a custom config file:

```bash
docker run -d -p 8118:8118 -v /path/to/your/config:/etc/privoxy/config lusky3/privoxy:latest
```

### Example: Using with curl

Test the proxy with `curl`:

```bash
curl -x http://localhost:8118 http://example.com
```

## Tags

- `lusky3/privoxy:latest`: Latest stable release (e.g., 4.0.0 as of March 26, 2025).
- `lusky3/privoxy:<version>`: Specific stable versions (e.g., `4.0.0`).
- `lusky3/privoxy:nightly`: Latest Git commit, rebuilt daily.
- `lusky3/privoxy:<sha>`: Git SHA tags for both stable and nightly builds.

The same tags are available on GitHub Container Registry (e.g., `ghcr.io/lusky3/privoxy-docker:4.0.0`).

## Build Process

- **Stable Builds**:
  - Source: [SourceForge stable releases](https://sourceforge.net/projects/ijbswa/files/Sources/).
  - Trigger: On push to `main` or manual dispatch.
  - Update Check: Weekly (Sundays at 2 AM UTC) via GitHub Actions, updating to the latest stable version.
  - Workflow: `.github/workflows/build-stable.yml`.

- **Nightly Builds**:
  - Source: [Privoxy Git repository](https://www.privoxy.org/git/privoxy.git).
  - Trigger: Daily at midnight UTC or manual dispatch.
  - Workflow: `.github/workflows/build-nightly.yml`.

The `Dockerfile` supports both sources using build arguments (`BUILD_SOURCE` and `PRIVOXY_VERSION`).

## Development

To build locally:

- Stable (e.g., 4.0.0):
  
  ```bash
  docker build -t privoxy:4.0.0 --build-arg BUILD_SOURCE=sourceforge --build-arg PRIVOXY_VERSION=4.0.0 .
  ```

- Nightly:

  ```bash
  docker build -t privoxy:nightly --build-arg BUILD_SOURCE=git .
  ```

## Configuration

The default config file (`config.conf`) is minimal. Mount your own config to `/etc/privoxy/config` for custom settings. See the [Privoxy documentation](https://www.privoxy.org/user-manual/) for configuration options.

## Healthcheck

The container includes a healthcheck:

- Endpoint: `http://detectportal.firefox.com/success.txt`
- Interval: 30 seconds
- Timeout: 3 seconds

If the proxy fails to respond, the container is marked unhealthy.

## Contributing

- Contributions welcome!
- Fork the repository.
- Submit pull requests to `main`.

## License

This project is licensed under the MIT License. Privoxy itself is licensed under the GNU General Public License v2 (GPLv2). See the [Privoxy license](https://www.privoxy.org/user-manual/copyright.html) for details.
