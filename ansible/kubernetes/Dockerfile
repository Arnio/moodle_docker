FROM centos:7
RUN yum -y install yum-plugin-fastestmirror httpd epel-release && \
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum-config-manager --enable remi-php73 

RUN yum install -y php \
        php-common php-mysqli php-pear php-mcrypt php-cli php-curl \
        php-ldap php-zip php-fileinfo php-xml php-intl php-gd \
        php-mbstring php-xmlrpc php-soap php-redis && \
    yum clean all
RUN sed -i -e 's/session.save_handler = files/session.save_handler = redis/g' /etc/php.ini 
#    sed -i -e "s+;session.save_path = \"/tmp\"+session.save_path = \"tcp://10.0.0.4:6379\"+g" /etc/php.ini
COPY ./moodlefile /var/www/html/
COPY ./kubernetes/config.php config.php

RUN mkdir -p /var/moodledata && chown -R apache:apache /var/moodledata

COPY ./kubernetes/docker-entrypoint.sh /
EXPOSE 80

CMD ["/bin/bash", "/docker-entrypoint.sh"]
