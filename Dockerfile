# Dockerfile

FROM grafana/grafana-oss:12.1.0

USER root

# Copiar interfaz personalizada
COPY public /usr/share/grafana/public
COPY conf /etc/grafana

USER grafana
