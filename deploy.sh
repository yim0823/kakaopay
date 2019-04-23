#!/bin/bash

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

echo "Copy Build file"

cp ./build/libs/*.jar $REPOSITORY/

EXIST_BLUE=$(DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml ps | grep Up)

if [ -z "$EXIST_BLUE" ]; then
    echo "blue up"
    DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml up --build

    sleep 10

    DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml down
else
    echo "green up"
    DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME}-green -f docker-compose.green.yml up --build

    sleep 10

    DOCKER_HOST=${TARGET_DEPLOY_TCP} docker-compose -p ${DOCKER_APP_NAME}-blue -f docker-compose.blue.yml down
fi
