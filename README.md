# AWS Project

## Running ansible

ansible-playbook -v -i “localhost,” test.yaml

## Checking ngingx logs

sudo less /var/log/nginx/error.log
sudo less /var/log/nginx/access.log


## Getting new certs

Comment out "listen SSL 443" in nginx configuration

sudo certbot --nginx -m <email> --agree-tos --no-eff-email -d mastodon.imichka.me

## Reverse proxy https / http tricks

https://blog.vyvojari.dev/mastodon-behind-a-reverse-proxy-without-ssl-https/
