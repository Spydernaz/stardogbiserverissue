#!/bin/bash
source ./stardog.env


# Print out the purpose of the script
printf "\n\nProject Demo Stardog\n---------\nThis project is intended to bootstrap a log management and analytics environment based on Open Distro ELK and Kafka. 
It includes out-of-the-box research datasets from the wonderful Mordor project built by the Open Threat Research Forge.\n\n"


function printhelp_fn {
    printf "This script functions as the controller for the environment."
    printf "The available routines are 'start', 'stop', 'gendata' and 'help'"
}


function checkrequirements_fn {
    failed=0
    printf "Using `docker-compose -v`" || failed=1

    if [ $failed == 1 ]; then
        exit 128
    fi
}


function startdemo_fn {
    printf "Starting Demo Stardog! \n\n"

    
    # Start core services
    docker compose -p demo_stardog -f ./docker-compose.yml up -d

    printf "Sleeping for 30 seconds to wait for services to start"
    sleep 30

    # Complete any Setup
    #docker exec -it demo_stardog_kafka_1
    
    gendata_fn

}


function gendata_fn {
    printf "Generating a sample dataset to PostgreSQL"

    printf "NOT IMPLEMENTED \n\n"
    printf "Data not generated"
    exit 128

    exit 0
    
}

function runsetup_fn {
    printf "NOT IMPLEMENTED \n\n"
    exit 128
}

function demo_1 {
    printf "Setting up Demo 1"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin db create -n music
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog namespace add --prefix "" --uri "http://stardog.com/tutorial/" music
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin virtual add /var/opt/stardog/tutorial-content/demo-vkg/music.properties /var/opt/stardog/tutorial-content/demo-vkg/music_mappings.ttl

}

function demo_2 {
    printf "Setting up Demo 2"
    printf "Creating the database"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin db create -o search.enabled=true docs.opennlp.models.path=/var/opt/stardog/tutorial-content/entity-extraction/models -n movies /var/opt/stardog/tutorial-content/entity-extraction/person_movie.ttl
    printf "Adding an article"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog doc put movies -r entities /var/opt/stardog/tutorial-content/entity-extraction/article.txt
    printf "You should be able to see a new article (check demo2.md for the query)"
    printf "Linking the document/entities"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog doc put movies --rdf-extractors tika,entities,linker /var/opt/stardog/tutorial-content/entity-extraction/article2.txt

}



function readdata_fn {
    printf "not implemented"
    # docker exec -it Demo Stardog_kafka_1 kafka-console-consumer --from-beginning --bootstrap-server kafka:9092 --topic flink_test_out
    exit 128
}


function stopdemo_fn {
    printf "Stopping Demo Stardog! \n\n"
    docker-compose -p demo_stardog -f ./docker-compose.yml down --remove-orphans
}


if [ $1 == "start" ]; then 
    startdemo_fn
elif [ $1 == "stop" ]; then
    stopdemo_fn
elif [[ $1 == "generate_data" || $1 == "gendata" ]]; then 
    gendata_fn
elif [ $1 == "help" ]; then
    printhelp_fn
elif [ $1 == "setup" ]; then
    runsetup_fn
elif [ $1 == "demo" ]; then
    demonum=$2
    demo_${demonum}
else
    printhelp_fn
fi




# $OUTPUT=""
# while [ $OUTPUT != "Successfully created database 'music'." ]; do
# $OUTPUT=`docker exec -it ${CONTAINER_ID} ${STARDOG_PATH}/stardog-admin db create -n music`
# done

# while [ $OUTPUT != "Successfully added the namespace." ]; do
# $OUTPUT=`docker exec -it ${CONTAINER_ID} ${STARDOG_PATH}/stardog namespace add --prefix "" --uri "http://stardog.com/tutorial/" music`
# done

# while [ $OUTPUT != "Successfully added virtual graph music" ]; do
# $OUTPUT=`docker exec -it ${CONTAINER_ID} ${STARDOG_PATH}/stardog-admin virtual add ${STARDOG_HOME}/tutorial-content/demo-vkg/music.properties ${STARDOG_HOME}/tutorial-content/demo-vkg/music_mappings.ttl`
# done


# docker exec -it ${CONTAINER_ID} ${STARDOG_PATH}/stardog-admin db create -n music
# docker exec -it ${CONTAINER_ID} ${STARDOG_PATH}/stardog namespace add --prefix "" --uri "http://stardog.com/tutorial/" music
# docker exec -it ${CONTAINER_ID} ${STARDOG_PATH}/stardog-admin virtual add ${STARDOG_HOME}/tutorial-content/demo-vkg/music.properties ${STARDOG_HOME}/tutorial-content/demo-vkg/music_mappings.ttl
