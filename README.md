# VLESS + WS + TLS on Apply.Build

基于 Xray-core 的 VLESS over WebSocket 代理，部署在 Apply.Build 上。
Apply.Build 边缘层自动处理 TLS，容器内只跑明文 WS。

## 部署步骤

### 1. 推送到 GitHub

```bash
git init
git add .
git commit -m "init: vless+ws"
git remote add origin https://github.com/你的用户名/vless-ws-deploy.git
git push -u origin main
```

### 2. Apply.Build 配置

| 字段 | 填写 |
|------|------|
| 构建模式 | Dockerfile |
| Container Port | 8080 |
| Health Check Path | /ws |

### 3. 环境变量（必填）

在 Apply.Build → Environment Variables 中设置：

| 变量 | 说明 | 示例 |
|------|------|------|
| `VLESS_UUID` | 你的 UUID（固定，不然重启变化） | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `WS_PATH` | WebSocket 路径 | `/ws` |
| `PORT` | 监听端口，和 Container Port 一致 | `8080` |

生成 UUID：https://www.uuidgenerator.net/

## 客户端配置（v2rayN / Clash / sing-box）

| 参数 | 值 |
|------|----|
| 地址 | `你的域名.apps.apply.build` |
| 端口 | `443` |
| 协议 | VLESS |
| UUID | 你设置的 VLESS_UUID |
| 传输 | WebSocket |
| WS Path | `/ws` |
| TLS | 开启 |
| SNI | `你的域名.apps.apply.build` |
