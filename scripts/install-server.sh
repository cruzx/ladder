#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_DIR="${SKILL_DIR}/assets/server"
MARZBAN_DIR="/opt/marzban"
DATA_DIR="/var/lib/marzban"
TEMPLATE_DIR="${DATA_DIR}/templates/clash"
NIC_NAME="${NIC_NAME:-eth0}"

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
}

require_file "${SERVER_DIR}/marzban/.env"
require_file "${SERVER_DIR}/marzban/docker-compose.yml"
require_file "${SERVER_DIR}/caddy/Caddyfile"
require_file "${SERVER_DIR}/templates/clash-classic-default.yml"

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release ufw vnstat caddy

install -d -m 0755 /etc/apt/keyrings
if [[ ! -f /etc/apt/keyrings/docker.asc ]]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
fi

if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
    > /etc/apt/sources.list.d/docker.list
fi

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
systemctl enable --now caddy
systemctl enable --now vnstat

install -d -m 0755 "${MARZBAN_DIR}" "${DATA_DIR}" "${TEMPLATE_DIR}"
cp "${SERVER_DIR}/marzban/.env" "${MARZBAN_DIR}/.env"
cp "${SERVER_DIR}/marzban/docker-compose.yml" "${MARZBAN_DIR}/docker-compose.yml"
cp "${SERVER_DIR}/templates/clash-classic-default.yml" "${TEMPLATE_DIR}/default.yml"
cp "${SERVER_DIR}/caddy/Caddyfile" /etc/caddy/Caddyfile

ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8443/tcp
ufw allow 2053/tcp
ufw allow 2053/udp
ufw --force enable

vnstat --add -i "${NIC_NAME}" || true
systemctl restart vnstat

docker compose -f "${MARZBAN_DIR}/docker-compose.yml" up -d
systemctl restart caddy

echo
echo "Deployment finished."
echo "Next: update the Marzban core config with the VLESS Reality template and verify the subscription output."
