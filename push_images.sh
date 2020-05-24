#!/bin/bash

docker-compose -f docker-compose-local.yml build

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo

docker tag encryption 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:encryption
docker tag backend-api 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:backend-api
docker tag rabbitmq 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:rabbitmq
docker tag prometheus 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:prometheus

docker push 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:encryption 
docker push 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:backend-api 
docker push 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:rabbitmq
# docker push 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:grafana 
docker push 272952936633.dkr.ecr.us-east-1.amazonaws.com/chat-repo:prometheus 
