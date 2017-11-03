#!/bin/bash
#
# Take a screenshot of a selected area and copy it to clipboard
#
# DEPENDENCIES
#     - ffmpeg
#     - slop
#     - xclip
#     - notify-send
#
# USAGE
#     ./screenshot.sh

### Variables
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
SCREENSHOT="$HOME/Pictures/$TIMESTAMP.png"
COORDS=($(slop -b 5 -c 0.8,0.13,0.13 -f "%w %h %x %y"))

if [ $? -eq 0 ]; then
    # take screenshot on coordinates supplied by slop
    ffmpeg -f x11grab -video_size "${COORDS[0]}"x"${COORDS[1]}" -i $DISPLAY.0+"${COORDS[2]}","${COORDS[3]}" -vframes 1 -y $SCREENSHOT
    # copy to clipboard
    xclip -selection clipboard -t image/png -i $SCREENSHOT
    # show notification
    notify-send 'Screenshot saved' "File '$SCREENSHOT' saved and copied to clipboard."
fi
