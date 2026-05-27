#!/bin/bash
set -e

# UUID: 必须通过环境变量 VLESS_UUID 设置，否则每次重启变化
UUID="${VLESS_UUID:-$(cat /proc/sys/kernel/random/uuid 2>/dev/null || uuidgen)}"
WS_PATH="${WS_PATH:-/ws}"
PORT="${PORT:-8080}"

# 注入配置
sed -i "s/UUID_PLACEHOLDER/${UUID}/" config.json
sed -i "s|PATH_PLACEHOLDER|${WS_PATH}|" config.json
sed -i "s/PORT_PLACEHOLDER/${PORT}/" config.json

echo "==============================="
echo " Xray VLESS + WS"
echo " Port    : ${PORT}"
echo " WS Path : ${WS_PATH}"
echo " UUID    : ${UUID}"
echo "==============================="

exec xray run -c config.json
