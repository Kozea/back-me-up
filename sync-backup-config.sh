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

typeset -A SCP_SYNC
SCP_SYNC=(
    [0]="${SCP} -P port -r local_path user@example.com:/remote_path"
)

typeset -A AFTER_SYNC
AFTER_SYNC=(
    [0]="some command you want to perform when sync is done"
)
