#!/bin/bash
#Setup
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

echo "Please provide an element as an argument."

#validate argument
ARG=$1
echo "$ARG"

#recover info in database
# case number
ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE atomic_number = $ARG;")
IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT

echo "Int: $EL_NB $EL_NAME $SYMB $TYPE $MASS $MELT_P $BOIL_P"

# case string
ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name = '$ARG' OR symbol = '$ARG';")
IFS="|" read EL_NB EL_NAME SYMB TYPE MASS MELT_P BOIL_P <<< $ELEMENT

echo "String: $EL_NB $EL_NAME $SYMB $TYPE $MASS $MELT_P $BOIL_P"


#output information

