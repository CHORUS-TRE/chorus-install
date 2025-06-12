# kube-prometheus-stack

The Prometheus stack currently deploys:

- Prometheus;
- Alertmanager;
- and a configuration to push alerts to Webex.

## Securing the endpoints

Prometheus and Alertmanager are secured using oauth2-proxy sharing the same OIDC client `prometheus`. Set up in Keycloak's realm: **build**.

See how to setup the [client in Keycloak for oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/configuration/providers/keycloak_oidc/).
