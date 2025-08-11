# Dockerfile
FROM grafana/grafana-oss:10.4.2

USER root

# 1) Config opcional
COPY --chown=grafana:grafana conf/custom.ini /etc/grafana/custom.ini

# 2) Solo tus overrides:
#   - Iconos/imagenes
COPY --chown=grafana:grafana public/img/ /usr/share/grafana/public/img/
#   - Login (si lo cambiaste)
COPY --chown=grafana:grafana public/views/login.html /usr/share/grafana/public/views/login.html
#   - Index (solo si lo cambiaste)
# COPY --chown=grafana:grafana public/views/index.html /usr/share/grafana/public/views/index.html

USER grafana
