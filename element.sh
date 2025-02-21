#!/bin/bash
#Setup
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
echo "Please provide an element as an argument."
RESULT="I could not find that element in the database."

#validate argument
ARG=$1

#case number
if [[ $ARG =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number = $ARG;")
  IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT
  
  #if found
  if [[ $ELEMENT ]]; then
    RESULT="The element with atomic number $EL_NB is $EL_NAME ($SYMB). It's a $TYPE, with a mass of $MASS amu. $EL_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
  fi

#case string
elif [[ $ARG =~ ^[a-zA-Z]+$ ]]; then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name = '$ARG' OR symbol = '$ARG';")
  IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT

  #if found
  if [[ $ELEMENT ]]; then
    RESULT="The element with atomic number $EL_NB is $EL_NAME ($SYMB). It's a $TYPE, with a mass of $MASS amu. $EL_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
  fi
fi

#output information
echo -e "\n$RESULT"

