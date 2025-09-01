# ssh-over-http-wrapping-service

Simple wrapper around [wstunnel](https://github.com/erebe/wstunnel) to tunnel ssh over http.

This service wraps ssh into a http (ws) connection.
It must be used together with [ssh-over-http-unwrapping-service](https://github.com/cecemel/ssh-over-http-unwrapping-service).

## Rationale

wstunnel is a good tool to escape constrained networks.
But sometimes you cannot install or run it on a machine.
Also, the ssh agent can be very restricted.

That is why this project wraps wstunnel in a docker image.
The goal is to make it as transparent as possible for the ssh agent.

## Usage
You need both:
- [ssh-over-http-wrapping-service](https://github.com/cecemel/ssh-over-http-wrapping-service)
- [ssh-over-http-unwrapping-service](https://github.com/cecemel/ssh-over-http-unwrapping-service)

The wrapping service sends ssh traffic wrapped in http to the unwrapping service.
The unwrapping service removes the http layer and forwards ssh to the target host.

### Example

Local machine is in a network that only allows http.
We want to ssh to `remote-server` outside this network.
We also need an `unwrapping-server` outside the network.

#### On local machine
```
docker run -p 22:22 \
  -e TARGET_HOST="remote-server:22" \
  -e UNWRAP_HOST="unwrapping-server:443" \
  cecemel/ssh-over-http-wrapping-service:0.0.1
```
#### On unwrapping server (outside network)
```
docker run -p 443:443 cecemel/ssh-over-http-unwrapping-service:0.0.1
```
#### Connect
```
ssh user@localhost
```
## Environment Variables
- `TARGET_HOST` (required)
  The final ssh target host and port.
  Example: `remote-server:22`
- `UNWRAP_HOST` (required)
  The host and port of the unwrapping service.
  Example: `unwrapping-server:443`
- `UNWRAP_HOST_TLS_ENABLED` (optional, default: `true`)
  Controls whether TLS is used for the connection to the unwrapping service.
