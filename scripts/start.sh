#!/bin/bash

# Exit on any error
set -e

cleanup() {
    echo "Cleaning up..."
    pkill -9 -f "Xvfb" || true
    pkill -9 -f "x11vnc" || true
    pkill -9 -f "websockify" || true
    pkill -9 -f "fluxbox" || true
    pkill -9 -f "xterm" || true
}

# Set up trap to call cleanup function on script exit
trap cleanup EXIT

# Make sure we have a display
export DISPLAY=:0

echo "Starting Xvfb..."
Xvfb :0 -screen 0 1920x1080x24 &
sleep 2

echo "Starting window manager..."
fluxbox &
sleep 2

echo "Starting VNC server..."
x11vnc -display :0 -forever -shared -nopw &
sleep 2

echo "Starting noVNC..."
cd /usr/share/novnc
./utils/websockify/run --web /usr/share/novnc --wrap-mode=ignore 6080 localhost:5900 &
sleep 2

echo "Starting ROS environment..."
source /opt/ros/humble/setup.bash

echo "Starting terminal..."
xterm &

echo "Setup complete. VNC server available at port 5900, noVNC at port 6080"

# Keep container running and handle signals properly
while true; do
    sleep 1
done