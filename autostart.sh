#!/bin/zsh

# load environment settings from .bashrc
source /home/ros/.zshrc
journalctl --vacuum-size=200M

echo "Waiting for network to come online"
until nc -vzw 2 $ROS_HOSTNAME 22; do sleep 1; done
echo "Network online"

modprobe uvcvideo

# clear ROS log
rm -rf /home/ros/.ros/log

### Start ROS launch scripts
USE_NODELETS=true roslaunch autominy Live.launch

