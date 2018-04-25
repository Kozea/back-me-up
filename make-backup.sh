#!/bin/bash

#==============================================================================
# FILE : make-backup.sh
# USAGE : make-backup.sh -c configfile -b path_to_borg_repo
# DESCRIPTION : Make a back-up with Borg of the files listed in the configfile
# NOTES : 
#==============================================================================

# Load shared variables and functions
{
    source "$(dirname "$0")/shared.sh" 
} || {
    echo -e "\\033[0;31mUnable to load shared.sh\\033[0m" && exit 1 
}

echo -e "${GREEN}make-backup starts !${NC}"

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
        -b)
            BORGREPO="$2"
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
elif [ -z "$BORGREPO" ]
then
    echo -e "${RED}There is no borg repo specified${NC}" && exit 1
fi


# Create and init borg repo if needed
if [ ! -d "$BORGREPO" ]
then
    {
        echo -e "* ${BLUE}Create ${BORGREPO}${NC}"
        ${MKDIR} -p "${BORGREPO}"
        echo -e "* ${BLUE}Init ${BORGREPO}${NC}"
        ${BORG} init --critical --encryption=none "${BORGREPO}"
    } || {
        echo -e "${RED}Unable to create and init ${BORGREPO}${NC}" && exit 1
    }
fi

# Load configfile
{
    echo -e "* ${BLUE}Load ${CONFIGFILE}${NC}"
    source "${CONFIGFILE}"
} || {
    echo -e "${RED}Something happens while loading ${CONFIGFILE}" && exit 1
}

# Create archives
# Files
if [ -z "${FILES}" ]
then
    echo -e "${YELLOW}No files to back-up${NC}"
else
    echo -e "* ${BLUE}Start archiving files${NC}"
fi

for file in "${FILES[@]}"
do
    archive_name=${file}
    if [ "${archive_name:0:1}" = "/" ]
    then
        archive_name=$(echo "${archive_name}" | cut -c2-)
    fi
    archive_name=$(date +%Y-%m-%d)"-"${archive_name//\//-}
    echo -e "${BLUE}Create back-up ${archive_name}${NC}"
    {
        ${BORG} create "${BORGREPO}"::"${archive_name}" "${file}"
    } || {
        if [ $? -eq 2 ]
        then
            echo -e "${YELLOW}Archive already exists${NC}"
        else
            echo -e "${RED}Unable to create the back-up${NC}" && exit 1
        fi
    }
done


echo -e "${GREEN}Back-up succeed !${NC}"