#! /bin/bash
#

BACKUP_DIR=/home/mobio/backups

HOST=''
PORT=''
USERNAME=''
PASSWORD=''

# keep minimum 2 days
for k in $(seq 2 10); do 
    old_file=mongo_$(date --date="$k days ago" "+%Y%m%d").gz
    rm -rf $old_file
done

# run dump data
file_name=mongo_$(date '+%Y%m%d').gz
mongodump --host $HOST --port $PORT --username=$USERNAME --password="$PASSWORD" --gzip --archive=$BACKUP_DIR/$file_name
