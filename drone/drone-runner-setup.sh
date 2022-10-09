#!/bin/bash

docker run --detach \
	--volume=/var/run/docker.sock:/var/run/docker.sock \
	--env=DRONE_RPC_PROTO=https \
	--env=DRONE_RPC_HOST=sub.domain.tld \
  	--env=DRONE_RPC_SECRET=<drone_RPC_Secret> \
	--env=DRONE_RUNNER_CAPACITY=2 \
	--env=DRONE_RUNNER_NAME=docker-runners \
	--publish=3000:3000 \
	--restart=always \
	--name=runner \
	drone/drone-runner-docker:1
