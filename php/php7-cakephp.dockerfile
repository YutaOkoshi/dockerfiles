FROM php:7-fpm

COPY docker/web/docker-php-ext-enable /usr/local/bin

# cakephpに必要そうなものインスコ
RUN apt-get update \
 && apt-get install -y git libcurl4-gnutls-dev zlib1g-dev libicu-dev g++ libxml2-dev libpq-dev unzip vim \
 && docker-php-ext-install pdo pdo_mysql intl curl json opcache xml

# RUN apt-get autoremove && apt-get autoclean
# RUN  rm -rf /var/lib/apt/lists/*

# composerのインタラクティブモードとか外す
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_NO_INTERACTION 1

# composerはコンテナイメージから取得
COPY --from=composer /usr/bin/composer /usr/bin/composer

# ひとまずphp-fpmは起動しておく
CMD php-fpm
