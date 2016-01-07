# image name lzh/nova-scheduler:liberty
FROM 10.64.0.50:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-01-07
ENV OPENSTACK_VERSION liberty
ENV BUID_VERSION 2015-01-07

RUN yum update -y && \
         yum install -y openstack-nova-scheduler && \
         rm -rf /var/cache/yum/*

RUN cp -rp /etc/nova/ /nova && \
         rm -rf /etc/nova/* && \
         rm -rf /var/log/nova/*

VOLUME ["/etc/nova"]
VOLUME ["/var/log/nova"]

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD nova-scheduler.ini /etc/supervisord.d/nova-scheduler.ini

ENTRYPOINT ["/usr/bin/entrypoint.sh"]