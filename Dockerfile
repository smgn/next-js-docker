FROM node:14.15-alpine3.12 AS installer

ENV SERVICE_HOME /app

COPY . ${SERVICE_HOME}
WORKDIR ${SERVICE_HOME}

RUN printf "\n>>> add packages\n" && \
    apk add --no-cache make gcc g++ python3 && \
    printf "\n>>> build\n" && \
    npm ci --only=production && \
    npm run build && \
    rm -f .npmrc

FROM node:14.15-alpine3.12 AS release

ENV SERVICE_USER app
ENV SERVICE_HOME /app
WORKDIR ${SERVICE_HOME}

COPY --from=installer ${SERVICE_HOME} ${SERVICE_HOME}

RUN printf "\n>>> update & upgrade\n" && \
    apk --no-cache update && \
    apk --no-cache upgrade && \
    printf "\n>>> add packages\n" && \
    apk add --no-cache dumb-init && \
    printf "\n>>> create user\n" && \
    addgroup -S ${SERVICE_USER} && \
    adduser -h ${SERVICE_HOME} -s /bin/false -G ${SERVICE_USER} -S -g ${SERVICE_USER} ${SERVICE_USER} && \
    chown ${SERVICE_USER}:${SERVICE_USER} ${SERVICE_HOME} && \
    printf "\n>>> harden.sh\n" && \
    ${SERVICE_HOME}/harden.sh

USER ${SERVICE_USER}

EXPOSE 3000

# With dumb-init as the entry point, node is not PID 1
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "npm", "start" ]