#!/bin/bash -l

set -o errexit -o nounset -o xtrace

if [[ "${INSTANCE_NUMBER}" != "0" ]]; then
    return 0;
fi

cd $APP_HOME

clever login --token $CLEVER_TOKEN --secret $CLEVER_SECRET
clever link --alias _sync_app $SYNC_APP
clever env --alias _sync_app set SYNC_PLEASE_MY_LOVELY_SCRIPT true
clever restart --quiet --alias _sync_app
