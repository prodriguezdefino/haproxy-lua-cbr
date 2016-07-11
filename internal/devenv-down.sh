#!/bin/bash

echo "shutting down containers"
echo "***********************"
vagrant ssh -c 'docker stop $(docker ps -qa)'
echo "turning vm off"
echo "**************"
vagrant halt
