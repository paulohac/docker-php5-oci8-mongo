FROM php:5.6-apache

ADD oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /opt
ADD oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /opt
ADD oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb /opt

RUN apt-get update \
 && apt-get -y install wget curl build-essential libaio1  libsasl2-dev libssl-dev libpq-dev libpq5 pkg-config \
 && docker-php-ext-install mysqli \
 && docker-php-ext-install pgsql \
 \
 # Install Oracle Instant Client
 && wget https://artifactory.softbox.com.br:8087/artifactory/binaries/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb \
 && wget https://artifactory.softbox.com.br:8087/artifactory/binaries/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb \
 && wget https://artifactory.softbox.com.br:8087/artifactory/binaries/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb \
 && dpkg -i /opt/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb \
 && dpkg -i /opt/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb \
 && dpkg -i /opt/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb \
 && pecl install -f oci8-2.0.11 \
 && docker-php-ext-enable oci8 \
 \
 # Install the OCI8 PHP extension
 && pecl install oci8-2.0.11 \
 && docker-php-ext-enable oci8 \
 \
 # Install mongoDB PHP extension
 && pecl install mongo \
 && docker-php-ext-enable mongo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 \
 # Enable Apache2 modules
 && a2enmod rewrite \
 && a2enmod proxy \
 && a2enmod proxy_http \
 && a2enmod proxy_wstunnel

# Set up the Apache2 environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
