FROM php:5-apache
MAINTAINER Lu Pa <admin@tedic.org>

ENV DEBIAN_FRONTEND noninteractive
ENV CODE /var/www/html
ENV REPO https://github.com/TEDICpy/ElAvizor.git
ENV REPOTEMA https://github.com/TEDICpy/elAvizor2015.git

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
		git \
        	libfreetype6-dev \
        	libjpeg62-turbo-dev \
        	libmcrypt-dev \
        	libpng-dev \
		libc-client2007e-dev \
		libkrb5-dev \ 
	&& apt-get clean \
	&& docker-php-ext-install -j$(nproc) iconv mcrypt \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install -j$(nproc) mysql mysqli pdo pdo_mysql \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install -j$(nproc) imap \
	&& a2enmod rewrite

# Descargo el codigo de ea
RUN git clone $REPO $CODE \
	&& git checkout -b escuelasquecaen origin/escuelasquecaen

# Para el tema
WORKDIR $CODE/themes
RUN git submodule add $REPOTEMA

# Copio las configuraciones
ADD phps/* /var/www/html/application/config/

# Para colocar conf de php especificas
ADD customphp.ini /usr/local/etc/php/conf.d/

WORKDIR $CODE
