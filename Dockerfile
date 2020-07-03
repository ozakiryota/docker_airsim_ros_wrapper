FROM osrf/ros:kinetic-desktop-full

########## nvidia-docker1 hooks ##########
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
########## basis ##########
RUN apt-get update && apt-get install -y \
	vim \
	wget \
	unzip \
	git \
	cmake-curses-gui
########## AirSim ##########
# RUN mkdir /home/airsim_ws/ &&\
# 	cd /home/airsim_ws/ &&\
# 	wget https://github.com/microsoft/AirSim/releases/download/v1.3.1-linux/Blocks.zip &&\
# 	unzip Blocks.zip
# RUN apt-get update && apt-get install -y rsync &&\
# 	mkdir /home/airsim_ws/ &&\
# 	cd /home/airsim_ws/ &&\
# 	git clone https://github.com/Microsoft/AirSim.git &&\
# 	cd AirSim &&\
# 	./setup.sh &&\
# 	./build.sh &&\
# 	cd ros &&\
# 	/bin/bash -c "source /opt/ros/kinetic/setup.bash; catkin build"
RUN apt-get update &&\
	apt-get install -y \
		rsync \
		g++-8 \
		python-catkin-tools \
		ros-kinetic-mavros* &&\
	mkdir /home/airsim_ws/ &&\
	cd /home/airsim_ws/ &&\
	git clone https://github.com/Microsoft/AirSim.git &&\
	cd AirSim &&\
	./setup.sh
RUN cd /home/airsim_ws/AirSim &&\
	./build.sh
RUN mkdir /home/cmake_ws &&\
	cd /home/cmake_ws &&\
	wget https://github.com/Kitware/CMake/releases/download/v3.17.3/cmake-3.17.3.tar.gz &&\
	tar xvf cmake-3.17.3.tar.gz &&\
	cd cmake-3.17.3 &&\
	./bootstrap && make && make install
RUN sed -i "s/#include <filesystem>/#include <experimental\/filesystem>/g" /home/airsim_ws/AirSim/MavLinkCom/MavLinkTest/Commands.cpp &&\
	sed -i "s/using namespace std::filesystem;/using namespace std::experimental::filesystem;/g" /home/airsim_ws/AirSim/MavLinkCom/MavLinkTest/Commands.cpp &&\
	sed -i "s/#include <filesystem>/#include <experimental\/filesystem>/g" /home/airsim_ws/AirSim/MavLinkCom/MavLinkTest/main.cpp &&\
	sed -i "s/using namespace std::filesystem;/using namespace std::experimental::filesystem;/g" /home/airsim_ws/AirSim/MavLinkCom/MavLinkTest/main.cpp
RUN cd /home/airsim_ws/AirSim/ros &&\
	/bin/bash -c "source /opt/ros/kinetic/setup.bash; catkin build" &&\
	echo "source /home/airsim_ws/AirSim/ros/devel/setup.bash" >> ~/.bashrc
# RUN mkdir -p /root/Documents/AirSim &&\
# 	cp /home/airsim_ws/AirSim/ros/src/airsim_tutorial_pkgs/settings/front_stereo_and_center_mono.json /root/Documents/AirSim/settings.json
RUN echo "#!/bin/bash \n \
		source /opt/ros/kinetic/setup.bash \n \
		source /home/airsim_ws/AirSim/ros/devel/setup.bash \n \
		roslaunch airsim_ros_pkgs airsim_node.launch" \
		>> /home/airsim_ws/launch.sh &&\
	chmod +x /home/airsim_ws/launch.sh
######### initial position ##########
WORKDIR /home/airsim_ws
