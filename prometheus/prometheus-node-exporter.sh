#!/bin/sh

if [ $(id -u) -eq 0 ]
then
  : root
else
  echo "not root, please run with sudo"
  exit 1
fi

# Add unprivileged user
useradd node_exporter -s /sbin/nologin

# Get node exporter binary and copy it into place
if [ -x /usr/bin/wget ]; then
    echo "Checking for wget... found"
    wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
    tar xvfz node_exporter-*.*-amd64.tar.gz
    cp node_exporter-*.*-amd64/node_exporter /usr/sbin/
else
    command -v wget >/dev/null 2>&1 || { echo >&2 "Please install wget or set it in your path. Aborting."; exit 1; }
fi

# Create launchdaemon to start node exporter binary
/bin/cat << EOF > "/etc/systemd/system/node_exporter.service"
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter $OPTIONS

[Install]
WantedBy=multi-user.target
EOF

# Create the config file
mkdir -p /etc/sysconfig
touch /etc/sysconfig/node_exporter

# reload daemon, enable and launch the service
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# Verify metrics are being pulled

if [ ! -x /usr/bin/curl ] ; then
    # some extra check if curl is not installed at the usual place
    command -v curl >/dev/null 2>&1 || { echo >&2 "Please install curl to verify metrics. Skipping  metrics check."; exit 1; }
else 
    curl http://localhost:9100/metrics
fi

exit 0
