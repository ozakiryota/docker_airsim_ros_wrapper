#!/bin/bash

image="airsim_ros_wrapper"
tag="latest"

docker build . \
    -t $image:$tag \
    --build-arg CACHEBUST=$(date +%s)