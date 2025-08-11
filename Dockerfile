# ----------------- Fase UI (compila /public/build) -----------------
FROM node:20-alpine AS ui-build

WORKDIR /src
# Toolchain y compatibilidad C (algunos paquetes nativos lo requieren)
RUN apk add --no-cache git python3 make g++ libc6-compat

# Yarn (berry) con corepack
RUN corepack enable

# Ajustes que suelen resolver el fallo de install
ENV YARN_CACHE_FOLDER=/yarn-cache \
    YARN_ENABLE_IMMUTABLE_INSTALLS=false \
    YARN_ENABLE_INLINE_BUILDS=false \
    NODE_OPTIONS=--max-old-space-size=2048

# Archivos de Yarn / monorepo
COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn .yarn

# Código necesario para el build (añade aquí lo que uses en tu fork)
COPY public public
COPY packages packages
COPY scripts scripts
COPY emails emails
COPY tsconfig.json .
COPY .browserslistrc ./
COPY .prettierrc.js ./
COPY eslint.config.js ./
COPY .editorconfig ./

# Instala deps con caché y sin ejecutar builds inline
RUN --mount=type=cache,target=/yarn-cache \
    yarn install --mode=skip-build --no-progress

# Compila el frontend
RUN yarn build
