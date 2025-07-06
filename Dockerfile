FROM --platform=$TARGETPLATFORM osrf/ros:humble-desktop

# Build arguments for platform support
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install VNC, Xvfb and other dependencies
RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    tigervnc-common \
    wget \
    unzip \
    fluxbox \
    xterm \
    python3 \
    python3-numpy \
    && rm -rf /var/lib/apt/lists/*

# Install ROS2 navigation packages
RUN apt-get update && apt-get install -y \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-turtlebot3-gazebo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ws

# Install official noVNC
RUN mkdir -p /usr/share/novnc && \
    wget -O /tmp/novnc.zip https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip && \
    unzip /tmp/novnc.zip -d /tmp/ && \
    cp -r /tmp/noVNC-1.4.0/* /usr/share/novnc/ && \
    rm -rf /tmp/novnc.zip /tmp/noVNC-1.4.0 && \
    ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
    # Install websockify
    wget -O /tmp/websockify.zip https://github.com/novnc/websockify/archive/refs/tags/v0.11.0.zip && \
    unzip /tmp/websockify.zip -d /tmp/ && \
    mv /tmp/websockify-0.11.0 /usr/share/novnc/utils/websockify && \
    rm -rf /tmp/websockify.zip

# Create required directories
RUN mkdir -p /root/.fluxbox

# Add a basic fluxbox menu
RUN echo "[begin] (Fluxbox)\n\
[exec] (Terminal) {xterm}\n\
[end]" > /root/.fluxbox/menu

# Add basic fluxbox init
RUN echo "session.screen0.toolbar.visible: false\n\
session.screen0.toolbar.autoHide: false" > /root/.fluxbox/init

ENV DISPLAY=:0

EXPOSE 5900 6080

# Setup ROS2 environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

COPY scripts/start.sh /
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]