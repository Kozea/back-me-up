#!/bin/bash

#==============================================================================
# FILE : make-backup-config.sh
# USAGE : source make-backup-config.sh
# DESCRIPTION : Configfile example for make-back-up.sh
# NOTES : 
#==============================================================================

export BORG_PASSPHRASE="superpassphrase"

BORGREPO="/path/to/borg/repo"

PRUNE_OPT="--keep-secondly=-1 --keep-minutely=-1 --keep-hourly=-1 --keep-daily=5"

function before_backup {
    # some stuff to perform before backup starts
    echo "${BLUE}Before backup${NC}"
}

function after_backup {
    # some stuff to perform when backup are done
    echo "${BLUE}After backup${NC}"
}

typeset -A FILES
FILES=(
    [0]="file.txt"
    [1]="file.sqlite"
    [2]="/path/to/some/directory"
)

typeset -A POSTGRESDB
POSTGRESDB=(
    [save_file.sql]="--schema-only -Fc database_name"
    [other_save_file.sql]="--data-only --exclude-schema=data -Fc database_name"
)
