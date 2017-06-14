#!/bin/bash

# Absolute path to this script
SCRIPT=$(realpath $0)
SCRIPTPATH=`dirname $SCRIPT`

# Get scaling
source $SCRIPTPATH/scale_factor

# Set initial position and variables
offx=2
offy=1
width=$(tput cols)
height=$(tput lines)
str="  |0|1|2|3|4|5|6|7|8|9|"
length=$((${#str}*$scale_factor))
down_flag=0

draw_status() {
  xoff=2 # x-offset to grid 0,0
  yoff=1 # y-offset to grid 0,0
  xm=$((2*scale_factor)) # x-step width
  ym=$((scale_factor)) # y-step width

  # Walk through Pingdom status'
  OIFS=$IFS
  IFS=$'\n'
  cnt=0
  down_flag=0
  for srvs in $($SCRIPTPATH/get_status.sh)
  do
    # Finding current position
    x=$(($cnt%10))
    y=$((($cnt-$x)/10))

    # Extracting status
    name=$(echo $srvs | awk -F ' =' {' print $1 '} | sed 's/"//g')
    stat=$(echo $srvs | awk -F ' =' {' print $2 '} | sed 's/"//g' | sed 's/ //g')

    # Defining color
    if [[ "$stat" == "up" ]]; then
      tput setab 2 #green background
      tput setaf 2 #green foreground
    else
      down_flag=1
      tput setab 1 #red background
      tput setaf 1 #red foreground
    fi

    # Print status
    str=""
    i=0
    while [ $i -lt $((2*$scale_factor-1)) ]; do
      str="$str "
      i=$[$i+1]
    done

    i=1
    while [ $i -lt $(($scale_factor+1)) ]; do
      tput cup $(($offy+$yoff+$y*$ym+$i-1+$y)) $(($offx+$xoff+$x*$xm))
      echo "$str"
      i=$[$i+1]
    done
    tput setab 0 #black background
    tput cup $(($offy+$cnt)) $(($offx+2+11*2*scale_factor))
    echo "$cnt: $name                                               "

    # Resetting color
    tput setab 0 #black background
    tput setaf 7 #white foreground

    # Increase counter
    cnt=$[$cnt +1]
  done
  IFS=$OIFS
}

draw_grid() {
  # Resetting color
  tput setab 0 #black background
  tput setaf 7 #white foreground

  # Clear screen
  clear

  # Print grid
  tput cup 5 5
  for i in 0 1 2 3 4 5 6 7 8 9; do
    tput cup $offy $(($offx+2+$i*2*scale_factor))
    echo "$i"
  done

  for i in 0 1 2 3 4 5 6 7 8 9; do
    tput cup $(($offy+1+$i*scale_factor+$i)) $((offx-1))
    echo "$(($i*10))"
  done

  draw_status
}

count_seconds(){
  for i in {1..59}; do
    tput cup $(($offy+11*scale_factor+11)) $(($offx+2)) 
    echo "(Refresh in $((59-$i)) seconds) "
    sleep 1
    # If not all is 'up' ring a bell ;)
    if [[ "$down_flag" == "1" ]]; then
      tput bel
    fi 
  done
}

trap draw_grid WINCH

draw_grid
while true; do
  count_seconds
  draw_grid
done
