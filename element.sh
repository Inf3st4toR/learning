#!/bin/bash
#Setup
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#case empty
if [[ -z $1 ]]; then
  RESULT="Please provide an element as an argument."

else
  #case number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number = $1;")
    IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT
    
    #if found
    if [[ $ELEMENT ]]; then
      RESULT="The element with atomic number $EL_NB is $EL_NAME ($SYMB). It's a $TYPE, with a mass of $MASS amu. $EL_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
    fi

  #case string
  elif [[ $1 =~ ^[a-zA-Z]+$ ]]; then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name = '$1' OR symbol = '$1';")
    IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT

    #if found
    if [[ $ELEMENT ]]; then
      RESULT="The element with atomic number $EL_NB is $EL_NAME ($SYMB). It's a $TYPE, with a mass of $MASS amu. $EL_NAME has a melting point of $MELT_P celsius and a boiling point of $BOIL_P celsius."
    fi

  #if not found
  else
    RESULT="I could not find that element in the database."
  fi
fi
#output information
echo -e "\n$RESULT"

