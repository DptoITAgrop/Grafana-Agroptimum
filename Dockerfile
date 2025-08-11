# Imagen final de Grafana
FROM grafana/grafana-oss:10.4.2
USER root

# Copiamos SOLO lo que personalizas y lo que ya está generado
# (no copiamos node_modules ni código TS/TSX)
COPY public/build/  /usr/share/grafana/public/build/
COPY public/views/  /usr/share/grafana/public/views/
COPY public/img/    /usr/share/grafana/public/img/
COPY conf/          /etc/grafana/

# Permisos
RUN chown -R grafana:grafana /usr/share/grafana /etc/grafana
USER grafana
