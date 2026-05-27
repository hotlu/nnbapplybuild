FROM alpine:3.19

RUN apk add --no-cache curl bash nginx unzip

# 下载 sing-box（固定版本）
RUN curl -Lo /tmp/sb.tar.gz \
    "https://github.com/SagerNet/sing-box/releases/download/v1.10.7/sing-box-1.10.7-linux-amd64.tar.gz" \
    && tar -xzf /tmp/sb.tar.gz -C /tmp \
    && mv /tmp/sing-box-*/sing-box /usr/local/bin/sing-box \
    && chmod +x /usr/local/bin/sing-box \
    && rm -rf /tmp/sb.tar.gz /tmp/sing-box-*

# 下载 cloudflared（固定版本）
RUN curl -Lo /usr/local/bin/cloudflared \
    "https://github.com/cloudflare/cloudflared/releases/download/2024.11.0/cloudflared-linux-amd64" \
    && chmod +x /usr/local/bin/cloudflared

WORKDIR /app

COPY sing-box.json   sing-box.json
COPY nginx.conf      /etc/nginx/nginx.conf
COPY entrypoint.sh   entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
