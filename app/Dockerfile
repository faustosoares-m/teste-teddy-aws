FROM nginx:alpine

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dados_ecs.sh

CMD ["/usr/local/bin/startup.sh"]