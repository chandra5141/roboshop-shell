source common.sh

print_head "downloading the nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
status_check

print_head "installing nodejs"
yum install nodejs -y
status_check

print_head "adding roboshop"
useradd roboshop
status_check

print_head "make app directory"
mkdir -p /app
status_check

print_head "download catalogue content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
status_check

print_head "cd to app"
cd /app
status_check

print_head "extract catalogue content"
unzip /tmp/catalogue.zip
status_check

print_head "cd to app"
cd /app
status_check

print_head "NPM install"
npm install
status_check

print_head "copy catalogue service file"
cp ${set_location}/files/catalogue.service  /etc/systemd/system/catalogue.service
status_check

print_head "daemon reload"
systemctl daemon-reload
status_check

print_head "enabling the catalogue"
systemctl enable catalogue
status_check

print_head "copy catalogue service file"
systemctl start catalogue
status_check

print_head "copy catalogue service file"
cp ${set_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo
status_check

print_head "copy catalogue service file"
yum install mongodb-org-shell -y
status_check

print_head "copy catalogue service file"
mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js
status_check