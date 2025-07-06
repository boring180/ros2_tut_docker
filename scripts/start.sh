#!/bin/bash

# Make sure we have a display
export DISPLAY=:0

# Start Xvfb
Xvfb :0 -screen 0 1920x1080x24 &
sleep 2

# Start window manager
fluxbox &
sleep 2

# Start VNC server without password
x11vnc -display :0 -forever -shared -nopw &
sleep 2

# Start noVNC with specific host settings
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 0.0.0.0:6080 &
sleep 2

# Source ROS
source /opt/ros/humble/setup.bash

# Start a terminal
xterm &

# Keep container running
tail -f /dev/null