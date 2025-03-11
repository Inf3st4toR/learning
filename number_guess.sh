#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guessing -t --no-align -c"

#Validate username
read -p "Enter your username:" USERNAME
RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
if [[ -z $RESULT ]]; then
    #Not found
    echo "Welcome, $USERNAME! It looks like this is your first time here."
else
    #Found
    OLD_COUNT=$($PSQL "SELECT COUNT(*) FROM users WHERE username='$USERNAME'")
    BEST_COUNT=$($PSQL "SELECT MIN(guesses) FROM users WHERE username='$USERNAME'")
    echo "Welcome back, $USERNAME! You have played $OLD_COUNT games, and your best game took $BEST_COUNT guesses."
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
echo -e "You guessed it in $COUNT tries. The secret number was $RAN_NUM. Nice job!"

