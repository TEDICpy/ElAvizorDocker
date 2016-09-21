FROM php:5-apache
MAINTAINER Lu Pa <admin@tedic.org>

ENV DEBIAN_FRONTEND noninteractive
ENV CODE /var/www/html
ENV REPO https://github.com/TEDICpy/ElAvizor.git

RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y \
		wget \
		git \
        	libfreetype6-dev \
        	libjpeg62-turbo-dev \
        	libmcrypt-dev \
        	libpng12-dev \
	&& apt-get clean \
	&& docker-php-ext-install -j$(nproc) iconv mcrypt \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 	&& docker-php-ext-install -j$(nproc) gd \
	&& docker-php-ext-install -j$(nproc) mysql mysqli pdo pdo_mysql \
	&& a2enmod rewrite

# Descargo el codigo de ea
RUN git clone https://github.com/TEDICpy/ElAvizor.git $CODE \
	&& git checkout -b escuelasquecaen origin/escuelasquecaen

# Copio las configuraciones
ADD phps/* /var/www/html/application/config/

# Para colocar conf de php especificas
ADD customphp.ini /usr/local/etc/php/conf.d/

WORKDIR $CODE
