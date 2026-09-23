# Default Dockerfile
#
# @link     https://www.hyperf.io
# @document https://hyperf.wiki
# @contact  group@hyperf.io
# @license  https://github.com/hyperf/hyperf/blob/master/LICENSE

FROM hyperf/hyperf:8.1-alpine-v3.18-swoole
LABEL maintainer="Hyperf Developers <group@hyperf.io>" version="1.0" license="MIT" app.name="Hyperf"

##
# ---------- env settings ----------
##
# --build-arg timezone=UTC
ARG timezone
ARG app_env=prod

ENV TIMEZONE=${timezone:-"UTC"} \
    APP_ENV=${app_env} \
    SCAN_CACHEABLE=(true)

# update
RUN set -ex \
    # install tini
    && apk add --no-cache tini \
    # show php version and extensions
    && php -v \
    && php -m \
    && php --ri swoole \
    #  ---------- some config ----------
    && cd /etc/php* \
    # - config PHP
    && { \
        echo "upload_max_filesize=128M"; \
        echo "post_max_size=128M"; \
        echo "memory_limit=1G"; \
        echo "date.timezone=${TIMEZONE}"; \
    } | tee conf.d/99_overrides.ini \
    # - config timezone
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    # ---------- clear works ----------
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

WORKDIR /opt/www

# 复制项目文件
COPY . /opt/www/

# 安装依赖并验证
RUN set -ex \
    && ls -la /opt/www \
    && echo "Installing Composer dependencies..." \
    && echo "APP_ENV is: $APP_ENV" \
    && if [ "$APP_ENV" = "dev" ]; then \
        echo "Installing with dev dependencies..."; \
        composer install -o; \
    else \
        echo "Installing without dev dependencies..."; \
        composer install --no-dev -o; \
    fi \
    && echo "Generating autoload files..." \
    && composer dump-autoload -o \
    && echo "Verifying vendor directory..." \
    && ls -la /opt/www/vendor \
    && echo "Verifying autoload.php..." \
    && ls -la /opt/www/vendor/autoload.php \
    && echo "Checking autoload.php contents..." \
    && cat /opt/www/vendor/autoload.php \
    && echo "Running Hyperf..." \
    && php bin/hyperf.php

# 修改目录权限
RUN chmod -R 777 runtime

EXPOSE 9501
EXPOSE 9502

# 使用 tini 作为 init 进程
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["php", "/opt/www/bin/hyperf.php", "start"]
