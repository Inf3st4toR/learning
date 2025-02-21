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

  echo "Int: $EL_NB $EL_NAME $SYMB $TYPE $MASS $MELT_P $BOIL_P"

elif [[ $ARG =~ ^[a-zA-Z]+$ ]]; then

  # case string
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name = '$ARG' OR symbol = '$ARG';")
  IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT

  echo "String: $EL_NB $EL_NAME $SYMB $TYPE $MASS $MELT_P $BOIL_P"

else
  echo "I could not find that element in the database."
fi

#output information

