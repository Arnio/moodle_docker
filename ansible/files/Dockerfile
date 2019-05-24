# Pull base image.
FROM centos:7


RUN yum -y install yum-plugin-fastestmirror httpd epel-release && \
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php73 

RUN yum install -y php \
        php-common php-mysqli php-mysqlnd php-pear php-mcrypt php-cli php-curl \
        php-ldap php-zip php-fileinfo php-xml php-intl php-gd \
        php-mbstring php-xmlrpc php-soap php-redis && \
    yum clean all
# RUN sed -i -e 's/session.save_handler = files/session.save_handler = redis/g' /etc/php.ini && \
#     sed -i -e "s+;session.save_path = \"/tmp\"+session.save_path = \"tcp://10.0.0.4:6379\"+g" /etc/php.ini

COPY . /var/www/html/

COPY /tmp/ansible/files/config.php /tmp/config.php

RUN mkdir -p /var/moodledata && chown -R apache:apache /var/moodledata
# sed -i -e 's+DirectoryIndex index.html+DirectoryIndex index.php index.html index.htm+g' /etc/httpd/conf/httpd.conf
EXPOSE 80
CMD ["/usr/bin/php", "/var/www/html/admin/cli/install.php \
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
      --agree-license", "&&",]
      
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]




CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]