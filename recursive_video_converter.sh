#! /bin/bash

ORIGINAL_FOLDER="$1"

LOG_FILE_PATH=$ORIGINAL_FOLDER"/status.log"

INPUT_EXT="$2"
OUTPUT_EXT="$3"

function convert() {
    ffmpeg -i $1 $2 2>/dev/null
}

function explore() {

    for file in "$1"/* 
        do
            if ! [[ "$file" == *"Original"* || "$file" == *"Converted"* || "$file" == *"NotToConvert"* || "$file" == *"status"* ]] ; then
                if [ ! -d "${file}" ] ; then

                    file_name=$(echo "${file#"$1"}")
                    file_name=${file_name:1}
                    
                    if [[ "$file" == *"$INPUT_EXT"* ]] ; then
                        mkdir -p Original
                        mkdir -p Converted

                        renamed_file=${file_name:0:-3}$OUTPUT_EXT

                        if [ ! -f "${renamed_file}" ] ; then
                            echo "############### File: ${file_name}" >> $LOG_FILE_PATH
                            echo "#################### Start conversion" >> $LOG_FILE_PATH

                            # convert $file_name $renamed_file
                            
                            echo "#################### Finisch conversion" >> $LOG_FILE_PATH
                        fi;

                        if [ -f "$file_name" ] ; then
                            mv $file_name Original/.
                        fi;

                        if [ -f "$renamed_file" ] ; then
                            mv $renamed_file Converted/.
                        fi;
                    else
                        mkdir -p NotToConvert

                        mv $file_name NotToConvert/.
                    fi;
                else
                    
                    echo "########## Folder: ${file}" >> $LOG_FILE_PATH

                    cd "${file}"

                    explore "${file}"
                fi;
            fi;
        done
}

function main() {
    echo "##### START" >> $LOG_FILE_PATH

    explore "${1}"
    
    echo "##### FINISH" >> $LOG_FILE_PATH
}


main $ORIGINAL_FOLDER &
