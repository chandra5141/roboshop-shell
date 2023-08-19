echo "nginx is installing"
yum install nginx -y   >> /tmp/history

echo "starting nginx"
systemctl start nginx  >> /tmp/history

echo "enabling nginx"
systemctl enable nginx  >> /tmp/history

echo "removing the default content from nginx default html path"
rm -rf /usr/share/nginx/html/*  >> /tmp/history

echo "downloading the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  >> /tmp/history

echo "changing directory"
cd /usr/share/nginx/html  >> /tmp/history

echo "unzipping the frontend content"
unzip /tmp/frontend.zip  >> /tmp/history

echo "copying file roboshop.conf to path of nginx"
cp files/roboshop.conf  /etc/nginx/default.d/roboshop.conf   >> /tmp/history

echo "restarting nginx "
systemctl restart nginx  >> /tmp/history