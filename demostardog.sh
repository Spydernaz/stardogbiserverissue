#!/bin/bash
source ./stardog.env

function run_bi_example {
    tutorial_content="/var/opt/stardog/tutorial-content/demo-vkg"
    echo -e "Setting up Demo 1 - Virtual Knowledge Graphs"
    echo -e "Adding data to MySQL instance"
    mysql -h 127.0.0.1 -P3306 -u root -pPassword@123 -e "CREATE DATABASE music;"
    mysql -h 127.0.0.1 -P3306 -u root -pPassword@123 -D music < ./tutorial-content/demo-vkg/loaddata.sql

    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin db create -n music
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog namespace add --prefix "" --uri "http://stardog.com/tutorial/" music
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin data-source add ${tutorial_content}/music.properties ${tutorial_content}/music_sql-to-stardog_mappings.ttl
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin virtual add --name music --data-source music ${tutorial_content}/music_sql-to-stardog_mappings.ttl

    tutorial_content="/var/opt/stardog/tutorial-content/biserver"
    echo -e "Ensuring there is a BI Mapping for music"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query execute music "clear graph <tag:stardog:api:sql:schema>"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog data add -g tag:stardog:api:sql:schema music ${tutorial_content}/bimapping.ttl

}


function startdemo_fn {
    echo -e "Starting Demo Stardog! \n\n"

    # Start core services
    docker-compose -p demo_stardog -f ./docker-compose.yml up -d

    echo -e "Sleeping for 30 seconds to wait for services to start"
    sleep 30
    echo -e "Services should be started, runing the bi server example setup"

    run_bi_example
}




function stopdemo_fn {
    echo -e "Stopping Demo Stardog! \n\n"
    docker-compose -p demo_stardog -f ./docker-compose.yml down --remove-orphans
}


if [ $1 == "start" ]; then 
    startdemo_fn
elif [ $1 == "stop" ]; then
    stopdemo_fn
elif [ $1 == "biexample" ]; then
    demonum=$2
    run_bi_example
else
    printhelp_fn
fi

