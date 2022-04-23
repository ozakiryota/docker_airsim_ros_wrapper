#!/bin/bash

xhost +

image="airsim_ros_wrapper"
tag="latest"

docker run \
	-it \
	--rm \
	-e "DISPLAY" \
	-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--net=host \
	-v $(pwd)/rviz_config:/root/rviz_config \
	-v $HOME/Documents/AirSim/settings.json:/root/Documents/AirSim/settings.json \
	$image:$tag