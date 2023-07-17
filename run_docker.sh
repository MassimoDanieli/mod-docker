#!/bin/bash
export USER_NAME=$(id -un)
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export GROUP_NAME=$(id -gn)

if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform
    BASE_DIRECTORY="/Users"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform
    BASE_DIRECTORY="/home"
fi

mkdir -p $BASE_DIRECTORY/$USER_NAME/mod-user-files
mkdir -p $BASE_DIRECTORY/$USER_NAME/mod-data
mkdir -p $BASE_DIRECTORY/$USER_NAME/mod-pedalboards

docker pull raidolo:mod-docker 

docker-compose up --no-build mod-ui

