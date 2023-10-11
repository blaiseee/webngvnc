#!/usr/bin/env bash
### every rexit != 0 fails the script
set -e

echo "Install nginx"
apt-get install -y nginx
apt-get clean -y

# mv "/src/common/scripts/default" "/etc/nginx/sites-available/default"

# param_conf=$(cat <<EOL
# server {
#     listen 80 default_server;
#     # root /headless/noVNC;
#     # index index.html index.htm vnc_lite.html;
#     root /var/www/html;
#     index index.html index.htm index.nginx-debian.html;

#     server_name test.com;
        
#     location / {
#         try_files \$uri \$uri/ /index.html;
#         proxy_http_version 1.1;
#         proxy_set_header Upgrade \$http_upgrade;
#         proxy_set_header Connection "Upgrade";
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$remote_addr;
#         proxy_read_timeout 61s;
#         proxy_buffering off;
#         proxy_pass http://localhost:$NO_VNC_PORT;
#     }
# }
# EOL
# )

# rm /etc/nginx/sites-available/default
# rm /etc/nginx/sites-enabled/default
# echo "$param_conf" > "/etc/nginx/sites-available/default"
# sed -i $param_conf /etc/nginx/sites-available/default
# ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
# nginx -s reload
# nginx -c /etc/nginx/nginx.conf -g "daemon off;"

###

# # rm /etc/nginx/sites-enabled/default
# config_file="/etc/nginx/sites-available/default"
# # nginx_conf="/etc/nginx/nginx.conf"
# param_conf="/etc/nginx/proxy_params"

# param_conf_txt=$(cat <<EOL
# proxy_pass http://localhost:$NO_VNC_PORT/;
# proxy_http_version 1.1;
# proxy_set_header Upgrade $http_upgrade;
# proxy_set_header Connect "Upgrade";
# proxy_set_header Host $host;
# # proxy_conect_timeout 300;
# proxy_read_timeout 61s;
# proxy_buffering off;
# EOL
# )

# echo "$param_conf_txt" >> "$param_conf"

# config_file_txt=$(cat <<EOL
# server {
#   listen $NO_VNC_PORT;
#   listen [::]:$NO_VNC_PORT;

#   server_name test-novnc.com;
#   index index.html;

#   location / {
#     root /www/data;
#     try_files $uri $uri/ /index.html;
#   }

# }
# EOL
# )

# echo "$config_file_txt" > "$config_file"

# # cat <<EOL >"$config_file"
# # server {
# #     listen 6901;
# #     listen [::]:6901;

# #     server_name test-novnc.com;

# #     root /var/www/test-novnc.com;
# #     index index.html index.htm;

# #     location / {
# #         # proxy_pass http://localhost:5901/;
# #         # proxy_set_header Upgrade $http_upgrade;
# #         # proxy_set_header Connection "Upgrade";
# #         # proxy_set_header Host $host;
# #         # root /var/www/html;
# #         # index index.html;
# #     }
# # }
# # EOL

# # config_file=$(cat <<EOL
# # user www-data;
# # daemon off;

# # events {
# # }

# # http {
# #   upstream vnc_proxy {
# #     server localhost:$NO_VNC_PORT;
# #   }

# #   server {
# #     listen $NO_VNC_PORT;
# #     server_name test-novnc.com;

# #     index index.html;

# #     gzip on;
# #     gzip_proxied any;
# #     gzip_types text/plain text/xml text/css application/x-javascript application/javascript;
# #     gzip_vary on;
# #     proxy_connect_timeout       300;
# #     proxy_send_timeout          300;
# #     proxy_read_timeout          300;
# #     send_timeout                300;
# #     location ~ /\.  {return 403;}

# #     # root /apps/client/dist;
# #     location / {
# #       try_files $uri $uri/ /index.html;
# #     }


# #     location /vnc {
# #       index vnc.html;
# #       alias $NO_VNC_HOME;
# #       try_files $uri $uri/ /vnc.html;
# #     }
# #     location /websockify {
# #       proxy_pass https://vnc_proxy;
# #       proxy_http_version 1.1;
# #       proxy_set_header Upgrade $http_upgrade;
# #       proxy_set_header Connection 'Upgrade';
# #       proxy_read_timeout 61s;
# #       proxy_buffering off;
# #     }

# #     listen 443 ssl;
# #     ssl_certificate       /etc/ssl/www.example.com.fullchain.pem;
# #     ssl_certificate_key   /etc/ssl/private/www.example.com.key;
# #     # SSL certs and stuff
# #   }
# # }
# # EOL
# # )

# # echo "$config_file" > $nginx_conf
# # sed -i $config_file $nginx_conf

# # ln -s $config_file /etc/nginx/sites-enabled/
# # systemctl start nginx
# # systemctl enable nginx
# # nginx -t
# # if nginx -t; then
# #   systemctl reload nginx
# # else
# #   echo "Nginx configuration test failed. Pleace check your configuration."
# # fi
# # nginx
# # nginx -t
# # nginx -s reload
# echo "Nginx configuration has been created and applied."