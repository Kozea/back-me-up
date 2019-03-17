#!/bin/bash

#==============================================================================
# FILE : shared.sh
# USAGE : source shared.sh
# DESCRIPTION : Contains shared variables and functions
# NOTES : 
#==============================================================================

# Define colors
BLUE='\033[1;34m'
GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'
YELLOW='\033[1;33m'

function help {
    case "$1" in
        "make-backup")
            echo Make a back-up with Borg of the files listed in the configfile
            echo make-backup.sh -c configfile
            ;;
        "check-backup")
            echo Check if the last update of the target_path is today
            echo check-backup.sh -t target_path
            ;;
        "sync-backup")
            echo Sync local back-up with a remote server
            echo ./sync-backup.sh -c configfile
            ;;
        "extract-backup")
            echo Extract a Borg back-up
            echo extract-backup.sh -c configfile -t target_name
            ;;
    esac
    exit
}
