FROM php:8.1-apache

MAINTAINER Imanuel Chandra Lefta <lefta.chandra@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

#install GD
RUN apt-get update && apt-get install -y \
                libfreetype-dev \
                libjpeg62-turbo-dev \
                libpng-dev \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install -j$(nproc) gettext

RUN apt-get update && apt-get install -y \
        libonig-dev \
    && docker-php-ext-install -j$(nproc) mbstring

# RUN apt-get update && apt-get install -y \
#         libmcrypt-dev \
#     && docker-php-ext-configure mcrypt \
#     && docker-php-ext-install -j$(nproc) mcrypt \
#     && docker-php-ext-enable mcrypt

RUN docker-php-ext-install -j$(nproc) pdo_mysql

RUN docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-enable mysqli


    # Build YAZ extension
RUN apt install -y yaz libyaz-dev
RUN pecl install yaz
RUN docker-php-ext-enable yaz

RUN apt clean


COPY ./config/httpd/apache2.conf /etc/apache2/apache2.conf
COPY ./config/httpd/sites-available/slims.conf /etc/apache2/sites-available/slims.conf

ARG DOCKER_USER_ARG=developer

RUN groupadd -g 1000 $DOCKER_USER_ARG
RUN useradd -d /home/$DOCKER_USER_ARG -ms /bin/bash $DOCKER_USER_ARG -u 1000 -g 1000

RUN mkdir /home/$DOCKER_USER_ARG/slims

RUN cd /etc/apache2/sites-available/
RUN a2ensite slims.conf
RUN a2dissite 000-default.conf


USER $DOCKER_USER_ARG

WORKDIR /home/$DOCKER_USER_ARG/slims