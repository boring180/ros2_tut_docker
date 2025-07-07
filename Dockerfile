FROM ros:humble

# Install necessary packages
RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    novnc \
    supervisor \
    xterm \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /opt/novnc/utils/websockify

# Set up supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 8080

# Set environment variables
ENV DISPLAY=:0

# Start supervisord
CMD ["/usr/bin/supervisord"]
