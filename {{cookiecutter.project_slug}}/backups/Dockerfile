FROM postgres:17.5
WORKDIR /root
RUN apt-get update && apt-get install -y cron zstd
COPY --chmod=0755 docker-entrypoint.sh /
COPY --chmod=0644 cron.d/backup /etc/cron.d/backup
COPY bin ./

CMD ["/docker-entrypoint.sh"]