#/bin/bash
#

BACKUP_DIR=/home/mobio/backups

HOST=''
PORT=''
USERNAME=''
PASSWORD=''

_DATA_DIR=/home/mobio/cassandra/data
_SNAPSHOT_NAME=snp-$(date +%F-%H%M-%S)

# keep minimum 2 days
for k in $(seq 2 10); do 
    old_file=cassandra_$(date --date="$k days ago" "+%Y%m%d")
    rm -rf $old_file
done

# run dump data
DIR_NAME=cassandra_$(date '+%Y%m%d')
mkdir -p $BACKUP_DIR/$DIR_NAME
cd $BACKUP_DIR

cqlsh $HOST $PORT -u $USERNAME -p "$PASSWORD" -e "describe keyspace profiling_v3" > $BACKUP_DIR/$DIR_NAME/profiling_v3.cql;
cqlsh $HOST $PORT -u $USERNAME -p "$PASSWORD" -e "describe schema" > $BACKUP_DIR/$DIR_NAME/schema.cql;

###### Create snapshots for all keyspaces
echo "creating snapshots for all keyspaces ....."
/usr/bin/nodetool snapshot -t $_SNAPSHOT_NAME

###### Get Snapshot directory path
_SNAPSHOT_DIR_LIST=`find $_DATA_DIR -type d -name snapshots|awk '{gsub("'$_DATA_DIR'", "");print}' > snapshot_dir_list`

## Create directory inside backup directory. As per keyspace name.
for i in `cat snapshot_dir_list`
do
    if [ -d $_BACKUP_SNAPSHOT_DIR/$i ]
    then
        echo "$i directory exist"
    else
        mkdir -p $_BACKUP_SNAPSHOT_DIR/$i
        echo $i Directory is created
    fi
done

### Copy default Snapshot dir to backup dir
find $_DATA_DIR -type d -name $_SNAPSHOT_NAME > snp_dir_list

for SNP_VAR in `cat snp_dir_list`;
do
    ## Triming _DATA_DIR
    _SNP_PATH_TRIM=`echo $SNP_VAR|awk '{gsub("'$_DATA_DIR'", "");print}'`

    cp -prvf "$SNP_VAR" "$_BACKUP_SNAPSHOT_DIR$_SNP_PATH_TRIM";

done