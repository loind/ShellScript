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
DIR_NAME=mysql_$(date '+%Y%m%d')
mkdir -p $BACKUP_DIR/$DIR_NAME
cd $BACKUP_DIR
DB_EXCLUDE="'mysql','information_schema','sys','performance_schema'"
SQL_GET_DB="select SCHEMA_NAME from information_schema.SCHEMATA where schema_name not in ($DB_EXCLUDE);"
i=0

echo "====================== BEGIN BACKUP ========================="
echo "DIRECTORY: $BACKUP_DIR/$DIR_NAME"

query_databases="export MYSQL_PWD=\"$PASSWORD\" ; mysql -h $HOST --port=$PORT -u $USERNAME -e \"$SQL_GET_DB\" -sN"
databases=$(eval "$query_databases")
for db in $databases; do
    i=$((i+1))
    echo $i --- $db
done
echo "DATABASES: $i databases"
i=0
echo "BEGIN: $(date)"
for db in $databases; do
    i=$((i+1))
    echo "----------------------------------------"
    echo ">>>>>>>>> $i --- $db --- file: $db.sql"
    mysqldump -v --set-gtid-purged=OFF --quick --single-transaction=TRUE --add-drop-database -h $HOST --port=$PORT -u $USERNAME --password="$PASSWORD" --databases $db >$BACKUP_DIR/$DIR_NAME/$db.sql
    if [ "$?" -eq 0 ]
    then
        echo "Backup.... SUCCESS"
    else
        echo "Mysqldump encountered a problem look in dump$db.err for information"
    fi
done
echo "END: $(date)"
echo "========================================================="
