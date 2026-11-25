# AMP 3 Dockerized

Unofficial Docker packaging for [CubeCoders AMP 3](https://cubecoders.com/AMP3), based on [Tareku99/AMP-v3-dockerized](https://github.com/Tareku99/AMP-v3-dockerized). This repository packages AMP 3 only.

- **Image:** `ghcr.io/akurosia/amp-dockerized`
- **Base:** Debian 13 (Trixie) Slim
- **Platform:** Linux AMD64
- **Web panel:** HTTP port 8443
- **Persistent data:** `/opt/cubecoders/amp3/data`

AMP 3 is currently in beta. The preview image requires a CubeCoders licence eligible for preview builds. Switching streams does not grant licence eligibility.

## Quick start

Choose one of the supplied examples:

- [Docker Compose — bridge networking](examples/docker-compose.yml)
- [Docker Compose — Unraid br0 with a static IP](examples/docker-compose-unraid-br0.yml)
- [Docker CLI](examples/docker-run.sh)

Create a dedicated data directory. Do not reuse an AMP 2 data directory: this container does not perform automatic migration. Keep a backup before updates or switching streams.

Run `docker compose up -d` from the directory containing your Compose file. Open the private first-run setup link printed in the container logs or saved as `setup-link.txt` in the persistent data directory. Complete user setup and licence activation in the panel. The default panel address is http://localhost:8443 for a local bridge deployment.

## Release streams

The Compose examples select a prebuilt image using an environment variable in the Compose project’s `.env` file:

```dotenv
AMP3_STREAM=preview
```

Set `AMP3_STREAM=mainline` when CubeCoders publishes a usable Mainline package and the corresponding image is available. Then run:

```sh
docker compose pull
docker compose up -d
```

No local image rebuild is necessary. This variable selects the image tag **before container creation**; it is not a runtime package replacement or a way to bypass licensing.

| Image tag | Purpose |
| --- | --- |
| `preview` | AMP 3 preview |
| `mainline` | AMP 3 Mainline, published only after a successful signed-package build |
| `latest` | Mainline when successfully built; existing preview image retained until then |
| `amp3`, `amp3-amd64` | Compatibility aliases for preview |
| `amp3-<commit>`, `sha-<commit>` | Preview build commit aliases |
| `<stream>-<commit>-<run>` | Stream-specific build |

Mainline availability is determined by GitHub Actions; there is no confirmed public stable AMP 3 release as of 25 November 2026. Do not switch a populated preview data volume to an older Mainline version without a verified migration path. Use a separate volume if uncertain.

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `AMP3_STREAM` (Compose project) | `preview` | Select the prebuilt image tag |
| `PORT` (container) | `8443` | Internal HTTP panel port |
| `TZ` (container) | `Etc/UTC` | Time zone |
| `AMP3_ORIGIN` (container) | `https://cdn-downloads.c7rs.com/AMP3` | AMP update origin |

The image itself records its packaged stream and repository. A different container-level `AMP3_STREAM` is rejected rather than replacing binaries at startup. Local builds can use `--build-arg AMP3_STREAM=preview` or `mainline` when available.

## Runtime requirements

Native game servers use systemd and cgroups. The supplied Linux examples include the host cgroup namespace, writable cgroup mount, SYS_ADMIN and NET_ADMIN capabilities, tmpfs mounts and a pseudo-TTY. On AppArmor hosts they also use unconfined AppArmor. These settings reduce isolation; deploy on a trusted dedicated host. Neither privileged mode nor a Docker socket mount is required. Map game TCP/UDP ports as needed when using bridge networking. For Unraid br0, configure a unique static IP and persistent MAC.

## Updates and builds

Use the explicit preview tag for ongoing beta updates; latest is not refreshed by preview builds. GitHub Actions refreshes the Debian base and signed CubeCoders packages on relevant master changes, daily, and via manual dispatch. It verifies installed package files before publishing. AMP also has its own application update mechanism. A successful image build is not a guarantee of game-server or migration compatibility.

Local build:

```sh
docker build --platform linux/amd64 --build-arg AMP3_STREAM=preview -t amp3-local .
```

## Attribution

Container packaging is distributed under the [MIT license](LICENSE). AMP itself is CubeCoders software and is subject to its own licensing terms. This is a community image, not an official CubeCoders container. Report packaging issues to [this repository](https://github.com/Akurosia/AMP-dockerized/issues).
