LOG=/tmp/roboshop.log
script_location=$(pwd)

print_head () {
  echo -e "\e[33m $1 \e[0m"
}

status_check () {
  if [ $? -eq 0 ]
   then
    echo -e "\e[32m SUCCESS\e[0m"
  else
    echo -e "\e[31m FAIlURE\e[0m"
    echo "Refer the log file in path ${LOG}"
    exit
  fi
}

user_add () {
print_head "adding user roboshop"
id roboshop
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
fi
}


app_preq () {

  user_add &>>${LOG}

  mkdir -p /app &>>${LOG}

  print_head "download ${component} content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "removing old content if any"
  rm -rf  /app/*  &>>${LOG}
  status_check

  print_head "extract ${component} content"
  cd /app
  unzip /tmp/${component}.zip &>>${LOG}
  status_check

}

systemd () {
  print_head "copy ${component} service file"
  cp ${script_location}/files/${component}.service  /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "reload the systemd"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "enabling the ${component}"
  systemctl enable ${component} &>>${LOG}
  status_check

  print_head "start ${component} service file"
  systemctl start ${component} &>>${LOG}
  status_check
}

nodejs () {
  print_head "set up nodejs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${LOG}
  status_check

  print_head "installing nodejs"
  yum install nodejs -y  &>>${LOG}
  status_check

  app_preq

  print_head "install dependencies"
  cd /app
  npm install &>>${LOG}
  status_check

  systemd

  schema_load

}

maven () {
 print_head " installing maven "
 yum install maven -y &>>${LOG}
 condition_check

 app_preq

 print_head " clean packege command ${component} "
 cd /app
 mvn clean package &>>${LOG}
 condition_check

 print_head "moving ${component} files from target folder to app directory "
 mv target/shipping-1.0.jar  shipping.jar &>>${LOG}
 condition_check

 print_head " password authentication  ${component} file"
 sed -i -e "s/rabbitmq_password/${rabbitmq_password}/"  ${set_location}/files/${component}.service &>>${LOG}
 condition_check
 systemd

 schema_load

}

schema_load () {
   if [ schemaload == true ]; then
      if [ schema_type == mongodb ]; then

        print_head "copy ${component} mongo.repo file"
        cp ${script_location}/files/mongo.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
        status_check

        print_head "install mongodb client"
        yum install mongodb-org-shell -y &>>${LOG}
        status_check

        print_head "load schema mongod"
        mongo --host mongodb-dev.chandupcs.online </app/schema/${component}.js &>>${LOG}
        status_check
      fi

      if [ schema_type == mysql ]; then
          print_head "install mysql client"
          yum install mysql-y &>>${LOG}
          status_check

          print_head "load schema mysql"
          mysql --host mysql-dev.chandupcs.online -uroot -p${root_mysql_password} </app/schema/shipping.sql &>>${LOG}
          status_check
      fi
  fi
}


python () {
  print_head " installing python "
  yum install python36 gcc python3-devel -y &>>${LOG}
  condition_check

 app_preq

 print_head " installing python requirements "
 cd /app
 pip3.6 install -r requirements.txt &>>${LOG}
 condition_check

 print_head " update passwords in ${component} file"
 sed -i -e "s/rabbitmq_password/${rabbitmq_password}/"  ${set_location}/files/${component}.service &>>${LOG}
 condition_check

 systemd
}

golang () {
print_head " installing golang "
yum install goloand -y &>>${LOG}
condition_check

app_preq

print_head " initiating dispatch python "
cd /app
go mod init dispatch
condition_check

print_head " get and build golang "
go get
condition_check

print_head " build dispatch "
go build
condition_check

print_head " update passwords in ${component} file"
sed -i -e "s/rabbitmq_password/${rabbitmq_password}/"  ${set_location}/files/${component}.service &>>${LOG}
condition_check

systemd

}
