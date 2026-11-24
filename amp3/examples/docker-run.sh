#!/usr/bin/env bash
set -euo pipefail

IMAGE=ghcr.io/akurosia/amp-dockerized:amp3
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
DATA_DIR=${AMP3_DATA_DIR:-"$PROJECT_ROOT/amp3data"}

mkdir -p "$DATA_DIR"
docker pull --platform linux/amd64 "$IMAGE"

docker run -d \
  --name amp3 \
  --restart unless-stopped \
  --cgroupns host \
  --tty \
  --cap-add SYS_ADMIN \
  --cap-add NET_ADMIN \
  --security-opt apparmor=unconfined \
  --tmpfs /run \
  --tmpfs /run/lock \
  --volume "$DATA_DIR:/opt/cubecoders/amp3/data" \
  --volume /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --publish 8443:8443/tcp \
  --env PORT=8443 \
  --env TZ=Etc/UTC \
  "$IMAGE"

echo "AMP 3 is starting. Complete the first-run wizard at http://localhost:8443/."
echo "Add -p HOST:CONTAINER/tcp or /udp mappings for each game server port you use."
