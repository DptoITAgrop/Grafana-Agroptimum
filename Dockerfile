FROM grafana/grafana-oss:10.4.2

USER root

# Configuración personalizada
COPY --chown=grafana:grafana conf/ /etc/grafana/

# Copia imágenes personalizadas
COPY --chown=grafana:grafana public/img/ /usr/share/grafana/public/img/

# Copia CSS personalizados
COPY --chown=grafana:grafana public/css/ /usr/share/grafana/public/css/

# Si modificaste vistas (HTML)
COPY --chown=grafana:grafana public/views/ /usr/share/grafana/public/views/

USER grafana
