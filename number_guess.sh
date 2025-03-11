#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guessing -t --no-align -c"

#Validate username
echo "Enter your username:"
read USERNAME

RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
if [[ -z $RESULT ]]; then
    #Not found
    echo "Welcome, $USERNAME! It looks like this is your first time here."
else
    #Found
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users WHERE username='$USERNAME'")
    BEST_COUNT=$($PSQL "SELECT MIN(guesses) FROM users WHERE username='$USERNAME'")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_COUNT guesses."
fi

#Guess number
RAN_NUM=$((($RANDOM % 1000)+1))
COUNT=1
GUESS=0
echo "Guess the secret number between 1 and 1000:"

#Guess Loop
while true; do
    read GUESS

    #Validate
    if ! [[ "$GUESS" =~ ^-?[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
        continue
    fi

    #Check guess
    if [ "$GUESS" -eq "$RAN_NUM" ]; then
        echo "You guessed it in $COUNT tries. The secret number was $RAN_NUM. Nice job!"
        break
    elif [ "$GUESS" -gt "$RAN_NUM" ]; then
        (( COUNT++ ))
        echo "It's lower than that, guess again:"
    else
        (( COUNT++ ))
        echo "It's higher than that, guess again:"
    fi
done

$PSQL "INSERT INTO users (username, guesses) VALUES ('$USERNAME', '$COUNT')" > /dev/null

exit 0
