#!/bin/bash
export USER_NAME=$(id -un)
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export GROUP_NAME=$(id -gn)

if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform
    export BASE_DIRECTORY="/Users"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform
    export BASE_DIRECTORY="/home"
fi

mkdir -p $BASE_DIRECTORY/$USER_NAME/mod-user-files
mkdir -p $BASE_DIRECTORY/$USER_NAME/mod-data
mkdir -p $BASE_DIRECTORY/$USER_NAME/mod-pedalboards

docker build --progress=plain --progress=plain  --rm -f "mod-host/Dockerfile" -t mod-host "mod-host"
docker build --progress=plain --rm -f "mod-plugin-builder/Dockerfile" --build-arg USERNAME=$USER_NAME --build-arg USERID=$USER_ID --build-arg GROUPID=$GROUP_ID -t mod-plugin-builder "mod-plugin-builder"
docker build --progress=plain  --rm -f "mod-ui/Dockerfile" --build-arg USERNAME=$USER_NAME -t mod-ui "mod-ui"

docker-compose up --no-build mod-ui
