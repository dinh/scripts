#!/bin/bash
#
# This script removes corrupt images
#
# WARNING: YOUR IMAGES MIGHT GET DELETED
# The script tries to read every image in the current folder. If an image is unreadable it will be deleted.
#
# DEPENDENCIES
#     - imagemagick
# 
# USAGE
#     ./remove_corrupt_images.sh

# find all jpg|gif|png|jpeg files
find -iregex '.*\.\(jpg.t\|gif.t\|png.t\|jpeg.t\)$' | while read i; do
    # try to identify the file. "identify" is provided by imagemagick and reads metadata about an image.
    identify "${i}" > /dev/null 2>&1
    # identify failed: save the filename to a logfile and remove the image
    if [[ $? != 0 ]]; then
        echo "${i}" >> ./files.txt
        rm "${i}"
    fi
done
exit 0
