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

# Sync files with remote server with rclone
if [[ ! -v RCLONE_REPOS[@] ]]
then
    echo -e "${YELLOW}No rclone repos defined${NC}"
else
    echo -e "* ${BLUE}Start synchronizing files${NC}"
    for rclone_conf in "${RCLONE_REPOS[@]}"
    do
        remote_name=$(echo "$rclone_conf" | ${AWK} '{print $1}')
        if [ "$('rclone' listremotes | grep -c "$remote_name")" -lt 1 ]
        then
            echo -e "${YELLOW}The remote ${remote_name} doesn't exist${NC}"
            echo -e "* ${BLUE}Initializing the remote${NC}"
            {
                password=$(echo "$rclone_conf" | ${AWK} '{print $NF}')
                password_obscure=$('rclone' obscure "${password}")
                rclone_conf=$('sed' "s/${password}/${password_obscure}/" <<< "${rclone_conf}")
                'rclone' config create ${rclone_conf}
            } || {
                echo -e "${RED}Failed to create the remote ${remote_name}${NC}" && exit 1
            }
        fi
        for sync_instruction in "${RCLONE_SYNC[@]}"
        do
            {
                echo -e "${BLUE}Sync ${sync_instruction}${NC}"
                'rclone' sync ${sync_instruction}
            } || {
                echo -e "${RED}Failed to sync ${sync_instruction}${NC}"
            }
        done
    done
fi

# Execute sync commands
if [ -n "$(type sync)" ]
then
    echo -e "${BLUE}Executing sync commands${NC}"
    {
        sync
    } || {
        echo -e "${YELLOW}Failed to execute \"function sync\"${NC}"
    }
else
    echo -e "${YELLOW}No sync command found${NC}"
fi

# Execute after sync commands
if [ -n "$(type after_sync)" ]
then
    echo -e "${BLUE}Executing after commands${NC}"
    {
        after_sync
    } || {
        echo -e "${YELLOW}Failed to execute \"function after_sync\"${NC}"
    }
fi

echo -e "${GREEN}Sync succeed !${NC}"
