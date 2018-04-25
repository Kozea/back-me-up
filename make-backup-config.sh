#!/bin/bash

#==============================================================================
# FILE : make-backup-config.sh
# USAGE : source make-backup-config.sh
# DESCRIPTION : Configfile example for make-back-up.sh
# NOTES : 
#==============================================================================

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
