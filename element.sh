#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

re='^[0-9]+$'

# If no argument is provided
if [[ -z $1 ]] ; then
  echo "Please provide an element as an argument."
else
  # If a numeric argument is provided
  if [[ $1 =~ $re ]] ; then
    # Get atomic_number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'")
  # If a non-numeric argument is provided
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi

  # If element does not exist
  if [[ -z $ATOMIC_NUMBER ]] ; then
    echo "I could not find that element in the database."
  else
    # Get complete element information
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = '$ATOMIC_NUMBER'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$ATOMIC_NUMBER'")
    TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    # Print detailed element information
    echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $(echo $NAME | sed -r 's/^ *| *$//g') ($(echo $SYMBOL | sed -r 's/^ *| *$//g')). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g') amu. $(echo $NAME | sed -r 's/^ *| *$//g') has a melting point of $(echo $MELTING_POINT | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING_POINT | sed -r 's/^ *| *$//g') celsius."
  fi
fi