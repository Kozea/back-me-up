#!/bin/bash

#==============================================================================
# FILE : sync-backup-config.sh
# USAGE : source sync-backup-config.sh
# DESCRIPTION : Configfile example for sync-back-up.sh
# NOTES : 
#==============================================================================

typeset -A RCLONE_REPOS
RCLONE_REPOS=(
    [0]="super-test ftp host toto.host.fr user totouser pass totopwd"
)
