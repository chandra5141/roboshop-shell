set -e
source common.sh

print_head "nginx is installing"
yum install nginx -y   &>>${LOG}
status_check

print_head " remove default old content"
rm -rf /usr/share/nginx/html/*  &>>${LOG}
status_check

print_head "download frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>${LOG}
status_check

print_head "changing the directory to nginx"
cd /usr/share/nginx/html  &>>$LOG
status_check

print_head "Extract frontend content"
unzip /tmp/frontend.zip  &>>${LOG}
status_check

print_head "copying the config file"
cp ${script_location}/files/roboshop.conf  /etc/nginx/default.d/roboshop.conf   &>>${LOG}
status_check

print_head "starting nginx"
systemctl  start nginx  &>>${LOG}
status_check

print_head "restarting nginx"
systemctl restart nginx &>>${LOG}
status_check

print_head "nginx enabling"
systemctl enable nginx  &>>${LOG}
status_check