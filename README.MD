This is a collection of scripts and commands that i might have written and use frequently.
Every script is explained and commented.

# Scripts
## dyndns.php
Simple custom dyndns script

This script lets you run a similiar functionality to an own dns service.
Once you hosted the script your router needs to access it with the right parameters. 
The script then saves the ip of the router to a file, to which you are redirected if you make a normal request to the script with the browser.

## mysql_backup.sh
mysql backup script

This script dumps all local mysql databases and gzip's them. After zipping it deletes old backups, always keeping the latest 5.
The default databases "information_schema", "performance_schema" and "mysql" are not dumped.

## remove_corrupt_images.sh
This script removes corrupt images

**WARNING: YOUR IMAGES MIGHT GET DELETED**
The script tries to read every image in the current folder. If an image is unreadable it will be deleted.

## screencast.sh
Take a screencast of a selected area

This script lets you select an area on screen and record what is happening. To stop recording either kill ffmpeg or run the script again.

## screenshot.sh
Take a screenshot of a selected area and automatically copy it to clipboard.

## ffmpeg
These are just some ffmpeg commands that i cannot remember.

### convert_to_avi.sh
Converts a given file to avi.

### convert_to_gif.sh
Converts a given file to gif.

## check_service
This script curls a configured service in a given interval. If the service is not reachable it will send an email notification.
The script is intended to run as a daemon, so you should propably setup a service for it.

You can configure a given host and port. The script will check if the destination is reachable via a simple curl.
If the service is not reachable an email notification will be sent.
