# 环境变量
- NOVA_DB: nova数据库IP
- NOVA_DBPASS： novae数据库密码
- RABBIT_HOST: rabbitmq IP
- RABBIT_USERID: rabbitmq user
- RABBIT_PASSWORD: rabbitmq user 的 password
- MY_IP: my_ip

# volumes:
- /opt/openstack/nova-scheduler/: /etc/nova
- /opt/openstack/log/nova-scheduler/: /var/log/nova/

# 启动nova-scheduler
```bash
docker run -d --name nova-scheduler \
    -v /opt/openstack/nova-scheduler/:/etc/nova \
    -v /opt/openstack/log/nova-scheduler/:/var/log/nova/ \
    -e NOVA_DB=10.64.0.52 \
    -e NOVA_DBPASS=nova_dbpass \
    -e RABBIT_HOST=10.64.0.52 \
    -e RABBIT_USERID=openstack \
    -e RABBIT_PASSWORD=openstack \
    -e MY_IP=10.64.0.52 \
    10.64.0.50:5000/lzh/nova-consoleauth:kilo
```