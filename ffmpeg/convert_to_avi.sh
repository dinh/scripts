#!/bin/bash
#
# Script to convert a file to avi
#
# This scripts converts a video file to avi. It only includes one command that i am too lazy to remember.
#
# DEPENDENCIES
#     - ffmpeg
#
# USAGE
#     ./convert_to_avi.sh $INPUT $OUTPUT
#
# EXAMPLE
#     ./convert_to_avi.sh file.mp4 file.avi
#

### Variables
INPUT=$1
OUTPUT=$2

### Code
# stop the script if any command fails
set -e 

# Exit if insufficient parameters passed
if [[ -z "$INPUT" ]] || [[ -z "$OUTPUT" ]]; then
  echo "Insufficient parameters. Example usage:"
  echo "  $0 file.mp4 file.avi"
  exit 1
fi

echo "Converting $INPUT to $OUTPUT as avi..."

ffmpeg -i $INPUT -vcodec libxvid -b:v 4096k -b:a 4096k -acodec libmp3lame -ab 128k -threads 4 $OUTPUT
