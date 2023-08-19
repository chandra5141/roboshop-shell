script_location=$(pwd)
echo -e "\e[33m nginx is installing \e[0m"
yum install nginx -y   &>> /tmp/logs

-e "\e[33m remove default old content \e[0m"
rm -rf /usr/share/nginx/html/*  &>> /tmp/logs

echo -e "\e[33m download frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>> /tmp/logs

echo -e "\e[33m changing the directory to nginx \e[0m"
cd /usr/share/nginx/html  &>> /tmp/logs

echo -e "\e[33m Extract frontend content \e[0m"
unzip /tmp/frontend.zip  &>> /tmp/logs

echo -e "\e[33m copying the config file \e[0m"
cp ${script_location}/files/roboshop.conf  /etc/nginx/default.d/roboshop.conf   &>> /tmp/logs

echo -e "\e[33m restart nginx  \e[0m"
systemctl restart nginx  &>> /tmp/logs

echo -e "\e[33m start nginx  \e[0m"
systemctl start nginx  &>> /tmp/logs

echo -e "\e[33m nginx enable \e[0m"
systemctl enable nginx  &>> /tmp/logs