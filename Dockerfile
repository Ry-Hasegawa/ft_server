FROM debian:buster

ENV AUTOINDEX=on
RUN apt-get -y update
RUN apt-get -y install --no-install-recommends\
	nginx openssl \
	mariadb-server \
	php-fpm php-mysql \
	php-mbstring php-xml\
	ca-certificates wget
COPY ./srcs/nginx_default /etc/nginx/sites-available/default
RUN wget -P /tmp https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.gz && \
	mkdir /var/www/html/phpmyadmin && tar zxvf /tmp/phpMyAdmin-5.1.0-all-languages.tar.gz -C /var/www/html/phpmyadmin --strip-components 1
RUN wget -P /tmp https://wordpress.org/latest.tar.gz && \
	mkdir /var/www/html/wordpress && tar zxvf /tmp/latest.tar.gz -C /var/www/html/wordpress --strip-components 1
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin
COPY ./srcs/wp-config.php /var/www/html/wordpress
RUN chown -R www-data /var/www/html/wordpress
RUN chown -R www-data /var/www/html/phpmyadmin
COPY ./srcs/init.sh /etc
RUN chmod 777 /etc/init.sh
CMD ["/bin/bash", "/etc/init.sh"]
