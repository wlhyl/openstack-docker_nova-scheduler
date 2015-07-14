#!/bin/bash

if [ -z "$NOVA_DBPASS" ];then
  echo "error: NOVA_DBPASS not set"
  exit 1
fi

if [ -z "$NOVA_DB" ];then
  echo "error: NOVA_DB not set"
  exit 1
fi

if [ -z "$RABBIT_HOST" ];then
  echo "error: RABBIT_HOST not set"
  exit 1
fi

if [ -z "$RABBIT_USERID" ];then
  echo "error: RABBIT_USERID not set"
  exit 1
fi

if [ -z "$RABBIT_PASSWORD" ];then
  echo "error: RABBIT_PASSWORD not set"
  exit 1
fi

if [ -z "$MY_IP" ];then
  echo "error: MY_IP not set. my_ip use management interface IP address of nova-api."
  exit 1
fi

CRUDINI='/usr/bin/crudini'

CONNECTION=mysql://nova:$NOVA_DBPASS@$NOVA_DB/nova

if [ ! -f /etc/nova/.complete ];then
    cp -rp /nova/* /etc/nova

    chown nova:nova /var/log/nova/

    $CRUDINI --set /etc/nova/nova.conf database connection $CONNECTION

    $CRUDINI --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

    $CRUDINI --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
    $CRUDINI --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid $RABBIT_USERID
    $CRUDINI --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password $RABBIT_PASSWORD

    $CRUDINI --set /etc/nova/nova.conf DEFAULT my_ip $MY_IP

    $CRUDINI --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

    touch /etc/nova/.complete
fi

/usr/bin/supervisord -n