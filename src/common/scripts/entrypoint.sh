#!/bin/bash
set -e # exit when command fails
set -u # prevent bash exit and report the output
# export DISPLAY=:1

# /usr/bin/icewm-session &
# export DISPLAY=$DISPLAY_NUM
# /app/src/common/scripts/chromium-init.sh
# source /app/.chromium-browser.init
# VNC_IP=$(hostname -i)
# x11vnc -display :1 -nopw -forever -shared -listen localhost &
# systemctl start nginx
# systemctl enable nginx
# nginx -t
source $HOME/.bashrc # generate user

custom_hostname="myapp.loc"

cp /etc/hosts /etc/hosts.backup

sudo sed -i "s/127.0.0.1 localhost/127.0.0.1 localhost $custom_hostname/" /etc/hosts

cat /etc/hosts

# cp "/dockerstartup/hosts" "/etc/hosts"
mv "/dockerstartup/default" "/etc/nginx/sites-available/default"
# ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
# nginx -t
# nginx -c /etc/nginx/nginx.conf -g "daemon off;"
nginx
# nginx -s reload
# nginx -c /etc/nginx/nginx.conf -g "daemon off;"
echo "Nginx configuration has been created and applied."

VNC_IP=$(hostname -i)
echo "$VNC_IP"

cleanup () {
  kill -s SIGTERM $!
  exit 0
}
trap cleanup SIGINT SIGTERM

$DOCKERSTARTUP/chromium-init.sh
source $HOME/.chromium-browser.init



echo "Start noVNC"
# mkdir -p $DOCKERSTARTUP
# ln -s $VNC_HOME/vnc_lite.html $VNC_HOME/index.html
$NO_VNC_HOME/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT > $DOCKERSTARTUP/no_vnc_startup.log 2>&1 &
PID_SUB=$!

echo "Start VNC Server"
echo "Starting display in $DISPLAY"
# vncserver -log $DOCKERSTARTUP/logfile.log :1
vncserver -kill $DISPLAY &> $DOCKERSTARTUP/vnc_startup.log \
  || rm -rfv /tmp/.X*-lock /tmp/.xX11-unix &> $DOCKERSTARTUP/vnc_startup.log \
  || echo "no locks present"

vncserver $DISPLAY -depth $VNC_DEPTH -geometry $VNC_RESOLUTION -SecurityTypes None --I-KNOW-THIS-IS-INSECURE > $DOCKERSTARTUP/no_vnc_startup.log 2>&1

echo "Start Window Manager"
$HOME/wm_startup.sh &> $DOCKERSTARTUP/wm_startup.log

echo "Connect to the following URL in your web browser"
echo "http://127.0.0.1:6901"

# nginx -t
# systemctl reload nginx
# nginx

if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
    wait $PID_SUB
else
    echo -e "EXECUTE COMMAND"
    echo "Executing command: '$@'"
    exec "$@"
fi