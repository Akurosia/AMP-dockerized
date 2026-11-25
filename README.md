# AMP 3 beta

Based on [Tareku99/AMP-v3-dockerized](https://github.com/Tareku99/AMP-v3-dockerized/commit/b2d920070cec5e4d39d4ac3bfa72a967bb406ad0), MIT license retained. Build with `docker build --platform linux/amd64 -t amp3-local .`. Deploy using examples/docker-compose.yml. Panel HTTP port 8443; complete setup using the private setup link in logs or data/setup-link.txt. Use a fresh persistent volume at /opt/cubecoders/amp3/data; no AMP 2 migration is implemented. Native game servers require systemd, host cgroup namespace, writable cgroup mount, SYS_ADMIN and NET_ADMIN, and unconfined AppArmor on applicable hosts. These weaken isolation; use a trusted dedicated Linux host. AMD64 only. Default package stream is preview. The reference reports Valheim startup on Unraid; this fork has not independently validated runtime. Back up data before updates.


## Images

This repository now packages AMP 3 exclusively. `ghcr.io/akurosia/amp-dockerized:latest` and `:amp3` refer to AMP 3; old AMP 2 images in the registry and Git history are not deleted. Do not upgrade an AMP 2 deployment in place using latest. Stop the old container and use a new data directory and the AMP 3 Compose configuration.

- [Standard Compose](examples/docker-compose.yml)
- [Unraid br0 static IP Compose](examples/docker-compose-unraid-br0.yml)
- [Docker CLI](examples/docker-run.sh)

GitHub Actions builds AMD64 on master changes to the Dockerfile or entrypoint, daily, and on manual dispatch. It verifies the installed AMP package before publishing. Package access is granted via GITHUB_TOKEN; GHCR package settings must allow repository write access.
