#!/bin/bash
#Setup
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
echo "Please provide an element as an argument."

#validate argument
ARG=$1
if [[ $ARG =~ ^[0-9]+$ ]]; then

  # case number
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number = $ARG;")
  IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT
  
  #if not found
  if [[ -z $ELEMENT ]]; then
  RESULT="I could not find that element in the database."
  else
  RESULT="The element with atomic number $EL_NB is $EL_NAME ($SYMB). It's a $TYPE, with a mass of $MASS amu. $EL_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
  fi

elif [[ $ARG =~ ^[a-zA-Z]+$ ]]; then

  # case string
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name = '$ARG' OR symbol = '$ARG';")
  IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT

  RESULT="The element with atomic number $EL_NB is $EL_NAME ($SYMB). It's a $TYPE, with a mass of $MASS amu. $EL_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."

else
  # case invalid
  RESULT="I could not find that element in the database."
fi

#output information
echo -e "\n$RESULT"

