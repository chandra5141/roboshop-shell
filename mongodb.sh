set -e
source common.sh

echo -e "\e[33m copying mongodb repo file \e[0m"
cp ${set_location}/files/mongodb.repo  /etc/yum.repos.d/mongodb.repo &>>${LOG}


echo -e "\e[33m installing the mongodb \e[0m"
yum install mongodb-org -y &>>${LOG}

echo -e "\e[33m Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/g'  /etc/mongod.conf  &>>${LOG}

echo -e "\e[33m restart mongodb \e[0m"
systemctl restart mongod  &>>${LOG}