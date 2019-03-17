#!/bin/bash

#==============================================================================
# FILE : check-backup.sh
# USAGE : check-backup.sh -t target_path
# DESCRIPTION : Check if the last update of the target_path is today
# NOTES : 
#==============================================================================

set -euo pipefail

# Load shared variables and functions
{
    'source' "$(dirname "$0")/shared.sh" 
} || {
    'echo' "Unable to load shared.sh" && exit 1 
}

# Parse command line
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -c|--configfile)
            CONFIGFILE="$2"
            'shift'
            'shift'
            ;;
        -t|--target)
            TARGET_PATH="$2"
            'shift'
            'shift'
            ;;
        *)
        POSITIONAL+=("$1")
        'shift'
        ;;
    esac
done
set -- "${POSITIONAL[@]}"

# Load configfile
{
    'source' "${CONFIGFILE}"
} || {
    'echo' "Something happens while loading ${CONFIGFILE}" && exit 1
}

TODAY_DATE=$('date' +%Y-%m-%d)

update=$('stat' -c %y "${TARGET_PATH}" | 'awk' '{print $1;}')

if [ ! "$update" == "${TODAY_DATE}" ]
then
    exit 1
fi
