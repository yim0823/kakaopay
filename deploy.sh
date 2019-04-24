#!/bin/bash

###################################################
# This file is for non-disruptive deployment.
###################################################

REPOSITORY=/usr/app
SERVICE_NAME=kakaopay
PROJECT_NAME=spring-boot-sample-web-ui

DOCKER_APP_NAME=kakaopay_server

cd $REPOSITORY

echo "Git Pull"

git pull

echo "Start Build"

cd $REPOSITORY/$SERVICE_NAME/$PROJECT_NAME
./gradlew build

EXIST_BLUE=$(docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml ps | grep Up)
EXIST_GREEN=$(docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml ps | grep Up)

if [ -z "$EXIST_BLUE" ]; then
    echo "blue up"
    docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up -d

    sleep 10

    docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml down
elif [ -z "$EXIST_GREEN" ]; then
    echo "green up"
    docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml up -d

    sleep 10

    docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml down
else
    echo "Build images before starting containers."
    docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up --build
fi
