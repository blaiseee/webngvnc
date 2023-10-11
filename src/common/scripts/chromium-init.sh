#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

# VNC_RES_W=${VNC_RESOLUTION%x*}
# VNC_RES_H=${VNC_RESOLUTION#*x}

echo -e "\n------------------ update chromium-browser.init ------------------"
echo -e "\n... set window size 1024x768 as chromium window size!\n"
echo "export CHROMIUM_FLAGS='--no-sandbox --test-type --start-maximized --disable-gpu --disable-dev-shm-usage --user-data-dir --window-size=1024,768 --window-position=0,0'" > $HOME/.chromium-browser.init