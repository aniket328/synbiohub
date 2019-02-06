#!/bin/bash

cd tests

source ./testutil.sh

# first, if it was run with help, just run the test script with help
if [[ "$@" == "--help" || "$@" == "-h" ]]
then
    python3 test_suite.py "$@"
    exit 0
fi

message "Running synbiohub test suite."
message "Cleaning old test containers if they exist"

bash ./testcleanup.sh


message "pulling synbiohub/synbiohub-docker"
if cd synbiohub-docker; then
    git checkout snapshot;
    git pull;
    cd ..;
else
    # clone the synbiohub docker compose file in order to run docker containers
    git clone --single-branch --branch snapshot https://github.com/synbiohub/synbiohub-docker
fi


message "Starting SynBioHub from Containers"
docker-compose -f ./synbiohub-docker/docker-compose.yml -p testsuiteproject up -d
while [[ "$(docker inspect testsuiteproject_synbiohub_1 | jq .[0].State.Health.Status)" != "\"healthy\"" ]]
do
    sleep 5
    message "Waiting for synbiohub container to be healthy."
done

message "Started successfully"

for var in "$@"
do
    if [[ $var == "--stopafterstart" ]]
    then
	echo "Exiting after starting up test server."
	exit 1
    fi
done

message "Running test suite."

# run the set up script

python3 test_suite.py "$@"
exitcode=$?
if [ $exitcode -ne 0 ]; then
    message "Exiting with code $exitcode."
    exit $exitcode
fi

for var in "$@"
do
    if [[ $var == "--stopaftertestsuite" ]]
    then
	echo "Stopping after test suite ran."
	exit 0
    fi
done

bash ./run_sboltestrunner.sh


# stop the containers
message "Stopping containers"
docker stop testsuiteproject_synbiohub_1
docker stop testsuiteproject_explorer_1
docker stop testsuiteproject_autoheal_1
docker stop testsuiteproject_virtuoso_1


message "finished running tests"
