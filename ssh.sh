#!/bin/bash

list_host=($(grep -e "^Host\s" ~/.ssh/config | awk '{print $2}'))
input_index=$1
i=0
for host in ${list_host[@]}; do
    if [ "$1" == "" ]; then
        echo "$i. $host"
    fi

    i=$((i+1))
done

if [ "$input_index" == "" ]; then
    read -e -p "Enter number [0 - $((i-1))]: " index
    index=$((index))
else
    index=$input_index
fi

ssh_cmd=$(echo "ssh ${list_host[$index]}")
echo $ssh_cmd
eval $ssh_cmd
