FROM grafana/grafana-oss:10.4.2

USER root

RUN mkdir -p /usr/share/grafana/public/img \
    /usr/share/grafana/public/css \
    /usr/share/grafana/public/views

# Config personalizada
COPY --chown=grafana:grafana conf/ /etc/grafana/

# Solo copia lo que exista en tu repo
# (mantén estas líneas si esos ficheros existen)
COPY --chown=grafana:grafana public/img/fav32.png            /usr/share/grafana/public/img/fav32.png
COPY --chown=grafana:grafana public/img/apple-touch-icon.png /usr/share/grafana/public/img/apple-touch-icon.png
COPY --chown=grafana:grafana public/img/grafana_mask_icon.svg /usr/share/grafana/public/img/grafana_mask_icon.svg

# Si NO tienes custom.css, NO pongas esta línea
# COPY --chown=grafana:grafana public/css/custom.css /usr/share/grafana/public/css/custom.css

USER grafana
