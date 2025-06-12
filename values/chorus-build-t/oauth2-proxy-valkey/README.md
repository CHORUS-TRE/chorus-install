# Oauth2-proxy Valkey

## Why

`oauth2-proxy` will be used to secure various bits of the infrastructure, such as, Prometheus or Alertmanager, that don't come with out of the box solution. Since we're using Keycloak, storing the credentials in the cookie is not good enough, hence that credential must be stored somewhere.

See: <https://oauth2-proxy.github.io/oauth2-proxy/configuration/session_storage/#redis-storage>
