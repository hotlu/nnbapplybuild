FROM alpine:3.19

RUN apk add --no-cache curl unzip bash nginx

# Download Xray-core
RUN curl -Lo /tmp/xray.zip \
    "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" \
    && unzip /tmp/xray.zip xray -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/xray \
    && rm /tmp/xray.zip

WORKDIR /app

COPY config.json    config.json
COPY nginx.conf     /etc/nginx/nginx.conf
COPY entrypoint.sh  entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["./entrypoint.sh"]
