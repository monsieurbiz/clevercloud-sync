#!/bin/bash -l

set -o errexit

# If we are not the sync app, let's stop
if [[ "$SYNC_APP" != "$APP_ID" ]]; then
    echo "The sync app is incorrect. Both APP_ID and SYNC_APP are different." 1>&2
    exit 0
fi

# Sure?
if [[ "$SYNC_PLEASE_MY_LOVELY_SCRIPT" != "true" ]]; then
    echo "This app is running without the safety flag SYNC_PLEASE_MY_LOVELY_SCRIPT set to true. It won't sync."
    exit 0
fi

# Do not sync twice in a row, let's be sure of that!
clever login --token $CLEVER_TOKEN --secret $CLEVER_SECRET
clever link --alias _myself $APP_ID
clever env --alias _myself set SYNC_PLEASE_MY_LOVELY_SCRIPT false

cd $APP_HOME
