#!/bin/bash

rosbag record \
	-O "../bagfiles/drone_1cam" \
	/tf \
	/tf_static \
	/airsim_node/drone/odom_local_ned \
	/airsim_node/drone/imu/Imu \
	/airsim_node/drone/camera_0/Scene/compressed
