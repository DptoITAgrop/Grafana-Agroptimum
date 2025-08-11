# Imagen base de Grafana
FROM grafana/grafana-oss:10.4.2

USER root

# IMPORTANTE: NO copiar public/build (rompe el frontend)
# Creamos directorios por si no existen
RUN mkdir -p /usr/share/grafana/public/img \
    && mkdir -p /usr/share/grafana/public/css \
    && mkdir -p /usr/share/grafana/public/views

# 1) Configuración personalizada (p.ej. conf/custom.ini)
COPY --chown=grafana:grafana conf/ /etc/grafana/

# 2) Branding / imágenes (solo los ficheros que cambias)
#    Copia explícita evita sobreescribir cosas no deseadas
#    Ajusta estas líneas a los nombres reales de tus archivos
COPY --chown=grafana:grafana public/img/fav32.png                 /usr/share/grafana/public/img/fav32.png
COPY --chown=grafana:grafana public/img/apple-touch-icon.png      /usr/share/grafana/public/img/apple-touch-icon.png
COPY --chown=grafana:grafana public/img/grafana_mask_icon.svg     /usr/share/grafana/public/img/grafana_mask_icon.svg
# Si tienes más imágenes, añade más COPY aquí

# 3) CSS propio (opcional)
#   Si no tienes, comenta esta línea
COPY --chown=grafana:grafana public/css/custom.css                /usr/share/grafana/public/css/custom.css

# 4) Vistas personalizadas (opcional; NUNCA copiar public/build)
#   Si modificas alguna vista concreta, descomenta:
# COPY --chown=grafana:grafana public/views/                        /usr/share/grafana/public/views/

# Asegura permisos correctos
RUN chown -R grafana:grafana \
      /etc/grafana \
      /usr/share/grafana/public/img \
      /usr/share/grafana/public/css \
      /usr/share/grafana/public/views

USER grafana
