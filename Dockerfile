# -----------------------------------------------------------------------------
# 1) Construcción del FRONTEND (yarn build)
#    Copiamos lo mínimo imprescindible para que yarn tenga todo lo necesario.
#    Si tu repo tiene carpetas adicionales, añádelas igual que abajo.
# -----------------------------------------------------------------------------
FROM node:20-alpine AS ui-build

WORKDIR /src
RUN apk add --no-cache git python3 make g++

# Archivos de yarn/monorepo
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn .yarn

# Código necesario para el build del frontend
COPY public public
COPY packages packages
COPY emails emails
COPY scripts scripts
COPY tsconfig.json .
COPY .browserslistrc ./
COPY .prettierrc.js ./
COPY eslint.config.js ./
COPY .editorconfig ./

# Si en tu fork existen estas rutas, descoméntalas y cópialas:
# COPY plugin* plugin*
# COPY apps apps

ENV NODE_ENV=production
RUN yarn install --immutable --inline-builds
RUN yarn build

# -----------------------------------------------------------------------------
# 2) Imagen final de GRAFANA
#    Reutilizamos el binario oficial y solo sustituimos los assets compilados.
# -----------------------------------------------------------------------------
FROM grafana/grafana-oss:12.1.0

USER root

# Tu configuración (si la tienes)
COPY --chown=grafana:grafana conf/ /etc/grafana/

# Resultado del build del frontend
COPY --from=ui-build /src/public/build/ /usr/share/grafana/public/build/

# Assets estáticos personalizados (opcional)
COPY --chown=grafana:grafana public/img/  /usr/share/grafana/public/img/
# Si tienes CSS propios:
# COPY --chown=grafana:grafana public/css/ /usr/share/grafana/public/css/
# Si modificaste el index.html (normalmente no hace falta):
# COPY --chown=grafana:grafana public/views/index.html /usr/share/grafana/public/views/index.html

USER grafana
