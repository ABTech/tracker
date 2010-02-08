#!/bin/bash

#this is a cronjob

cd /afs/andrew.cmu.edu/usr/abtech/sysadmins/abtt_sql_backups
mysqldump abtechtt_prod -u backup -pQ6HcF9fGdcjEZ37V |gzip > $(date +%Y%m%d%H%M%S).abtt-backup.sql.gz
  

#keep 7 recent (or so), delete rest
#commented out because of permissions
#ls -t|sed -n '2,$p'|xargs rm 

