# Dockerfile

FROM grafana/grafana-oss:10.4.2

USER root

# Copiar interfaz personalizada
COPY public /usr/share/grafana/public
COPY conf /etc/grafana

USER grafana
