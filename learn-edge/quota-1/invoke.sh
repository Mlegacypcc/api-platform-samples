#!/bin/bash


## Ask the user for input.

source ../scripts/set_env.sh

printf "\nEnter your password for the Apigee Enterprise organization $org, followed by [ENTER]:\n"
read -s password

source ../scripts/verify_credentials.sh
source ../scripts/verify_provisioning.sh


## Use the Edge Management API to get the API key.

printf "\n\nGet API key (the Consumer Key) from the Learn Edge App. Press Return to continue: \n"
read
key=`curl -u $username:$password $url/v1/o/$org/developers/learn-edge-developer@example.com/apps/learn-edge-app 2>/dev/null \
     | grep consumerKey | awk -F '\"' '{ print $4 }'`

printf "\nThe API key (Consumer Key) for the Learn Edge App is $key\n"

## Call the API

printf "\nWith a quota of 3 requests per minute, call the API 10 times in quick succession. Press Return to contine:\n"
read

CALL_COUNTER=10

printf "\ncurl http://$org-$env.$api_domain/v1/learn-edge/json?apikey=$key\n\nResponse:\n"

while [ $CALL_COUNTER -ge 0 ]
do
        curl "http://$org-$env.$api_domain/v1/learn-edge/json?apikey=$key"
        printf "\n"
        sleep .5
  ((CALL_COUNTER--))
done

## All done.
