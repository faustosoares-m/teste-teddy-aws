FROM nginx:alpine

RUN apk update && apk add --no-cache curl jq bash

COPY dados_ecs.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dados_ecs.sh

ENTRYPOINT ["/usr/local/bin/dados_ecs.sh"]