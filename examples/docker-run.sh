#!/usr/bin/env bash
set -e
# Set AMP_MAC to a unique, persistent locally administered unicast MAC.
: "${AMP_MAC:?Set AMP_MAC before running this script}"
docker run -d \
  --name amp \
  --restart unless-stopped \
  --network bridge \
  --mac-address "$AMP_MAC" \
  --shm-size=1g \
  --stop-timeout=120 \
  -p 8080:8080 \
  -v "$(pwd)/ampdata:/home/amp/" \
  -e UID=120 \
  -e GID=124 \
  -e TZ=Etc/UTC \
  ghcr.io/akurosia/amp-dockerized:latest
