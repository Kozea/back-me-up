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
    [0]="database_name"
)
