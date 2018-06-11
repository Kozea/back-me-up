#!/bin/bash

#==============================================================================
# FILE : extract-backup-config.sh
# USAGE : source extract-backup-config.sh
# DESCRIPTION : Configfile example for extract-back-up.sh
# NOTES : 
#==============================================================================
function before_extract {
    # some stuff to perform before extract starts
    echo "${BLUE}Before extract${NC}"
}

function after_extract {
    # some stuff to perform when extract is done
    echo "${BLUE}After extract${NC}"
}

NAME1_PASSPHRASE="superpassphrase"
NAME2_PASSPHRASE="superpassphrase"
NAME3_PASSPHRASE="superpassphrase"

NAME1_ARCHIVES_LOCATION="/path/where/backup/are/stored"
NAME1_EXTRACT_PATH="/path/where/backup/are/extracted"

typeset -A NAME1_ARCHIVES_TO_EXTRACT
NAME1_ARCHIVES_TO_EXTRACT=(
    [0]="archive-to-extract"
    [1]="other-archive-to-extract"
)
typeset -A NAME1_POSTGRES_INSTRUCTIONS
NAME1_POSTGRES_INSTRUCTIONS=(
    [0]="${pg_restore} ..."
    [1]="${pg_restore} ..."
)
