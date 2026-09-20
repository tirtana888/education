#!/bin/sh
set -eu

mkdir -p /var/lib/redis
exec redis-server \
  --dir /var/lib/redis \
  --appendonly yes \
  --protected-mode no
