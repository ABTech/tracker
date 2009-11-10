#!/bin/bash

#this is a cronjob

cd /afs/andrew.cmu.edu/usr/abtech/sysadmins/abtt_sql_backups
mysqldump abtechtt_prod -u abtech|gzip > $(date +%Y%m%d%H%M%S).abtt-backup.sql.gz

