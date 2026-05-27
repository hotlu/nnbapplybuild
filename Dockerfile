FROM alpine:3.19

RUN apk add --no-cache curl unzip bash

# Download Xray-core
RUN curl -Lo /tmp/xray.zip \
    "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" \
    && unzip /tmp/xray.zip xray -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/xray \
    && rm /tmp/xray.zip

WORKDIR /app

COPY config.json    config.json
COPY entrypoint.sh  entrypoint.sh
RUN chmod +x entrypoint.sh

# Apply.Build 边缘层负责 TLS，容器只需监听 HTTP
EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
