FROM hyperf/hyperf:8.1-alpine-v3.18-swoole

ARG timezone=Asia/Kuala_Lumpur
ARG app_env=prod

ENV TIMEZONE=${timezone} \
    APP_ENV=${app_env} \
    SCAN_CACHEABLE=(true)

RUN set -ex \
    && apk add --no-cache tini \
    && cd /etc/php* \
    && { \
        echo "upload_max_filesize=128M"; \
        echo "post_max_size=128M"; \
        echo "memory_limit=1G"; \
        echo "date.timezone=${TIMEZONE}"; \
    } | tee conf.d/99_overrides.ini \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && rm -rf /var/cache/apk/* /tmp/*

WORKDIR /opt/www

# .dockerignore limits context to app/, bin/, config/, composer.*
COPY . /opt/www/

RUN set -ex \
    && if [ "$APP_ENV" = "dev" ]; then \
        composer install -o; \
    else \
        composer install --no-dev -o; \
    fi \
    && mkdir -p runtime \
    && chmod -R 775 runtime

EXPOSE 9512

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php", "bin/hyperf.php", "start"]
