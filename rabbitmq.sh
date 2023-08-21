source common.sh

if [ -z "${rabbitmq_password}" ]; then
  echo -e "\e[31m rabbitmq_password is required\e[0m"
  exit
fi

print_head " installing python "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
condition_check

print_head " installing python "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
condition_check

print_head " installing python "
yum install rabbitmq-server -y
condition_check

print_head " installing python "
systemctl enable rabbitmq-server
condition_check

print_head " installing python "
systemctl start rabbitmq-server
condition_check


print_head " check user roboshop "
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${rabbitmq_password} &>>${LOG}
ficondition_check

print_head " administrator "
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
condition_check

print_head " set permissions "
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
condition_check

