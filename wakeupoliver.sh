#!/bin/bash
dimvalue=0

while [ $dimvalue -le 255 ]
do
tdtool --dimlevel $dimvalue --dim 11
dimvalue=$(($dimvalue + 3))
sleep 15
done
exit 1
