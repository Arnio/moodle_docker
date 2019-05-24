
/usr/bin/php /var/www/html/admin/cli/install.php \
--lang=en \
--dbtype=mysqli \
--wwwroot=http://34.95.89.73/ \
--dataroot=/var/moodledata \
--dbhost=35.193.242.37 \
--dbname=moodledb \
--dbuser=root \
--dbpass=moodle123 \
--adminuser=admin \
--adminpass=Admin1 \
--adminemail='example@example.com' \
--fullname='Moodle' \
--shortname=moodle \
--summary='Moodle' \
--non-interactive \
--allow-unstable \
--agree-license
cp -r /tmp/config.php /var/www/html/config.php