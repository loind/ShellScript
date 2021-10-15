#!/bin/bash
#

ARR_LIST_IMAGES=(  )
add_image_to_list()
{
    for image in "$@"
    do
        ARR_LIST_IMAGES[${#ARR_LIST_IMAGES[@]}]=$image
    done
}

read -p "Input image to download: " IMAGE
add_image_to_list $IMAGE

IS_CONTINUE_INPUT='Y'
while [[ $IS_CONTINUE_INPUT != 'N' ]]; do
    read -p "Do you want input more image? (image/N): " IS_CONTINUE_INPUT
    if [[ $IS_CONTINUE_INPUT != 'N' ]]; then
        add_image_to_list $IS_CONTINUE_INPUT
    fi
done

for value in "${ARR_LIST_IMAGES[@]}"
do
     echo $value
     docker pull $value
     image_name=$(echo $value | sed -r "s#(.+)\/(.+$)#\2#g" | sed "s/:/-/").tar.gz
     docker save $value | gzip > $image_name
     echo "=================================="
done
