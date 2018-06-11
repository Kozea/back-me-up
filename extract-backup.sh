#!/bin/bash

#==============================================================================
# FILE : extract-backup.sh
# USAGE : extract-backup.sh -c configfile -t target_name
# DESCRIPTION : Extract a Borg back-up
# NOTES : 
#==============================================================================

# Load shared variables and functions
{
    source "$(dirname "$0")/shared.sh" 
} || {
    echo -e "\\033[0;31mUnable to load shared.sh\\033[0m" && exit 1 
}

echo -e "${GREEN}extract-backup starts !${NC}"

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
            TARGET_NAME="$2"
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
    echo -e "${RED}There is no configfile specified${NC}" && exit 1
elif [ -z "$TARGET_NAME" ]
then
    echo -e "${RED}There is no target specified${NC}" && exit 1
fi

# Load configfile
{
    echo -e "* ${BLUE}Load ${CONFIGFILE}${NC}"
    source "${CONFIGFILE}"
} || {
    echo -e "${RED}Something happens while loading ${CONFIGFILE}${NC}" && exit 1
}


PASSPHRASE="${TARGET_NAME}_PASSPHRASE"
BASE_LOCATION="${TARGET_NAME}_ARCHIVES_LOCATION"
EXTRACT_PATH="${TARGET_NAME}_EXTRACT_PATH"
TO_EXTRACT="${TARGET_NAME}_ARCHIVES_TO_EXTRACT"[@]
TO_RESTORE="${TARGET_NAME}_POSTGRES_INSTRUCTIONS"[@]

{
    export BORG_PASSPHRASE=${!PASSPHRASE}
} || {
    echo -e "${RED}Failed to export BORG_PASSPHRASE${NC}" && exit 1
}

{
    cd "${!EXTRACT_PATH}"
} || {
    echo -e "${RED}${!EXTRACT_PATH} not found${NC}" && exit 1
}

# Execute before extract commands
if [ -n "$(type before_extract)" ]
then
    echo -e "${BLUE}Executing before commands${NC}"
    {
        before_extract
    } || {
        echo -e "${YELLOW}Failed to execute \"function before_extract\"${NC}"
    }
fi

for extract in "${!TO_EXTRACT}"
do
    {
        echo -e "${BLUE}Extracting : ${extract}${NC}"
        ${BORG} extract ${!BASE_LOCATION}::${extract}
    } || {
        echo -e "${YELLOW}Something went wrong when extracting ${extract}${NC}"
    }
done

for restore in "${!TO_RESTORE}"
do
    {
        echo -e "${BLUE}Restoring : ${restore}${NC}"
        $restore
    } || {
        echo -e "${YELLOW}Something went wrong while restoring ${restore}${NC}"
    }
done

# Execute after extract commands
if [ -n "$(type after_extract)" ]
then
    echo -e "${BLUE}Executing after commands${NC}"
    {
        after_extract
    } || {
        echo -e "${YELLOW}Failed to execute \"function after_extract\"${NC}"
    }
fi

echo -e "${GREEN}extract-backup ended !${NC}"
