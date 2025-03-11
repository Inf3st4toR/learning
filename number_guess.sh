#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guessing -t --no-align -c"

#Validate username
read -p "Enter your username: " USERNAME
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
COUNT=1
echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS

#Guess Loop
while [ "$GUESS" -ne "$RAN_NUM" ]; do
    if [ "$GUESS" -gt "$RAN_NUM" ]; then
        echo -e "\nIt's lower than that, guess again:"
        read GUESS
    else
        echo -e "\nIt's higher than that, guess again:"
        read GUESS
    fi
    (( COUNT++ ))
done

$PSQL "INSERT INTO users (username, guesses) VALUES ('$USERNAME', '$COUNT')"
echo -e "You guessed it in $COUNT tries. The secret number was $RAN_NUM. Nice job!\n"

