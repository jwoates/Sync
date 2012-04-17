#!/bin/bash -x
####################################
#
# importProdData.sh
# run find/replace for TLD on db dump, import modified dump to MySQL
# 
####################################
SCRIPT=`readlink -f $0`
SCRIPTPATH=`dirname $SCRIPT`

ORIG_NAMES=(stage.widmerbrothers.com stage.konabrewingco.com stage.redhook.com stage.craftbrew.com)
NEW_NAMES=(dev.widmerbrothers.com dev.konabrewingco.com dev.redhook.com dev.craftbrew.com)

# dump file
DUMP=/home/allibubba/Projects/cbai/public_html/cbai.sql

# Change orig_name to new_name

for (( i = 0 ; i < ${#ORIG_NAMES[@]} ; i++ )) do

  sed -i "s/${ORIG_NAMES[$i]}/${NEW_NAMES[$i]}/g" $DUMP

done





#Load Config
source $SCRIPTPATH/db_config

echo 'importing...' >> /home/allibubba/Tasks/Sync/import.log
# import data
mysql --user=$USER --password=$PASSWORD $DB_NAME < $DUMP