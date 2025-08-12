# --- (Plan B) Build de assets dentro de Docker ---
# Si YA generaste public/build en local, puedes saltarte este stage.
FROM node:24-alpine AS assets
WORKDIR /src
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn .yarn
COPY public public
RUN corepack enable && yarn install --immutable && yarn build

# --- Imagen final de Grafana con tus overrides ---
FROM grafana/grafana-oss:10.4.2
USER root

# Si ya tienes public/build local, copia esa carpeta en lugar de usar el stage "assets".
# COPY public/build/ /usr/share/grafana/public/build/
COPY --from=assets /src/public/build/ /usr/share/grafana/public/build/

# Tus cambios visuales:
COPY public/views/  /usr/share/grafana/public/views/
COPY public/img/    /usr/share/grafana/public/img/
COPY conf/          /etc/grafana/

RUN chown -R grafana:grafana /usr/share/grafana /etc/grafana
USER grafana
