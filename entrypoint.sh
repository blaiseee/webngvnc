#!/bin/bash
export DISPLAY=:0
# set -e
# SCREEN_HEIGHT=1024
# SCREEN_WIDTH=768
# SCREEN_DEPTH=24

# VNC_SERVER="localhost"
# VNC_PORT="8080"
# WEBSOCKIFY_PORT="6080"

# NO_VNC_PORT="5900"
echo "a"
Xvfb :0 -screen 0 1024x768x16 -listen tcp -ac &
echo "b"
# openbox-session &
xset -dpms &
xset s noblank &
xset s off &
/usr/bin/icewm-session &
# sleep 1
# fluxbox &
# xterm &
# wait
# XVFB_PID=$!
# export DISPLAY=$DISPLAY_NUM
# DISPLAY=$DISPLAY_NUM fluxbox &
# DISPLAY=$DISPLAY_NUM xterm &
# fluxbox &
# xterm &
# RUN_FLUXBOX=${RUN_FLUXBOX:-yes}
# RUN_XTERM=${RUN_XTERM:-yes}

# case $RUN_FLUXBOX in
#   false|no|n|0)
#     rm -f /app/conf.d/fluxbox.conf
#     ;;
# esac

# case $RUN_XTERM in
#   false|no|n|0)
#     rm -f /app/conf.d/xterm.conf
#     ;;
# esac
# VNC_IP=$(hostname -i)

x11vnc -display :0 -nopw -forever -shared -listen localhost &
# vncserver $DISPLAY_NUM -depth $SCREEN_DEPTH -geometry ${SCREEN_HEIGHT}x${SCREEN_WIDTH} -localhost no -fg -nopw -SecurityTypes None &
websockify -D --web /usr/share/novnc 8080 localhost:5900 &
# /usr/share/novnc/utils/launch.sh --vnc $VNC_SERVER:$VNC_PORT --listen $WEBSOCKIFY_PORT &

# echo "Connect to the following URL in your web browser:"
# echo "http://your_server_ip:$WEBSOCKIFY_PORT/vnc.html?host=localhost&port=$WEBSOCKIFY_PORT"

# source /app/.chromium-browser.init
# exec supervisord -c /app/supervisord.conf
# sleep infinity
# exec "$@"