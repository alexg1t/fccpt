PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"


# IF NO ELEMENT PROVIDED
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi

#IN CASE ARGUMENT IS A NUMBER
if [[ $1 =~ ^[1-9]+$ ]]
then
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
else
#IF ARGUMENT IS STRING
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
fi

#IF ELEMENT DOES NOT EXIST
if [[ -z $element ]]
then
  echo -e "I could not find that element in the database."
  exit
fi
#ELEMENT EXIST
echo $element | while IFS=" |" read ANUM NAME SYM type AMASS MP BP 
do
  echo -e "The element with atomic number $ANUM is $NAME ($SYM). It's a $TYPE, with a mass of $AMASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
done
