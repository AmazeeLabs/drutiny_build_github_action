FROM amazeeio/php:7.4-cli

ADD entrypoint.sh /entrypoint.sh
COPY php.ini /usr/local/etc/php/
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
