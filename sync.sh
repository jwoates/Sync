#!/bin/bash -x
####################################
#
# sync.sh
# Task to sync directories, pull from REMOTE ORIGIN to TARGET
# 
####################################
SCRIPT=`readlink -f $0`
SCRIPTPATH=`dirname $SCRIPT`
#SSH_AUTH_SOCK="$(find /tmp/keyring*/ -perm 0755 -type s -user allibubba  -name '*ssh' | head -n 1)"

#Load Config
source $SCRIPTPATH/config


RUNNING=`ps -ef | grep 'rsync -av' | grep -v grep`
if [ -z $RUNNING ]; then
  export SSH_AUTH_SOCK=`find /tmp/keyring-*/ -type s -user allibubba -name ssh`


  # echo "001: $SSH_AUTH_SOCK" > $SCRIPTPATH/error.log

  # rsync binary
  rsync="/usr/bin/rsync"

  # Log file
  log_file="$SCRIPTPATH/access.log"

  # push
  if [ "$1" == 'prod' ];
    then
      echo -e "\nrunning PROD push...\n"
      rsync --exclude-from=$SCRIPTPATH/rsync.exclude -avvvz -e ssh $REMOTE:$ORIGIN $TARGET


    else
      echo -e "\nrunning TEST push...\n"
      rsync  --dry-run --exclude-from=$SCRIPTPATH/rsync.exclude -avvvz -e ssh $REMOTE:$ORIGIN $TARGET
  fi

  # log
  echo "Synch FROM: $ORIGIN   TO: $TARGET    - `date`" > $log_file

fi
