#!/bin/bash

# Set leavetime from arguments in the form hhmm
leavetime=$1

# Read in temp from sensor 134 and cut off decimal and unit
mytemp=`tdtool -l | grep 134 | awk '{ print $4 }' | sed 's/.$//' | rev | cut -c 3- | rev`

# Check state of car warmer
state=`tdtool -l | grep Motor | awk '{ print $4 }'`
echo "Car heater is	 		$state"

# Testkod
# mytemp=-15
# state=on

echo "Current temperature is: 	$mytemp degrees C"

# Test outside temp against suggested conditions and set duration for warmup
if [ $mytemp -lt -10 ];
then 
	warmtime=160
elif [ $mytemp -lt -5 ];
then 
	warmtime=120
elif [ $mytemp -lt 0 ];
then 
	warmtime=90
elif [ $mytemp -lt 5 ];
then 
	warmtime=60
elif [ $mytemp -lt 10 ];
then 
	warmtime=30
else
	warmtime=0
fi
echo "Car heating time =		$warmtime"

# Set leave time
# leavetime = 0730
echo "Time to leave	 		$leavetime"

# Set off time to shut off
offtime=$(date -d "$leavetime 30 min" +'%H%M')
echo "Time to shut off is 		$offtime"


# Set current time
time=`date +%H%M`

# Calculate start time
starttime=$(date -d "$leavetime $warmtime min ago" +'%H%M')
echo "Current time is 		$time"
echo "Starttime car heater is 	$starttime"

# Wait for start time
while [ "$time" -lt "$starttime" ];
do	
	echo "Sleeping"
	sleep 5m	
done

# If between start time and leave time turn on heater
if	[ "$state" = "OFF" ] && [ "$time" -le "$leavetime" ] && [ "$time" -ge "$starttime" ];
then
	tdtool -n 5 
	state=ON
	echo "Car heater turned 		ON"
else
	echo "Car heater is 			$state"
fi

# If more than 30 minutes after leavetime, turn off heater
while	[ "$state" = "ON" ] && [ "$time" -lt "$offtime" ] ;
do
	echo "Time is now $time. Sleeping until $offtime or manually turned off"
	sleep 5m
	state=`tdtool -l | grep Motor | awk '{ print $4 }'`
	time=`date +%H%M`
done
echo "Time is now is $time. Shutting off"
tdtool -f 5 
state=`tdtool -l | grep Motor | awk '{ print $4 }'`
echo "Car heater turned 		$state"
exit

