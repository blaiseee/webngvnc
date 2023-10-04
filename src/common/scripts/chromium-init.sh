#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# VNC_RES_W=${VNC_RESOLUTION%x*}
# VNC_RES_H=${VNC_RESOLUTION#*x}

echo -e "\n------------------ update chromium-browser.init ------------------"
echo -e "\n... set window size $DISPLAY_WIDTH x $DISPLAY_HEIGHT as chromium window size!\n"
echo "export CHROMIUM_FLAGS='--no-sandbox --test-type --start-maximized --disable-gpu --disable-dev-shm-usage --user-data-dir --window-size=$DISPLAY_WIDTH,$DISPLAY_HEIGHT --window-position=0,0'" > $HOME/.chromium-browser.init

source $HOME/.chromium-browser.init