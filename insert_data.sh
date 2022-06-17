#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get major_id
    TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $TEAMS ]]
    then
      # insert major
      INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi
  if [[ $OPPONENT != "opponent" ]]
  then
    # get major_id
    TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $TEAMS2 ]]
    then
      # insert major
      INSERT_TEAMS2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      if [[ $INSERT_TEAMS2 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
  then
    if [[ $YEAR != "year" ]]
    then
     INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND',$TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS)")
     if [[ $INSERT_GAMES == "INSERT 0 1" ]]
     then echo  Inserted into games, $YEAR
     fi
    fi
  fi
done
