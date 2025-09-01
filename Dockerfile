FROM alpine:3.20

RUN apk update && \
    apk add --no-cache openssh-client socat

COPY ./wstunnel /usr/bin/wstunnel

RUN chmod +x /usr/bin/wstunnel

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]