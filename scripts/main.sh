#!/bin/sh

# set some path variables
BASE_PATH="/data"
MOODLE_JSON="$BASE_PATH/config.json"
OUTPUT_PATH="$BASE_PATH/moodle/"

# change to the volume path
cd $BASE_PATH

# remove any leftover lock files
rm -f *.lock

# update the config.json file using python (embedded below)
python - <<EOF
import json

config_path = '$MOODLE_JSON'
config = {
    "download_path": "$OUTPUT_PATH",
    "misc_files_path": "$BASE_PATH",
}

with open(config_path, 'r+') as file:
    data = json.load(file)
    data.update(config)
    file.seek(0)
    json.dump(data, file, indent=4)
EOF

# run the moodle-dl script
moodle-dl

# run rclone to sync the output folder to the configured destination
if [ -n "$RCLONE_DEST" ]; then
    echo "Syncing $OUTPUT_PATH to $RCLONE_DEST"
    rclone sync -v $OUTPUT_PATH $RCLONE_DEST
    echo "Sync complete"
fi