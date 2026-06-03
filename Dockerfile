FROM grafana/grafana-oss:13.0.2

USER root

# Configuración personalizada
COPY --chown=grafana:grafana conf/ /etc/grafana/

# Assets personalizados (login, logos, estilos, etc.)
COPY --chown=grafana:grafana public/build/ /usr/share/grafana/public/build/
COPY --chown=grafana:grafana public/views/ /usr/share/grafana/public/views/
COPY --chown=grafana:grafana public/img/ /usr/share/grafana/public/img/

USER grafana
