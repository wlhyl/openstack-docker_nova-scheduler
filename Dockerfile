# image name lzh/nova-scheduler:liberty
FROM registry.lzh.site:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-12-24
ENV OPENSTACK_VERSION liberty
ENV BUILD_VERSION 2015-12-24

RUN yum update -y
RUN yum install -y openstack-nova-console
RUN yum clean all
RUN rm -rf /var/cache/yum/*

RUN cp -rp /etc/nova/ /nova
RUN rm -rf /etc/nova/*
RUN rm -rf /var/log/nova/*

VOLUME ["/etc/nova"]
VOLUME ["/var/log/nova"]

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD nova-scheduler.ini /etc/supervisord.d/nova-scheduler.ini

ENTRYPOINT ["/usr/bin/entrypoint.sh"]