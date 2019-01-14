#!/bin/bash

set -x;
cd /users/domains

su - webapp -c "/users/mwe/tmp/files/xappstop.sh"
sleep 15
su - webapp -c "/users/mwe/tmp/files/xnm_stopall.sh"