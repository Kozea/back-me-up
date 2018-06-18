#!/bin/bash

#==============================================================================
# FILE : check-backup.sh
# USAGE : check-backup.sh -t target_path
# DESCRIPTION : Check if the last update of the target_path is today
# NOTES : 
#==============================================================================

# Load shared variables and functions
{
    source "$(dirname "$0")/shared.sh" 
} || {
    echo "Unable to load shared.sh" && exit 1 
}

# Parse command line
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -c)
            CONFIGFILE="$2"
            shift
            shift
            ;;
        -t)
            TARGET_PATH="$2"
            shift
            shift
            ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}"

# Exit if there is a missing parameter in the command line
if [ -z "$CONFIGFILE" ]
then
    echo "There is no configfile specified" && exit 1
elif [ -z "$TARGET_PATH" ]
then
    echo "There is no target specified" && exit 1
fi

# Load configfile
{
    echo "* Load ${CONFIGFILE}"
    source "${CONFIGFILE}"
} || {
    echo "Something happens while loading ${CONFIGFILE}" && exit 1
}

TODAY_DATE=$(${DATE} +%Y-%m-%d)

update=$(${STAT} -c %y "${TARGET_PATH}" | ${AWK} '{print $1;}')

if [ ! "$update" == "${TODAY_DATE}" ]
then
    exit 1
fi
