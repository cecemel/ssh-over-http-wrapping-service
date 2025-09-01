#!/bin/sh

if [ -z "$TARGET_HOST" ]; then
    echo "Error: TARGET_HOST environment variable is not set."
    exit 1
fi

if [ -z "$UNWRAP_HOST" ]; then
    echo "Error: UNWRAP_HOST environment variable is not set."
    exit 1
fi

if [ "$UNWRAP_HOST_TLS_ENABLED" = "false" ]; then
    PROTOCOL="ws"
    echo "TLS is disabled, using protocol: $PROTOCOL"
else
    PROTOCOL="wss"
    echo "TLS is enabled, using protocol: $PROTOCOL"
fi

echo "Starting socat"
socat TCP-LISTEN:22,fork TCP:127.0.0.1:2222 &
echo "Starting wstunnel"
exec wstunnel client --log-lvl DEBUG -L tcp://2222:$TARGET_HOST $PROTOCOL://$UNWRAP_HOST
