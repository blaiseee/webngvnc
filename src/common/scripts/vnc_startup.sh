#!/bin/bash
### every exit != 0 fails the script
set -e

## print out help
help () {
  echo "
  USAGE:
  docker run -it -p 6901:6901 -p 5901:5901 consol/<image>:<tag> <option>

  OPTIONS:
  -w, --wait      (default) keeps the UI and the vncserver up until SIGINT or SIGTERM will received
  -s, --skip      skip the vnc startup and just execute the assigned command.
                  example: docker run consol/rocky-xfce-vnc --skip bash
  -d, --debug     enables more detailed startup output
                  e.g. 'docker run consol/rocky-xfce-vnc --debug bash'
  -h, --help      print out this help
  "
}

if [[ $1 =~ -h|--help ]]; then
  help
  exit 0
fi

# source $STARTUPDIR/generate_container_user
source $HOME/.bashrc 

# if user added '--skip', skip the VNC startup procedure
if [[ $1 =~ -s|--skip ]]; then
    echo -e "\n\n------------------ SKIP VNC STARTUP -----------------"
    echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
    echo "Executing command: '${@:2}'"
    exec "${@:2}"
fi
if [[ $1 =~ -d|--debug ]]; then
    echo -e "\n\n------------------ DEBUG VNC STARTUP -----------------"
    export DEBUG=true
fi

# shutdown signal
cleanup () {
  kill -s SIGTERM $!
  exit 0
}
trap cleanup SIGINT SIGTERM

# apply settings to chromium properties
$STARTUPDIR/chromium-init.sh
source $HOME/.chromium-browser.init

# resolve vnc connection
VNC_IP=$(hostname -i)

# change vnc password
echo -e "\n------------------ change VNC password  ------------------"
mkdir -p "$HOME/.vnc"
PASSWD_PATH="$HOME/.vnc/passwd"

if [[ -f $PASSWD_PATH ]]; then
  echo -e "\n---------  removing existing VNC password settings  ---------"
  rm -f $PASSWD_PATH
fi

if [[ $VNC_VIEW_ONLY == "true" ]]; then
  echo "starting VNC server in VIEW MODE"
  #create random pw to prevent access
  echo $(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20) | vncpasswd -f > $PASSWD_PATH
fi

echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
chmod 600 $PASSWD_PATH

# start vncserver and noVNC webclient
echo -e "\n------------------ start noVNC  ----------------------------"
if [[ $DEBUG == true ]]; then
  echo "$NO_VNC_HOME/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT"
fi

$NO_VNC_HOME/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NO_VNC_POST > $STARTUPDIR/no_vnc_startup.log 2>&1 & PID_SUB=$!

vncserver -kill $DISPLAY &> $STARTUPDIR/vnc_startup.log \
  || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> $STARTUPDIR/vnc_startup.log \
  || echo "no locks present"

echo -e "start vncserver with param: VNC_COL_DEPTH=$VNC_COL_DEPTH, VNC_RESOLUTION=$VNC_RESOLUTION\n..."

vnc_cmd="vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION PasswordFile=$HOME/.vnc/passwd"

if [[ ${VNC_PASSWORDLESS:-} == "true" ]]; then
  vnc_cmd="${vnc_cmd} -SecurityTypes None"
fi

if [[ $DEBUG == true ]]; then
  echo "$vnc_cmd"
fi

$vnc_cmd > $STARTUPDIR/no_vnc_startup.log 2>&1

echo -e "start window manager\n..."
$HOME/wm_startup.sh &> $STARTUPDIR/wm_startup.log

# log connect options
echo -e "\n\n------------------ VNC environment started ------------------"
echo -e "\nVNCSERVER started on DISPLAY= $DISPLAY \n\t=> connect via VNC viewer with $VNC_IP:$VNC_PORT"
echo -e "\nnoVNC HTML client started:\n\t=> connect via http://$VNC_IP:$NO_VNC_PORT/?password=$VNC_PW\n"

if [[ $DEBUG == true ]] || [[ $1 =~ -t|--tail-log ]]; then
  echo -e "\n------------------ $HOME/.vnc/*$DISPLAY.log ------------------"
  tail -f $STARTUPDIR/*.log $HOME/.vnc/*$DISPLAY.log
fi

if [ -z "$1" ] || [[ $1 =~ -w|--wait ]]; then
  wait $PID_SUB
else
  # unknown option command
  echo -e "\n\n------------------ EXECUTE COMMAND ------------------"
  echo "Executing command: '$@'"
  exec "$@"
fi