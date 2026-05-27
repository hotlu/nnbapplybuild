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

# 解码 ARGO_AUTH，提取隧道 ID 和写入凭据文件
echo "${ARGO_AUTH}" | base64 -d > /tmp/tunnel-raw.json
TUNNEL_ID=$(cat /tmp/tunnel-raw.json | grep -o '"t":"[^"]*"' | cut -d'"' -f4)
ACCOUNT_TAG=$(cat /tmp/tunnel-raw.json | grep -o '"a":"[^"]*"' | cut -d'"' -f4)
TUNNEL_SECRET=$(cat /tmp/tunnel-raw.json | grep -o '"s":"[^"]*"' | cut -d'"' -f4)

# 写入 cloudflared 凭据文件
cat > /tmp/tunnel-creds.json <<EOF
{
  "AccountTag": "${ACCOUNT_TAG}",
  "TunnelSecret": "${TUNNEL_SECRET}",
  "TunnelID": "${TUNNEL_ID}"
}
EOF

# 写入 cloudflared 配置
cat > /tmp/cloudflared.yml <<EOF
tunnel: ${TUNNEL_ID}
credentials-file: /tmp/tunnel-creds.json
ingress:
  - hostname: ${ARGO_DOMAIN}
    service: http://127.0.0.1:8001
  - service: http_status:404
EOF

echo "Tunnel ID: ${TUNNEL_ID}"

# 启动 cloudflared（前台）
exec cloudflared tunnel --no-autoupdate --config /tmp/cloudflared.yml run
