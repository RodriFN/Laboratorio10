# Usa una imagen base de Debian para instalar Apache, Perl y MariaDB
FROM debian:latest

# Actualiza e instala los paquetes necesarios
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-perl2 perl mariadb-server dos2unix \
    libdbi-perl libdbd-mysql-perl vim && \
    apt-get clean

# Habilita el módulo CGI de Apache
RUN a2dismod mpm_event mpm_worker cgid && \
    a2enmod mpm_prefork cgi

# Copia los scripts Perl
RUN mkdir -p /usr/lib/cgi-bin/
COPY cgi-bin/ /usr/lib/cgi-bin/

# Crear directorio para HTML
RUN mkdir -p /var/www/html
RUN chmod -R 755 /var/www/html

# Asegurar permisos correctos para los scripts CGI
RUN chmod 755 /usr/lib/cgi-bin/*.pl && \
    chown -R www-data:www-data /usr/lib/cgi-bin/ && \
    dos2unix /usr/lib/cgi-bin/*.pl

# Copia todos los archivos del proyecto al directorio de Apache
COPY . /var/www/html/

# Copia el archivo de configuración de Apache
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando para iniciar MariaDB y Apache en formato JSON (exec)
CMD ["bash", "-c", "mysqld_safe & apache2ctl -D FOREGROUND"]