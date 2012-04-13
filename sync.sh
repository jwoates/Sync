#!/bin/bash -x
####################################
#
# sync.log
# Task to sync directories
# 
####################################
SCRIPT=`readlink -f $0`
SCRIPTPATH=`dirname $SCRIPT`
SSH_AUTH_SOCK="$(find /tmp/keyring*/ -perm 0755 -type s -user allibubba  -name '*ssh' | head -n 1)"

#Load Config
source $SCRIPTPATH/config

echo "01: $(id -u)" >> $SCRIPTPATH/error.log
echo "02: $SSHKEY" >> $SCRIPTPATH/error.log
echo "03: $SSH_AUTH_SOCK" >> $SCRIPTPATH/error.log

# rsync binary
rsync="/usr/bin/rsync"

# Log file
log_file="$SCRIPTPATH/access.log"

# push
if [ "$1" == 'prod' ];
  then
    echo -e "\nrunning PROD push...\n"
    rsync --exclude-from=$SCRIPTPATH/rsync.exclude -avvvz -e ssh -i $SSHKEY $ORIGIN $REMOTE:$TARGET
  else
    echo -e "\nrunning TEST push...\n"
    rsync --dry-run --exclude-from=$SCRIPTPATH/rsync.exclude -avvvz -e ssh -i $SSHKEY $ORIGIN $REMOTE:$TARGET
fi

# log
echo "Synch FROM: $ORIGIN   TO: $TARGET    - `date`" >> $log_file
