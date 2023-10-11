FROM debian:11-slim
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT 80
# EXPOSE $VNC_PORT 80

ENV HOME=/headless \
    DOCKERSTARTUP=/dockerstartup \
    INSTALL_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC 

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.en \
    LC_ALL=en_US.UTF-8

ENV VNC_RESOLUTION=1280x1024 \
    VNC_DEPTH=24 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false

WORKDIR $HOME

ADD ./src/common/install/ $INSTALL_SCRIPTS/
ADD ./src/debian/install/ $INSTALL_SCRIPTS/

RUN $INSTALL_SCRIPTS/tools.sh
RUN $INSTALL_SCRIPTS/nginx.sh
RUN $INSTALL_SCRIPTS/tigervnc.sh
RUN $INSTALL_SCRIPTS/xfce_ui.sh
RUN $INSTALL_SCRIPTS/no_vnc.sh
RUN $INSTALL_SCRIPTS/chromium.sh

ADD ./src/common/xfce/ $HOME/

RUN $INSTALL_SCRIPTS/libnss_wrapper.sh

ADD ./src/common/scripts $DOCKERSTARTUP

RUN $INSTALL_SCRIPTS/set_user_permission.sh $DOCKERSTARTUP $HOME

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends \
    # net-tools \
    # xinit \
    # locales \
    # procps \
    # apt-utils \
    # xterm \
    # xfce4 \
    # novnc \
    # websockify \
    # python3-numpy \
    # supervisor \
    # tigervnc-standalone-server \
    # dbus-x11 \
    # libdbus-glib-1-2 \
    # chromium && \
    # ln -sfn /usr/bin/chromium /usr/bin/chromium-browser \
    # /app/src/debian/install/libnss_wrapper.sh \
    # /app/src/common/install/set_user_permission.sh $DOCKERSTARTUP $HOME

# ADD ./src/common/scripts $DOCKERSTARTUP

# RUN $DOCKERSTARTUP/chromium-init.sh
# RUN apt-get purge -y pm-utils *screensaver*
# RUN source $HOME/.chromium-browser.init
# RUN apt-get autoclean
# RUN apt-get autoremove
# RUN rm -rf /var/lib/apt/lists/*

# USER 1000

ENTRYPOINT ["/dockerstartup/entrypoint.sh"]
CMD ["--wait"]