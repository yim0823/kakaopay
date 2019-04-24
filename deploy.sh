#!/bin/bash

##########################################################################################
# This file is for non-disruptive deployment.
# You have to change a variable's value, TARGET_DEPLOY_TCP, to your docker machine 
# when using the script. In order to execute the docker CLI, It uses Docker remote API 
# in this script.
##########################################################################################

REPOSITORY=/usr/app
SERVICE_NAME=kakaopay
PROJECT_NAME=spring-boot-sample-web-ui

TARGET_DEPLOY_TCP=tcp://13.124.96.59:2375
DOCKER_APP_NAME=kakaopay_server

cd $REPOSITORY

echo "Git Pull"

git pull

echo "Start Build"

cd $REPOSITORY/$SERVICE_NAME/$PROJECT_NAME
./gradlew build

EXIST_BLUE=$(docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml ps | grep Up)

if [ -z "$EXIST_BLUE" ]; then
    echo "blue up"
    docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up -d

    sleep 10

    docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml down
else
    echo "green up"
    docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml up -d

    sleep 10

    docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml down
fi
