#!/bin/bash
php /var/www/html/admin/cli/install.php --lang=en --dbtype=mysqli --wwwroot=http://${global_address} --dataroot=/var/moodledata --dbhost=${db_server} --dbname=${db_name} --dbuser=${db_user} --dbpass=${db_pass} --adminuser=admin --adminpass=Admin1 --adminemail='example@example.com' --fullname='Moodle' --shortname=moodle --summary='Moodle' --non-interactive --allow-unstable --agree-license
cp -r config.php /var/www/html/config.php
chmod o+r /var/www/html/config.php
/usr/sbin/httpd -D FOREGROUND