#! /bin/bash
#

BACKUP_DIR=/home/mobio/backups

HOST=''
PORT=''
USERNAME=''
PASSWORD=''

# keep minimum 3 backup version
num_backup=`ls $BACKUP_DIR | wc -l`
if [[ $num_backup -gt 3 ]]; then
    ls $BACKUP_DIR | sort | head -n $(($num_backup-3)) | awk '{system("rm -rf $BACKUP_DIR/" $1)}'
fi

# run dump data
file_name=mongo_$(date '+%Y%m%d').gz
mongodump --host $HOST --port $PORT --username=$USERNAME --password="$PASSWORD" --gzip --archive=$BACKUP_DIR/$file_name
