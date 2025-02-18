#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE games, teams;"

cat games.csv | while IFS=',' read YEAR ROUND WIN OPP WIN_G OPP_G
do
  if [[ $YEAR != "year" ]]
  then
    #Check/add WIN country ID
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name = '$WIN';")
    if [[ -z $TEAM_ID_W ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WIN');"
      TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name = '$WIN';")
    fi

    #Check/add OPP country ID
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPP';")
    if [[ -z $TEAM_ID_O ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPP');"
      TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPP';")
    fi

    #Fill games
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WIN_G, $OPP_G);"
  fi
done

#echo $?