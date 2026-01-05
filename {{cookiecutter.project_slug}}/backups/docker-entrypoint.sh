#!/bin/bash
set -eux
touch /var/log/cron.log
printenv > /etc/environment && cron && tail -f /var/log/cron.log
