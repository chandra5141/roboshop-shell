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

