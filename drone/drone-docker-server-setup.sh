#!/bin/bash
# Create a drone.io host with docker
# You need to link this to a repository, this script assumes you have a gitea server setup
# https://docs.drone.io/server/provider/gitea/
# Insert your gitea server url, client id and secret
# You may also have to setup lets encrpyt on the host as well. Shit I can't remember how I did that.
# But, the script maps volumes to the letsencrypt public and private keys
# Joe Schlimmer 2022-10-09

docker run \
  --volume=/var/lib/drone:/data \
  --volume=/etc/letsencrypt/live/sub.domain.tld/fullchain.pem:/etc/certs/sub.domain.tld/fullchain.pem \
  --volume=/etc/letsencrypt/live/sub.domain.tld/privkey.pem:/etc/certs/sub.domain.tld/privkey.pem \
  --env=DRONE_GITEA_SERVER=https://sub.domain.tld \
  --env=DRONE_GITEA_CLIENT_ID=<Gitea_client_id> \
  --env=DRONE_GITEA_CLIENT_SECRET=<Gitea_client_secret> \
  --env=DRONE_RPC_SECRET=<RPC_secret> \
  --env=DRONE_SERVER_HOST=sub.domain.tld \
  --env=DRONE_TLS_CERT=/etc/certs/sub.domain.tld/fullchain.pem \
  --env=DRONE_TLS_KEY=/etc/certs/sub.domain.tld/privkey.pem \
  --env=DRONE_SERVER_PROTO=https \
  --publish=80:80 \
  --publish=443:443 \
  --restart=always \
  --detach=true \
  --name=drone \
  drone/drone:2
