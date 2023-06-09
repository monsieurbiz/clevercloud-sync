#!/bin/bash -l

set -o errexit

# If we are not the sync app, let's stop
if [[ "$SYNC_APP" != "$APP_ID" ]]; then
    echo "The sync app is incorrect. Both APP_ID and SYNC_APP are different." 1>&2
    exit 0
fi

# Sure?
# if [[ "$SYNC_PLEASE_MY_LOVELY_SCRIPT" != "true" ]]; then
#     echo "This app is running without the safety flag SYNC_PLEASE_MY_LOVELY_SCRIPT set to true. It won't sync."
#     exit 0
# fi

# Do not sync twice in a row, let's be sure of that!
clever login --token $CLEVER_TOKEN --secret $CLEVER_SECRET
clever link --alias _myself $APP_ID
clever env --alias _myself set SYNC_PLEASE_MY_LOVELY_SCRIPT false

cd $APP_HOME

date=`date '+%Y%m%d%H%M%S'`
syncDir=$APP_HOME/sync
chunkSize=30

echo "Sync is started."

# Setup S3
envsubst < $APP_HOME/s3cfg.dist > $APP_HOME/s3cfg

# Check if we have a db to restore
s3cmd -c $APP_HOME/s3cfg ls s3://$SYNC_BUCKET | while read -r line;
do
    # TODO LOGIC
done;

# Format to use: SYNC_MYSQL(_[0-9]+)?=user:pass:host:port:database:alias
env | grep SYNC_MYSQL | while read line; do
    IFS=":" read -r user pass host port db alias <<< `echo $line | awk -F= {'print $2'}`
    # TODO LOGIC
    # Download
    # s3cmd -c $APP_HOME/s3cfg put --multipart-chunk-size-mb=$chunkSize $syncDir/$pathname.$date.tgz s3://$BACKUP_BUCKET
    # Import dump
    # zcat <FILEPATH>.sql.gz | mysql -h$host -P$port -u$user -p$pass $db
    # Clean
    # rm -f $syncDir/$alias.$db.$date.sql.gz
done;
