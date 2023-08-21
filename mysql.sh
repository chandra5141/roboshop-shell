source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo -e "\e[31m root_mysql_password password is required\e[0m"
fi

print_head "disable mysql"
yum module disable mysql -y
status_check

print_head "setup mysql configuration repo"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo
status_check


print_head "install mysql server"
yum install mysql-community-server -y
status_check


print_head "enable mysql"
systemctl enable mysqld
status_check

print_head "start mysql "
systemctl start mysqld
status_check

print_head "reset mysql default password"
mysql_secure_installation --set-root-pass ${root_mysql_password}
if [ $? -eq 1 ]; then
  echo password already reset
fi
status_check
