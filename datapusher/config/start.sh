#!/bin/bash

chmod -R u=rwx,g=rwx,o=rwx /tmp/
# start ckan wsgi
service supervisor start

# this keeps the container running
tail -f /dev/null