#!/bin/bash
#
# This script curls a configured service in a given interval. If the service is not reachable it will send an email notification.
# The script is intended to run as a daemon, so you should propably setup a service for it.
#
# You can configure a given host and port. The script will check if the destination is reachable via a simple curl.
# If the service is not reachable an email notification will be sent.
#
# DEPENDENCIES
#     - curl
#     - mail

### Variables
# Service configuration
SERVICE_NAME='Some name'
HOST='localhost'
PORT=1234
EMAIL_USER='root' # User to whom the email notification is sent, check your /etc/aliases

# How many seconds does the script sleep after each check
CHECK_INTERVAL_SECONDS=180 # 3 minutes

# Maximum amount of retries. The script aborts after reaching $MAX_RETRIES
MAX_RETRIES=5

##################################
## DO NOT EDIT AFTER THIS POINT ##
##################################

###############################
## Internally used variables ##
###############################
# How many seconds until the next check after a failed check
FAIL_TIMER=$CHECK_INTERVAL_SECONDS

# Counter for current retries.
RETRIES=0

######################
## Helper funtions  ##
######################

# Log 
# Log a given string 
# @param $1: The log message
# @Example:
#   log '[INFO] Works'
#   log '[WARN] Failed'
log() {
  TIMESTAMP=`date --rfc-3339=seconds`
  echo "$TIMESTAMP $1" 
}

# Send email notification 
# @param $1: the email subject
# @param $2: the email body
send_email_notification() {
  echo "$2" | mail -s "$1" $EMAIL_USER
}

###############
## Main loop ##
###############
while true; do
  # Curl the configured service
  curl -s "$HOST:$PORT" >> /dev/null

  # Check if the exit code of the previous command was != 0
  if [ $? -ne 0 ]; then
    ## Curl failed, the service might be offline!
    # Notify about the service beeing offline
    send_email_notification "$SERVICE_NAME offline" "$SERVICE_NAME is not reachable on host $HOSTNAME."

    # Check if we are allowed to retry
    if [ "$RETRIES" -lt "$MAX_RETRIES" ]; then
      # we are still allowed to retry
    
      log "[WARN] $SERVICE_NAME NOT reachable. Sleeping for $FAIL_TIMER seconds."
      sleep $FAIL_TIMER

      # Increase failtimer 
      FAIL_TIMER=$(($FAIL_TIMER*10)) 
      RETRIES=$((RETRIES+1))
    else
      # script will be aborted.
      log "[WARN] MAX_RETRIES ($MAX_RETRIES) reached. Stopping the script."
      log ''
      send_email_notification "$SERVICE_NAME offline, script stopping" "$SERVICE_NAME reached the maximum retries. The script is stopping and will no longer check the service."
      exit 1
    fi
  else
    # curl succeeded, service is running

    # notify if there was a fail previously -> we are now stable again
    if [ $RETRIES -ne 0 ]; then
      send_email_notification "$SERVICE_NAME running again" "$SERVICE_NAME is stable and reachable again."
      log "[INFO] $SERVICE_NAME is running again."
    fi

    # log success
    log "[INFO] $SERVICE_NAME reachable. Sleeping for $CHECK_INTERVAL_SECONDS seconds."
    
    # reset fail counters
    RETRIES=0
    FAIL_TIMER=$CHECK_INTERVAL_SECONDS

    sleep $CHECK_INTERVAL_SECONDS
  fi
done
