source common.sh

echo -e "\e[33m downloading the nodejs\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
status_check

echo -e "\e[33m installing nodejs\e[0m"
yum install nodejs -y
status_check

echo -e "\e[33m adding roboshop\e[0m"
useradd roboshop
status_check

echo -e "\e[33m make app directory\e[0m"
mkdir -p /app
status_check

echo -e "\e[33m download catalogue content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
status_check

echo -e "\e[33m cd to app\e[0m"
cd /app
status_check

echo -e "\e[33m extract catalogue content\e[0m"
unzip /tmp/catalogue.zip
status_check

echo -e "\e[33m cd to app \e[0m"
cd /app
status_check

echo -e "\e[33m NPM install\e[0m"
npm install
status_check

echo -e "\e[33m copy catalogue service file\e[0m"
cp ${set_location}/files/catalogue.service  /etc/systemd/system/catalogue.service
status_check

echo -e "\e[33m daemon reload\e[0m"
systemctl daemon-reload
status_check


echo -e "\e[33m enabling the catalogue\e[0m"
systemctl enable catalogue
status_check

echo -e "\e[33m copy catalogue service file\e[0m"
systemctl start catalogue
status_check

echo -e "\e[33m copy catalogue service file\e[0m"
cp ${set_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo
status_check

echo -e "\e[33m copy catalogue service file\e[0m"
yum install mongodb-org-shell -y
status_check

echo -e "\e[33m copy catalogue service file\e[0m"
mongo --host mongodb-dev.chandupcs.online </app/schema/catalogue.js
status_check