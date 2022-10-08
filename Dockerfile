########## Pull ##########
FROM ros:noetic
########## Non-interactive ##########
ENV DEBIAN_FRONTEND=noninteractive
########## Common tool ##########
RUN apt-get update && \
	apt-get install -y \
		vim \
		wget \
		unzip \
		git \
        python-tk
########## AirSim ##########
## requirements
RUN apt-get update && \
	apt-get install -y \
		ros-noetic-tf2-sensor-msgs \
		ros-noetic-tf2-geometry-msgs \
		ros-noetic-mavros*
## cache busting
ARG CACHEBUST=1
## build
RUN	cd ~/ && \
	git clone https://github.com/Microsoft/AirSim.git && \
	./AirSim/setup.sh && \
	./AirSim/build.sh && \
	cd AirSim/ros && \
	/bin/bash -c "source /opt/ros/noetic/setup.bash; catkin_make" && \
	echo "source ~/AirSim/ros/devel/setup.bash" >> ~/.bashrc
######### Initial position ##########
WORKDIR /root/AirSim