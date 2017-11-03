#!/bin/bash
#
# Convert a video file to gif
#
# DEPENDENCIES
#     - ffmpeg
#
# USAGE
#     ./video_to_gif.sh $INPUT
#
# EXAMPLE
#    ./video_to_gif.sh file.mp4
#

### Variables
PALETTE="/tmp/palette.png"
FILTERS="fps=10,scale=1280:-1:flags=lanczos"
INPUT=$1

### Code
# stop the script if any command fails
set -e

# Exit if insufficient parameters passed
if [[ -z "$INPUT" ]]; then
  echo "Insufficient parameters. Example usage:"
  echo "  $0 file.mp4"
  exit 1
fi

ffmpeg -i $INPUT -vf "$FILTERS,palettegen" -y $PALETTE
ffmpeg -i $INPUT -i $PALETTE -lavfi "$FILTERS [x]; [x][1:v] paletteuse" -y output.gif
