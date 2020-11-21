#!/bin/bash

path_name=$(pwd)
image_name=${path_name##*/}

xhost +
nvidia-docker run -it --rm \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--net=host \
	-v /home/amsl/Documents/AirSim/settings.json:/root/Documents/AirSim/settings.json \
	$image_name:latest \
	bash -c "/home/airsim_ws/airsim_node.sh"
