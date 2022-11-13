#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
#start making a salon appointment maker

#ask what the user need
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to my salon how can I help you?\n"
MAIN_MENU(){
    if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
GET_SERVICES=$($PSQL "select service_id,name from services ") 
echo "$GET_SERVICES"| while read SERVICES_ID BAR SERVICES_NAME 
do
echo  "$SERVICES_ID) $SERVICES_NAME"
done 

read SERVICE_ID_SELECTED
#create a switch case to manage the file 
SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED ")
SERVICE_ID=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED ")
if [[ -z $SERVICE_NAME ]]
then
MAIN_MENU "I could not find that service. What would you like today?"
else 
GET_CUSTOMER 
ADD_APPOINTMENT
echo "I have put you down for a cut at $(echo $SERVICE_TIME | sed 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed 's/^ *| *$//g')."
fi
}




GET_CUSTOMER() {
echo -e "\nWhat's you'r phone number?"
read CUSTOMER_PHONE
#get phone number info 
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE' ")
# if number is not in customers?
if [[ -z $CUSTOMER_ID ]]
then
#insert number and customer info
echo "I don't have record for that phone number, what's your name?"
read CUSTOMER_NAME
INSERT_CUSTOMER=$($PSQL "insert into customers(phone,name) values ('$CUSTOMER_PHONE', '$CUSTOMER_NAME') ")
#now get customer id
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE' ")
else
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE' ")

fi 
}





ADD_APPOINTMENT() {
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed 's/^ *| *$//g' ), $(echo $CUSTOMER_NAME | sed 's/^ *| *$//g')?"
  read SERVICE_TIME
  # insert into appiontments
  INSERT_APPOINTMENT=$($PSQL "insert into appointments(service_id,customer_id,time) values($SERVICE_ID,$CUSTOMER_ID,'$SERVICE_TIME')")
}
MAIN_MENU


