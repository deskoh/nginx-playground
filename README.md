# NGINX Playground

## HTTP LoadBalancing

### HTTP TLS Termination

```sh
# Expose ports for nginx-tcp
docker-compose --env-file ./config/http-tls-termination.env up -d nginx-http

curl --cacert certs/server/serverCA.crt \
     https://localhost:8443/get?show_env=1
```

### HTTP Mutual TLS Termination

```sh
# Expose nginx-tcp ports
docker-compose --env-file ./config/http-mtls-termination.env up -d nginx-http

curl --cacert certs/server/serverCA.crt \
     --cert certs/client/client.crt --key certs/client/client.key \
     https://localhost:8443/get?show_env=1
```

### PROXY Protocol

```sh
PROXY_PROTOCOL=proxy_protocol docker-compose --env-file ./config/http-tls-termination.env up -d nginx-http

# Without TLS Termination
docker-compose --env-file ./config/tcp-passthrough.env up -d docker-nlb
# With TLS Termination
PROXY_PORT=8443 docker-compose --env-file ./config/tcp-passthrough.env up -d docker-nlb
docker-compose logs -f

# Without TLS Termination
curl http://localhost:8080/get?show_env=1
# With TLS Termination
curl --cacert certs/server/serverCA.crt \
     https://localhost:8080/get
```

## TCP LoadBalancing

### TCP TLS Termination

```sh
# Expose ports for nginx-tcp
docker-compose --env-file ./config/tcp-tls-termination.env up nginx-tcp

curl --cacert certs/server/serverCA.crt \
     https://localhost:8443/get
```

### TCP PROXY Protocol

```sh
# With TLS Termination
PROXY_PROTOCOL=proxy_protocol docker-compose --env-file ./config/tcp-tls-termination.env up -d nginx-tcp

docker-compose --env-file ./config/tcp-tls-termination.env up -d docker-nlb
docker-compose logs -f

curl http://localhost:8080/get?show_env=1
```

### TCP Mutual TLS Termination

```sh
# Expose nginx-tcp ports
docker-compose --env-file ./config/tcp-mtls-termination.env up nginx-tcp

curl --cacert certs/server/serverCA.crt \
     --cert certs/client/client.crt --key certs/client/client.key \
     https://localhost:8443/get?show_env=1
```

## References

https://github.com/10up/nginx_configs

https://docs.nginx.com/nginx/admin-guide/load-balancer/using-proxy-protocol/

https://stackoverflow.com/a/40331256

https://forum.nginx.org/read.php?2,215830,215832#msg-215832

https://github.com/deskoh/docker-nginx-mtls/blob/main/config/templates/conf.d/default.conf
s
