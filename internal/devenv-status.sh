#!/bin/bash
vagrant ssh -c 'docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.RunningFor}}"'
