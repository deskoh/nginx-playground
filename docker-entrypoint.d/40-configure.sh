#!/bin/sh

mkdir -p /etc/nginx/certs/

export SERVER_CERT_CONFIG=""
export SERVER_KEY_CONFIG=""
export CLIENT_CA_CONFIG=""
export LISTEN_SSL_CONFIG=""
export RESOLVER_CONFIG=""
export PROXY_PROTOCOL_CONFIG="proxy_protocol off;"

# Need quotes to echo multi-line env var
[[ ! -z "$SERVER_CERT" ]] \
  && echo "$SERVER_CERT" > /etc/nginx/certs/server.crt \
  && export SERVER_CERT_CONFIG="ssl_certificate      /etc/nginx/certs/server.crt;"

[[ ! -z "$SERVER_KEY" ]] \
  && echo "$SERVER_KEY" > /etc/nginx/certs/server.key \
  && export SERVER_KEY_CONFIG="ssl_certificate_key  /etc/nginx/certs/server.key;"

[[ ! -z "$SERVER_CERT" ]] && [[ ! -z "$SERVER_KEY" ]] \
  && export LISTEN_SSL_CONFIG="listen  8443 ssl ${PROXY_PROTOCOL};"

[[ ! -z "$CLIENT_CA" ]] \
  && echo "$CLIENT_CA" > /etc/nginx/certs/clientCA.crt \
  && export CLIENT_CA_CONFIG="ssl_client_certificate  /etc/nginx/certs/clientCA.crt;
    ssl_verify_client       on;"

[[ ! -z "$RESOLVER" ]] \
  && export RESOLVER_CONFIG="resolver ${RESOLVER};"

[[ ! -z "$PROXY_PROTOCOL_SEND" ]] \
  && export PROXY_PROTOCOL_CONFIG="proxy_protocol on;"

/docker-entrypoint.d/20-envsubst-on-templates.sh
