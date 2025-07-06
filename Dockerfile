FROM osrf/ros:humble-desktop

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install VNC and noVNC
RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    novnc \
    tigervnc-common \
    && rm -rf /var/lib/apt/lists/*

# Install ROS2 navigation packages
RUN apt-get update && apt-get install -y \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-turtlebot3-gazebo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ws

RUN mkdir -p /usr/share/novnc/utils/ && \
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

ENV DISPLAY=:0

EXPOSE 5900 6080

# Setup ROS2 environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

COPY scripts/start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]