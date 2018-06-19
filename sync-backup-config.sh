#!/bin/bash

#==============================================================================
# FILE : sync-backup-config.sh
# USAGE : source sync-backup-config.sh
# DESCRIPTION : Configfile example for sync-backup.sh
# NOTES : 
#==============================================================================

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
