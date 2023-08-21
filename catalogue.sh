source common.sh

print_head "downloading the nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
status_check

print_head "installing nodejs"
yum install nodejs -y  &>>${LOG}
status_check

print_head "check and adding roboshop"
id roboshop &>>${LOG}
useradd
status_check

print_head "make app directory"
mkdir -p /app &>>${LOG}
status_check

print_head "download catalogue content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

cd /app

print_head "extract catalogue content"
unzip /tmp/catalogue.zip -y &>>${LOG}
status_check

print_head "NPM install"
npm install &>>${LOG}
status_check

print_head "copy catalogue service file"
cp ${set_location}/files/catalogue.service  /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "daemon reload"
systemctl daemon-reload &>>${LOG}
status_check

print_head "enabling the catalogue"
systemctl enable catalogue &>>${LOG}
status_check

print_head "copy catalogue service file"
systemctl start catalogue &>>${LOG}
status_check

print_head "copy catalogue service file"
cp ${set_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "copy catalogue service file"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "copy catalogue service file"
mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js &>>${LOG}
status_check