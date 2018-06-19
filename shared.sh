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

# Define commands
AWK="/usr/bin/awk"
BORG="/usr/bin/borg"
CUT="/usr/bin/cut"
DATE="/usr/bin/date"
MKDIR="/usr/bin/mkdir"
PG_DUMP="/usr/bin/pg_dump"
RCLONE="/usr/bin/rclone"
RSYNC="/usr/bin/rsync"
SED="/usr/bin/sed"
STAT="/usr/bin/stat"
