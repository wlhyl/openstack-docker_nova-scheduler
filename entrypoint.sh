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

    $CRUDINI --set /etc/nova/nova.conf database connection $CONNECTION

    $CRUDINI --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

    $CRUDINI --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host $RABBIT_HOST
    $CRUDINI --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid $RABBIT_USERID
    $CRUDINI --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password $RABBIT_PASSWORD

    $CRUDINI --set /etc/nova/nova.conf DEFAULT my_ip $MY_IP

    $CRUDINI --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp
    $CRUDINI --set /etc/nova/nova.conf DEFAULT state_path /var/lib/nova
    
    $CRUDINI --set /etc/nova/nova.conf DEFAULT scheduler_driver nova.scheduler.filter_scheduler.FilterScheduler
    $CRUDINI --set /etc/nova/nova.conf DEFAULT scheduler_available_filters nova.scheduler.filters.all_filters
    $CRUDINI --set /etc/nova/nova.conf DEFAULT scheduler_default_filters AggregateInstanceExtraSpecsFilter,RetryFilter,AvailabilityZoneFilter,RamFilter,ComputeFilter,ComputeCapabilitiesFilter,ImagePropertiesFilter,ServerGroupAntiAffinityFilter,ServerGroupAffinityFilter

    $CRUDINI --set /etc/nova/nova.conf DEFAULT ram_allocation_ratio 1.0

    touch /etc/nova/.complete
fi

chown -R nova:nova /var/log/nova/

/usr/bin/supervisord -n