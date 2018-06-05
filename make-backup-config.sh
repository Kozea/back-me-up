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

typeset -A BEFORE_BACKUP
BEFORE_BACKUP=(
    [0]="some command to execute before starting backup"
    [1]="other command"
)

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
