
source common.sh

print_head "download redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
status_check

print_head "Enable Redis 6.2 from package streams."
yum module enable redis:remi-6.2 -y
status_check

print_head "install redis."
yum install redis -y

print_head "Update listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/g'  /etc/redis.conf  /etc/redis/redis.conf  &>>${LOG}
status_check

print_head "start redis"
systemctl start redis  &>>${LOG}
status_check

print_head "enable redis"
systemctl enable redis  &>>${LOG}
status_check

print_head "restart redis"
systemctl restart redis  &>>${LOG}
status_check