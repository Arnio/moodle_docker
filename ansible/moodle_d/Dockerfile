# Pull base image.
FROM centos:7


RUN yum -y update && yum -y install httpd yum-utils && \
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php72 && \
    yum -y install php php-common php-mysqli php-mysqlnd php-pear php-mcrypt php-cli \ 
    php-gd php-curl php-mbstring php-xmlrpc php-soap php-ldap php-zip php-fileinfo php-xml php-intl php-redis
RUN yum clean all
RUN sed -i -e 's/session.save_handler = files/session.save_handler = redis/g' /etc/php.ini && \
    sed -i -e "s+;session.save_path = \"/tmp\"+session.save_path = \"tcp://10.0.0.4:6379\"+g" /etc/php.ini

COPY . /var/www/html/

RUN mkdir -p /var/moodledata && chown -R apache:apache /var/moodledata 

RUN /usr/bin/php /var/www/html/admin/cli/install.php \
      --lang=en \
      --dbtype=mysqli \
      --wwwroot=http://35.244.247.63/ \
      --dataroot=/var/moodledata \
      --dbhost=localhost \
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

COPY /tmp/ansible/files/config.php /var/www/html/

CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]

EXPOSE 80

