#/bin/bash

while [[ true ]]; do
    read -p "Enter path to primary audio: " primary_audio
    read -p "Enter path to background music: " background_music
    read -p "Enter file name output: " output

    if [[ -n $primary_audio && -n $background_music && -n $output ]]; then
        break 2
    else
        clear
        echo "Please fillup info."
    fi
done

ffmpeg -i $primary_audio -i $background_music -filter_complex "[0:a]volume=1[a1];[1:a]volume=0.3[a2];[a1][a2]amerge=inputs=2[a]" -map "[a]" $output