#! /bin/bash

INIT_FOLDER="$1"

LOG_FILE_PATH=$INIT_FOLDER"/status.log"

INPUT_EXT="$2"
OUTPUT_EXT="$3"

ORIGINAL_FOLDER="Original"
CONVERTED_FOLDER="Converted"
NOTTOCONVERT_FOLDER="NotToConvert"
STATUS_FILE="status"

function convert() {
    ffmpeg -i $1 $2 2>/dev/null
}

function explore() {
    for file in "$1"/* 
        do
            # Folders and files to avoid
            if ! [[ "$file" == *$ORIGINAL_FOLDER* || "$file" == *$CONVERTED_FOLDER* || "$file" == *$NOTTOCONVERT_FOLDER* || "$file" == *$STATUS_FILE* ]] ; then

                # Check if I am analyzing a folder or a file
                if [ ! -d "${file}" ] ; then
                    file_name=$(echo "${file#"$1"}")
                    file_name=${file_name:1}
                    
                    # To take into account only files with the extension specified in the input
                    if [[ "$file" == *"$INPUT_EXT"* ]] ; then
                        mkdir -p $ORIGINAL_FOLDER
                        mkdir -p $CONVERTED_FOLDER

                        renamed_file=${file_name:0:-3}$OUTPUT_EXT

                        # If the converted version of the file to be converted does not already exist
                        if [ ! -f "${renamed_file}" ] ; then
                            echo "############### File: ${file_name}" >> $LOG_FILE_PATH
                            echo "#################### Start conversion" >> $LOG_FILE_PATH

                            convert $file_name $renamed_file

                            echo "#################### Finisch conversion" >> $LOG_FILE_PATH
                        fi;

                        if [ -f "$file_name" ] ; then
                            mv $file_name $ORIGINAL_FOLDER"/."
                        fi;

                        if [ -f "$renamed_file" ] ; then
                            mv $renamed_file $CONVERTED_FOLDER"/."
                        fi;
                    else
                        mkdir -p $NOTTOCONVERT_FOLDER

                        mv $file_name $NOTTOCONVERT_FOLDER"/."
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


main $INIT_FOLDER &
