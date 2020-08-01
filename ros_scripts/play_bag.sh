#!/bin/bash

if [ $# != 1 ]; then
	echo "ERROR: set a bagfile"
	exit 1
fi

echo $1
roscore & \
sleep 1s &&\
rosbag play $1 & \
rviz -d ../rviz_config/drone_1cam.rviz
