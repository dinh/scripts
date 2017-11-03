#!/bin/bash
#
# Take a screencast of a selected area
#
# This script lets you select an area on screen and record what is happening. To stop recording either kill ffmpeg or run the script again.
# Below are two lines to record a video, one with and one without sound. Chose only one!
#
#
# DEPENDENCIES
#     - ffmpeg
#     - slop
#     - notify-send

# if ffmpeg is running, kill it
if [[ $(pidof ffmpeg) ]]; then
    kill -15 $(pidof ffmpeg)
    notify-send 'Screencast stopped' "Screencast stopped and saved."
else
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    COORDS=($(slop -b 5 -c 0.8,0.13,0.13 -f "%w %h %x %y"))

    if [ $? -eq 0 ]; then
        notify-send 'Starting screencast'
        # start screencast
        # This line only records video, no audio
	ffmpeg -f x11grab -video_size "${COORDS[0]}"x"${COORDS[1]}" -framerate 15 -i $DISPLAY.0+"${COORDS[2]}","${COORDS[3]}" -y $HOME/Videos/$TIMESTAMP.mp4 &
        # This line also includes audio.
	#ffmpeg -f x11grab -video_size "${COORDS[0]}"x"${COORDS[1]}" -framerate 25 -i $DISPLAY.0+"${COORDS[2]}","${COORDS[3]}" -f pulse -ac 2 -i 1 -y $HOME/Videos/$TIMESTAMP.mp4 &
	echo $!
    fi
fi

