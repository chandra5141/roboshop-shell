set -e
source common.sh

print_head -e "copying mongodb repo file"
cp ${script_location}/files/mongo.repo  /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head -e "installing the mongodb"
yum install mongodb-org -y &>>${LOG}
status_check

print_head -e "Update listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/g'  /etc/mongod.conf  &>>${LOG}
status_check

print_head "restart mongodb"
systemctl restart mongod  &>>${LOG}
status_check