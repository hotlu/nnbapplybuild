#!/bin/bash
set -e

UUID="${VLESS_UUID:-8929f8b4-8245-40eb-850f-82a1e84b319f}"
ARGO_AUTH="${ARGO_AUTH:-}"
ARGO_DOMAIN="${ARGO_DOMAIN:-applybuild.rrnzr.pp.ua}"

# 注入 UUID
sed -i "s/UUID_PLACEHOLDER/${UUID}/" sing-box.json

echo "==============================="
echo " Argo + sing-box VLESS+WS"
echo " UUID      : ${UUID}"
echo " Domain    : ${ARGO_DOMAIN}"
echo "==============================="

# 启动 sing-box（后台）
sing-box run -c sing-box.json &

# 启动 nginx 健康检查（后台）
nginx -g 'daemon off;' &

# 启动 cloudflared Argo 隧道（前台）
exec cloudflared tunnel --no-autoupdate run --token "${ARGO_AUTH}"
