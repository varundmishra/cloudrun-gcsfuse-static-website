#!/usr/bin/env bash
set -eo pipefail

# Create mount directory for service
mkdir -p $MNT_DIR

echo "Mounting GCS Fuse."
gcsfuse -o rw,allow_other --file-mode 755 --dir-mode 755 --debug_gcs --debug_fuse --implicit-dirs $BUCKET $MNT_DIR 
echo "Mounting completed."

# Start the application
nginx '-g' 'daemon off;' &

# Exit immediately when one of the background processes terminate.
wait -n