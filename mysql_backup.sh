#!/bin/bash
#
# mysql backup script
#
# This script dumps all local user databases and gzip's them. After zipping it deletes old backups, always keeping the latest 5.
# The default databases "information_schema", "performance_schema" and "mysql" are not dumped.
#
# You can either pass your credentials via arguments or simply hardcode them below in the "variables" section.
#
# DEPENDENCIES
#     - mysql
#     - gz
#
# USAGE
#     ./mysql_backup $MYSQL_USER $MYSQL_PASSWORD 
#
# EXAMPLE
#     ./mysql_backup root root
#

### Variables
MYSQL_USER=$1
MYSQL_PASSWORD=$2
BACKUP_FOLDER="/var/mysql-backup"

###############################################################################
### Code - Only edit if you know what you are doing.
###############################################################################
# stop the script if any command fails
set -e

# Exit if insufficient parameters passed
if [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]]; then
  echo "Insufficient parameters. Example usage:"
  echo "  $0 MYSQL_USER MYSQL_PASSWORD"
  exit 1
fi

# get all databases
DATABASES=$(mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

# loop existing databases
for DB in $DATABASES; do
    # exclude the default databases
    if [[ "$DB" != "information_schema" ]] && [[ "$DB" != "performance_schema" ]] && [[ "$DB" != "mysql" ]] && [[ "$DB" != _* ]] ; then
        echo "Dumping database: $DB"
        # safe current date, for example:  20171220153421
        TIMESTAMP=$(date +%Y%m%d%H%M%S)

        # build path to file, for example: /var/mysql/20171220153421.my_database.sql
        DUMP_FILE=$BACKUP_FOLDER/$TIMESTAMP.$DB.sql

        # dump database
        mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD --databases $DB > $DUMP_FILE

        # zip database
        gzip $DUMP_FILE

        # delete old entries, keeping 5 newest
        cd $BACKUP_FOLDER && ls -t |grep $DB | awk 'NR>5' | xargs --no-run-if-empty rm
    fi
done
