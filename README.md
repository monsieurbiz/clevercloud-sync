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

The application uses some environment variables to run: (those can be in a `$config` addon in Clever Cloud, linked to your app and the sync app).

- `CLEVER_TOKEN` and `CLEVER_SECRET` are mandatory as well, both for the synced application and the main application.  
  You *must* create a dedicated member in your Organization so those credentials are safe.
- `SYNC_APP=app_…` is the code of the sync application itself. The sync script tests this value to be the same as its own `$APP_ID`.
- `SYNC_BUCKET=project-backups` is the name of the bucket we need to use in the S3 Cellar.


Some other environment variables are need for the sync application only (not in the `$config` addon!!):
- `CC_RUN_COMMAND=./sync.sh` tells Clever Cloud to run the sync script on startup.
- `CC_TASK=true` tells Clever Cloud to stop the application once the sync is finished.

Running the sync application will create an environment variable named `SYNC_PLEASE_MY_LOVELY_SCRIPT`, this is perfectly normal.

The sync application also has access to those variables through the linked Cellar:
- `CELLAR_ADDON_HOST`
- `CELLAR_ADDON_KEY_ID`
- `CELLAR_ADDON_KEY_SECRET`

## How to run the sync itself?

You need to copy the `sync-please.sh` script into your own main application.

Your main app will need the following variables as well: `CLEVER_TOKEN`, `CLEVER_SECRET`, `SYNC_APP`.  

Using a `$config` addon is helpful.

Then you have to run the `sync-please.sh` to run the sync.

Enjoy!

## Troubleshooting

### How to SSH on the Sync App instance ?

You just need to set two specific environment variables: `CC_TROUBLESHOOT=true` and `CC_PRE_BUILD_HOOK=false`

Then you just have to start the instance! And use the Clever Cloud CLI to SSH to it!

## License

This project is completely free and released under the [MIT License](https://github.com/monsieurbiz/clevercloud-sync/blob/master/LICENSE.txt).
