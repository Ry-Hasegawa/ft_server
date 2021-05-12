if [ $AUTOINDEX = "off" ]; then
	sed -i -e "s/autoindex on/autoindex off/" /etc/nginx/sites-available/default
elif [ $AUTOINDEX = "on" ]; then
	sed -i -e "s/autoindex off/autoindex on/" /etc/nginx/sites-available/default
fi
mkdir -p /etc/nginx/ssl
openssl req -newkey rsa:4096 \
	-x509 \
    -sha256 \
    -days 3650 \
    -nodes \
    -out /etc/nginx/ssl/example.crt \
    -keyout /etc/nginx/ssl/example.key \
    -subj "/C=JP/ST=42/L=TOKYO/O=42 TOKYO/OU=rhasegaw/CN=example.com"
service mysql start
mysql -u root -e "CREATE USER 'phppress'@'localhost' IDENTIFIED BY 'wordadmin'"
mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO 'phppress'@'localhost'"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress"
service php7.3-fpm start
service nginx start
tail -f