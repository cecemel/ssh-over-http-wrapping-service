#!/bin/sh

if [ -z "$TARGET_HOST" ]; then
    echo "Error: TARGET_HOST environment variable is not set."
    exit 1
fi

if [ -z "$UNWRAP_HOST" ]; then
    echo "Error: UNWRAP_HOST environment variable is not set."
    exit 1
fi

echo "Starting socat"
socat TCP-LISTEN:22,fork TCP:127.0.0.1:2222 &
echo "Starting wstunnel"
exec wstunnel client --log-lvl DEBUG -L tcp://2222:$TARGET_HOST:22 wss://$UNWRAP_HOST:443
