#!/bin/bash

NC_URL=""
NC_DIR=""
NC_USERNAME=""
NC_PASSWORD=""

TMP_NAME="/tmp/nextshot.png"

import $TMP_NAME
NC_FILENAME=$(zenity --entry --title "NextShot" --text="Enter Filename" --ok-label="Upload" 2>/dev/null)

echo "Uploading screenshot to $NC_URL/$NC_DIR/$NC_FILENAME..."
curl -u $NC_USERNAME:$NC_PASSWORD $NC_URL/remote.php/dav/files/$NC_USERNAME/$NC_DIR/$NC_FILENAME --upload-file $TMP_NAME


FILE_TOKEN=$(curl -u $NC_USERNAME:$NC_PASSWORD -X POST -H "OCS-APIRequest: true" \
    -F "path=/$NC_DIR/$NC_FILENAME" -F "shareType=3" \
    $NC_URL/ocs/v2.php/apps/files_sharing/api/v1/shares?format=json | jq -r '.ocs.data.token')

SHARE_URL="$NC_URL/s/$FILE_TOKEN"

echo "Success! Your file has been uploaded to:"
echo $SHARE_URL
echo $SHARE_URL | \xclip -selection clipboard && \
    echo "Link copied to clipboard. Paste away!"
