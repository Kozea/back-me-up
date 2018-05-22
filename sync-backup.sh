#!/bin/bash

#==============================================================================
# FILE : sync-backup.sh
# USAGE : ./sync-backup.sh -c configfile
# DESCRIPTION : Sync local back-up with a remote server
# NOTES : 
#==============================================================================

# Load shared variables and functions
{
    source "$(dirname "$0")/shared.sh" 
} || {
    echo -e "\\033[0;31mUnable to load shared.sh\\033[0m" && exit 1 
}

echo -e "${GREEN}sync-backup starts !${NC}"

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
fi

# Load configfile
{
    echo -e "* ${BLUE}Load ${CONFIGFILE}${NC}"
    source "${CONFIGFILE}"
} || {
    echo -e "${RED}Something happens while loading ${CONFIGFILE}${NC}" && exit 1
}

# Sync file with remote server
if [[ ! -v RCLONE_REPOS[@] ]]
then
    echo -e "${YELLOW}No rclone repos defined${NC}"
else
    echo -e "* ${BLUE}Start synchronizing files${NC}"
fi

for rclone_conf in "${RCLONE_REPOS[@]}"
do
    remote_name=$(echo "$rclone_conf" | awk '{print $1}')
    if [ "$(${RCLONE} listremotes | grep -c "$remote_name")" -lt 1 ]
    then
        echo -e "${YELLOW}The remote ${remote_name} doesn't exist${NC}"
        echo -e "* ${BLUE}Initializing the remote${NC}"
        {
            password=$(echo "$rclone_conf" | awk '{print $NF}')
            password_obscure=$(${RCLONE} obscure "${password}")
            rclone_conf=$(sed "s/${password}/${password_obscure}/" <<< "${rclone_conf}")
            ${RCLONE} config create ${rclone_conf}
        } || {
            echo -e "${RED}Failed to create the remote ${remote_name}${NC}" && exit 1
        }
    fi
    for sync_instruction in "${RCLONE_SYNC[@]}"
    do
        {
            echo -e "${BLUE}Sync ${sync_instruction}${NC}"
            ${RCLONE} sync ${sync_instruction}
        } || {
            echo -e "${RED}Failed to sync ${sync_instruction}${NC}" && exit 1
        }
    done
done

echo -e "${GREEN}Sync succeed !${NC}"
