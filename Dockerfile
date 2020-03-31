FROM php:7.3-fpm

LABEL maintainer="Paul Redmond"

RUN curl --silent --show-error --fail --location \
    --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \ 
    "https://caddyserver.com/download/linux/amd64?plugins=http.expires,http.realip&license=personal" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version \
    && docker-php-ext-install mbstring pdo pdo_mysql \
    && mkdir -p /usr/src/app/public

# COPY . /usr/src/app
COPY .docker/caddy/Caddyfile /etc/Caddyfile

WORKDIR /usr/src/app/

RUN chown -R www-data:www-data /usr/src/app

EXPOSE 80

CMD ["/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--log", "stdout"]