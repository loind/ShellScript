#!/bin/bash

# sudo su - kafka
kafka_host="kafka1:9092"

BASEDIR=$(dirname "$0")
cd $BASEDIR

list_group=(`bin/kafka-consumer-groups.sh --bootstrap-server $kafka_host --list | sort`)

if [[ ! -z $1 ]]; then
    group_name=${list_group[$1]}
    echo "You selected: $group_name"
    bin/kafka-consumer-groups.sh --bootstrap-server $kafka_host --describe --group $group_name

else
    i=0
    for group in ${list_group[@]}; do
        echo "$i. $group"
        i=$((i+1))
    done
    echo ""
    read -e -p "Enter index group: (-1: show all): " index

    if [[ $index == -1 ]]; then
        for group in ${list_group[@]}; do
            echo "---------- $group ----------"
            bin/kafka-consumer-groups.sh --bootstrap-server $kafka_host --describe --group $group
            echo ""
        done
    else
        group_name=${list_group[$index]}
        echo "You selected: $group_name"
        bin/kafka-consumer-groups.sh --bootstrap-server $kafka_host --describe --group $group_name
    fi
fi
