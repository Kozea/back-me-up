#!/bin/bash

#==============================================================================
# FILE : config-example.sh
# USAGE : source config-example.sh
# DESCRIPTION : Configfile example for back-me-up
# NOTES : 
#==============================================================================

## make-backup part

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

# Db listed here are dump in an sql file instead of just copy the db file
typeset -A SQLITEDB
SQLITEDB=(
    [save_file.sql]="db.sqlite"
)

typeset -A POSTGRESDB
POSTGRESDB=(
    [save_file.sql]="--schema-only -Fc database_name"
    [other_save_file.sql]="--data-only --exclude-schema=data -Fc database_name"
)


## sync-backup part

typeset -A RCLONE_REPOS
RCLONE_REPOS=(
    [0]="super-test ftp host toto.host.fr user totouser pass totopwd"
)

typeset -A RCLONE_SYNC
RCLONE_SYNC=(
    [0]="local_path remote:/path"
)

function sync {
    # sync actions
    echo -e "${BLUE}Sync${NC}"
}

function after_sync {
    # some stuff to perform when sync is done
    echo -e "${BLUE}After sync${NC}"
}


## extract-backup part

function before_extract {
    # some stuff to perform before extract starts
    echo -e "${BLUE}Before extract${NC}"
}

function after_extract {
    # some stuff to perform when extract is done
    echo -e "${BLUE}After extract${NC}"
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

function NAME1_restore {
    # some stuff to restore database
    echo -e "${BLUE}Restore${NC}"
}
