#!/bin/bash
echo "$div"
div=$(adb devices | grep -oP '(?<=\t)[^\s]+')
while true; do
  if [ "$div" == "no" ] || [ "$div" == "device" ]; then
  	clear
  	echo "oculus found!"
  	sudo adb kill-server  
	sudo adb start-server
	sudo adb devices
	adb forward tcp:9943 tcp:9943
    break
  else
	clear
	div=$(adb devices | grep -oP '(?<=\t)[^\s]+')
	echo "no device's found!"
    sleep 1
  fi
done


