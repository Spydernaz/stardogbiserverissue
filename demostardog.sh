#!/bin/bash
source ./stardog.env


# Print out the purpose of the script
echo -e "\n\nProject Demo Stardog\n---------\nThis project is intended to bootstrap a log management and analytics environment based on Open Distro ELK and Kafka. 
It includes out-of-the-box research datasets from the wonderful Mordor project built by the Open Threat Research Forge.\n\n"


function printhelp_fn {
    echo -e "This script functions as the controller for the environment."
    echo -e "The available routines are 'start', 'stop', 'gendata' and 'help'"
}


function checkrequirements_fn {
    failed=0
    echo -e "Using `docker-compose -v`" || failed=1

    if [ $failed == 1 ]; then
        exit 128
    fi
}


function startdemo_fn {
    echo -e "Starting Demo Stardog! \n\n"

    
    # Start core services
    docker-compose -p demo_stardog -f ./docker-compose.yml up -d

    echo -e "Sleeping for 30 seconds to wait for services to start"
    sleep 30

    # Complete any Setup
    #docker exec -it demo_stardog_kafka_1
    
    gendata_fn

}


function gendata_fn {
    echo -e "Generating a sample dataset to PostgreSQL"

    echo -e "NOT IMPLEMENTED \n\n"
    echo -e "Data not generated"
    exit 128

    exit 0
    
}

function runsetup_fn {
    echo -e "NOT IMPLEMENTED \n\n"
    exit 128
}

function demo_1 {
    echo -e "Setting up Demo 1"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin db create -n music
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog namespace add --prefix "" --uri "http://stardog.com/tutorial/" music
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin data-source add /var/opt/stardog/tutorial-content/demo-vkg/music.properties /var/opt/stardog/tutorial-content/demo-vkg/music_sql-to-stardog_mappings.ttl
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin virtual add --name music --data-source music /var/opt/stardog/tutorial-content/demo-vkg/music_sql-to-stardog_mappings.ttl

    echo -e "Ensuring there is a BI Mapping for music"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query execute music "clear graph <tag:stardog:api:sql:schema>"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog data add -g tag:stardog:api:sql:schema music /var/opt/stardog/tutorial-content/biserver/bimapping.ttl

}

function demo_2 {
    echo -e "Setting up Demo 2\n"
    echo -e "Creating the database \"actors\"\n"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin db create -o search.enabled=true docs.opennlp.models.path=/var/opt/stardog/tutorial-content/entity-extraction/models -n actors /var/opt/stardog/tutorial-content/entity-extraction/person_movie.ttl
    echo -e "\nAdding an article"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog doc put actors -r entities /var/opt/stardog/tutorial-content/entity-extraction/article.txt
    echo -e "\nYou should be able to see a new article (check demo2.md for the query)"
    echo -e "\nLinking the document/entities"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog doc put actors --rdf-extractors tika,entities,linker /var/opt/stardog/tutorial-content/entity-extraction/article2.txt

}

function demo_3 {
    tutorial_content="/var/opt/stardog/tutorial-content/machinelearning"
    echo -e "\n\nSetting up Demo 3 - Machine Learning\n\n"
    echo -e "\nCreating database - \"movies\" and loading data"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog-admin db create -n movies ${tutorial_content}/movies.ttl
    echo -e "\nShowing the distribution of rating in dataset\n"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/1-histogram.sparql
    
    echo "Press any key to continue:"
    read -n 1 -s
    echo -e "Creating a regression model named `:r1`, that will predict a movie's average user rating based on its genres, content rating, storyline, and metacritic score."
    echo "Press any key to continue:"
    read -n 1 -s
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/2-simple_model.sparql
    echo -e "\nUsing [hyperparameter optimization](https://www.stardog.com/docs/#_hyperparameter_optimization), we can decrease the error rate"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/3-tweaked_parameters.sparql
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/3.1-score.sparql
    read -n 1 -s
    echo -e "\nShow actual and predicted ratings"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/4-predicted_ratings.sparql
    
    read -n 1 -s
    echo -e "\n\n\nModel 2: Generate Movie Recommendations: Classification"
    read -n 1 -s
    echo -e "\nSelect which movies are we interested in being able to suggest as recommendations. For the purpose of this tutorial, we took a sample of 100 movies"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/5-top_recommended_movies.sparql
    echo -e "\nCreating a classification model named ':c1' and score"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/6-recommender_model.sparql
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/6.1.score.sparql
    echo -e "\nHere are the top 5 recommended movies for [The Big Lebowski](https://www.youtube.com/watch?v=PztgWdMEJdg):"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/7-recommended_movies.sparql

    read -n 1 -s
    echo -e "\n\n\nModel 3: Generate Movie Recommendations: Similarity"
    read -n 1 -s
    echo -e "\nCreating a similarity model named ':s1'"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/8-similarity_model.sparql
    read -n 1 -s
    echo -e "\nHere are the top 5 recommended movies for [The Big Lebowski](https://www.youtube.com/watch?v=PztgWdMEJdg):"
    docker exec -it demo_stardog_stardog_1 ${STARDOG_PATH}/stardog query movies ${tutorial_content}/9-similarity_search.sparql







}



function readdata_fn {
    echo -e "not implemented"
    # docker exec -it Demo Stardog_kafka_1 kafka-console-consumer --from-beginning --bootstrap-server kafka:9092 --topic flink_test_out
    exit 128
}


function stopdemo_fn {
    echo -e "Stopping Demo Stardog! \n\n"
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
