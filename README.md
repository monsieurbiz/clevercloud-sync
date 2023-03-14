# Clever Cloud Sync App

This project is quite simple.  
We have an application which runs the sync script itself.

## Setup

You must create a `static-apache` or `php` application:

```
clever create -a sync -o "ORG NAME or ID" --type static-apache --region par --github "monsieurbiz/clevercloud-sync" "sync-app"
clever scale -a sync --flavor M
clever config -a sync update --enable-zero-downtime --enable-cancel-on-push
```

Once the app is created you should remove the domain attached to your app.

### Environment variables

The application uses some environment variables to run: (those can be in a `$config` addon in Clever Cloud)

- `CLEVER_TOKEN` and `CLEVER_SECRET` are mandatory as well, both for the synced application and the main application.  
  You *must* create a dedicated member in your Organization so those credentials are safe.
- `SYNC_APP=app_…` is the code of the sync application itself. The sync script tests this value to be the same as its own `$APP_ID`.
- `SYNC_MYSQL_SOURCE_*=user:pass:host:port:database` (optional) are specific variables for MySQL source syncs. The format is quite simple, the fields are `:` separated.
- `SYNC_MYSQL_DESTINATION_*=user:pass:host:port:database` (optional) are specific variables for MySQL destination syncs. The format is quite simple, the fields are `:` separated. The `*` pattern must match with a `SYNC_MYSQL_SOURCE_*` one.
- `SYNC_MYSQL_SCRIPTS_PATH_*=path/from/app/folder-with-sql-scripts` (optional) are specific variables for MySQL scripts folder to run after sync. Each variable contains a path of folder with scripts inside. The `*` pattern must match with a `SYNC_MYSQL_SOURCE_*` one.
- `SYNC_PATH_SOURCE_*=path/from/app/this-is-my-sync` (optional) are specific variables for FileSystem source syncs. Each variable contains a path of the files to sync.  
- `SYNC_PATH_DESTINATION_*=path/from/app/this-is-my-sync` (optional) are specific variables for FileSystem destination syncs. Each variable contains a path of the files to sync. The `*` pattern must match with a `SYNC_PATH_SOURCE_*` one.

Some other environment variables are need for the synced application only (not in the `$config` addon!!):
- `CC_RUN_COMMAND=./sync.sh` tells Clever Cloud to run the sync script on startup.
- `CC_TASK=true` tells Clever Cloud to stop the application once the sync is finished.

Running the sync application will create an environment variable named `SYNC_PLEASE_MY_LOVELY_SCRIPT`, this is perfectly normal.

## How to run the sync itself?

You need to copy the `sync-please.sh` script into your own main application.
Then you can use a cronjob like this:

```
0 */12 * * * $ROOT/sync-please.sh
```

Your main app will need the following variables as well: `CLEVER_TOKEN`, `CLEVER_SECRET`, `SYNC_APP`.  

Using a `$config` addon is helpful.

Enjoy!

## Troubleshooting

### How to SSH on the Sync App instance ?

You just need to set two specific environment variables: `CC_TROUBLESHOOT=true` and `CC_PRE_BUILD_HOOK=false`

Then you just have to start the instance! And use the Clever Cloud CLI to SSH to it!

## License

This project is completely free and released under the [MIT License](https://github.com/monsieurbiz/clevercloud-sync/blob/master/LICENSE.txt).
