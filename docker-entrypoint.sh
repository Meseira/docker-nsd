#!/bin/bash

set -e

# Clean files related to some previous run
rm -f /var/run/nsd3/nsd.pid
rm -f /var/lib/nsd3/nsd.db

# Rebuild the database
nsdc -c /etc/nsd3/nsd.conf rebuild

# Start NSD
/usr/sbin/nsd -d -c /etc/nsd3/nsd.conf -l /var/log/nsd/nsd.log
