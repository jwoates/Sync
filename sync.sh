#!/bin/bash -x
####################################
#
# sync.log
# Task to sync directories
# 
####################################
SCRIPT=`readlink -f $0`
SCRIPTPATH=`dirname $SCRIPT`

#Load Config
source $SCRIPTPATH/config

echo "$(id -u)" >> $SCRIPTPATH/error.log
echo "$SSHKEY" >> $SCRIPTPATH/error.log
echo "$SSH_AUTH_SOCK" >> $SCRIPTPATH/error.log

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