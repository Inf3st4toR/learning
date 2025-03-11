#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guessing -t --no-align -c"

#Validate username
read -p "Enter your username:" USERNAME
RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
if [[ -z $RESULT ]]; then
    #Not found
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
    #Found
    echo -e "\nWelcome back, $USERNAME! ..."
fi

#Guess number
RAN_NUM=$((($RANDOM % 1000)+1))
echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS

echo $GUESS $RAN_NUM
