source common.sh
if [ -z "${root_mysql_password}" ]; then
  echo -e "\e[31m root_mysql_password password is required\e[0m"
fi
component= shipping
schema_load= true
schema_type= mysql
maven

