#!/bin/bash
set -e

UUID="${VLESS_UUID:-$(cat /proc/sys/kernel/random/uuid 2>/dev/null)}"
WS_PATH="${WS_PATH:-/ws}"

# 注入 UUID 和 WS 路径到 Xray 配置
sed -i "s/UUID_PLACEHOLDER/${UUID}/" config.json
sed -i "s|PATH_PLACEHOLDER|${WS_PATH}|" config.json

# 同步 nginx.conf 里的 WS 路径
sed -i "s|location /ws|location ${WS_PATH}|" /etc/nginx/nginx.conf
sed -i "s|proxy_pass http://127.0.0.1:8388;|proxy_pass http://127.0.0.1:8388;|" /etc/nginx/nginx.conf

echo "==============================="
echo " Xray VLESS + WS"
echo " UUID    : ${UUID}"
echo " WS Path : ${WS_PATH}"
echo " Xray    : 127.0.0.1:8388"
echo " Nginx   : 0.0.0.0:8080"
echo "==============================="

# 后台启动 Xray
xray run -c config.json &

# 前台运行 nginx
exec nginx -g 'daemon off;'
