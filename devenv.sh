#!/bin/bash

# get current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# add alias for the dev env
alias devenv='sh $DIR/devenv.sh'

case "$1" in
    down)
        source internal/devenv-down.sh
        ;;
    reload)
        source internal/devenv-reload-containers.sh
        ;;
    logs)
        source internal/devenv-logs.sh $2
        ;;
    status)
        source internal/devenv-status.sh
        ;;
    up)
        source internal/devenv-up.sh
        ;;
    inspect)
        source internal/devenv-inspect.sh $2
        ;;
     
    *)
        echo $"Usage: $0 {down|reload|logs <container>|up|inspect <container>|status}"
        exit 1
esac