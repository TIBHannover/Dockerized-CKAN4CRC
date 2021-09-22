#!/bin/bash

source bin/activate
ckan -c config/ckan.ini db init
service supervisor start
tail -f /dev/null


