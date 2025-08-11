# Dockerfile
FROM grafana/grafana-oss:10.4.2

USER root

# Copiamos tu interfaz ya compilada
COPY --chown=grafana:grafana public/ /usr/share/grafana/public/
# Y configuración/branding que haya en conf/
COPY --chown=grafana:grafana conf/ /etc/grafana/

USER grafana
