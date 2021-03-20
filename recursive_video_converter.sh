#! /bin/bash

PATH=""
INPUT_EXT=""
OUTPUT_EXT=""
USE_GPU=false

LOG_FILE_PATH="${pwd}status.log"

ORIGINAL_FOLDER="Original"
CONVERTED_FOLDER="Converted"
NOTTOCONVERT_FOLDER="NotToConvert"
STATUS_FILE="status"

# PARAMS
#
# $1 -> Using the GPU
# $2 -> File to convert
# $3 -> File to convert into
function convert() {
    if [ $1 = true ] 
        then
            ffmpeg -hwaccel cuda -i $2 $3 2>/dev/null
        else
            ffmpeg -i $2 $3 2>/dev/null
        fi;
}

# PARAMS
#
# $1 -> Videos path
# $2 -> File extension to convert
# $3 -> File extension to convert into
# $4 -> Using the GPU
# $5 -> Log file path
function explore() {
    for file in "$1"/* 
        do
            # Folders and files to avoid
            if ! [[ "$file" == *$ORIGINAL_FOLDER* || "$file" == *$CONVERTED_FOLDER* || "$file" == *$NOTTOCONVERT_FOLDER* || "$file" == *$STATUS_FILE* ]] 
                then
                    # Check if I am analyzing a folder or a file
                    if [ ! -d "${file}" ] 
                        then
                            file_name=$(echo "${file#"$1"}")
                            file_name=${file_name:1}
                            
                            # To take into account only files with the extension specified in the input
                            if [[ "$file" == *"$2"* ]] 
                                then
                                    mkdir -p $ORIGINAL_FOLDER
                                    mkdir -p $CONVERTED_FOLDER

                                    renamed_file=${file_name:0:-3}$3

                                    # If the converted version of the file to be converted does not already exist
                                    if [ ! -f "${renamed_file}" ] 
                                        then
                                            echo "############### File: ${file_name}" >> "${5}"
                                            echo "#################### Start conversion" >> "${5}"

                                            convert $4 $2 $3

                                            echo "#################### Finisch conversion" >> "${5}"
                                        fi;

                                    if [ -f "$file_name" ] 
                                        then
                                            mv $file_name $ORIGINAL_FOLDER"/."
                                        fi;

                                    if [ -f "$renamed_file" ] 
                                        then
                                            mv $renamed_file $CONVERTED_FOLDER"/."
                                        fi;
                                else
                                    mkdir -p $NOTTOCONVERT_FOLDER

                                    mv $file_name $NOTTOCONVERT_FOLDER"/."
                                fi;
                        else
                            echo "########## Folder: ${file}" >> "${5}"

                            cd "${file}"

                            explore "${file}"
                        fi;
                fi;
        done
}

function usage() { 
    echo "Usage: $0 " 1>&2
    exit 1
}

function help() {
    echo "HELP"
    exit 1
}

# PARAMS
#
# $1 -> Videos path
# $2 -> File extension to convert
# $3 -> File extension to convert into
# $4 -> Using the GPU
# $5 -> Log file path
function main() {
    if [[ -z "${1}" && -z "${2}" && -z "${3}" ]]
        then
            echo "Empty param"
            exit 1
        fi;
    
    echo "${5}"

    echo "##### START" >> "${5}"

    explore "${1}" "${2}" "${3}" $4 "${5}"

    echo "##### FINISH" >> "${5}"

    exit 0
}

while getopts "p:i:o:l:gh" option ; 
    do
        case "${option}" in
            p)
                PATH="${OPTARG}"
                ;;
            i)
                INPUT_EXT="${OPTARG}"
                ;;
            o)
                OUTPUT_EXT="${OPTARG}"
                ;;
            l)
                LOG_FILE_PATH="${OPTARG}status.log"
                ;;
            g)
                USE_GPU=true
                ;;
            h)
                help
                ;;
            *)
                usage
                ;;
        esac
    done

shift $((OPTIND-1))

main $PATH $INPUT_EXT $OUTPUT_EXT $USE_GPU $LOG_FILE_PATH &