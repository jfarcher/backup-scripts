#!/bin/bash
echo $1
source /etc/backup/$1.conf
set $(date)
echo "Backing up $BACKUP_NAME"
if [ ! -d "/store/backup/$BACKUP_NAME" ]; then
mkdir /store/backup/$BACKUP_NAME
fi
if [ ! -d "$LOCAL_WWW" ]; then
mkdir $LOCAL_WWW -p
fi
/usr/bin/ssh -f -L 3307:127.0.0.1:3306 $REMOTE_USER@$REMOTE_HOST -p $REMOTE_SSH_PORT  sleep 20
/usr/bin/mysqldump $REMOTE_SQL_DB -h 127.0.0.1 -P 3307 --password=$REMOTE_SQL_PW > /store/backup/$BACKUP_NAME/sqlbackup-$6-$2-$3.sql
#sleep 20
/usr/bin/rsync -a -e "ssh -p $REMOTE_SSH_PORT" $REMOTE_USER@$REMOTE_HOST:$REMOTE_WWW/. $LOCAL_WWW
if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$LOCAL_SQL_DB'" 2>&1`" ]];
then
  echo "DATABASE ALREADY EXISTS"
else
  /usr/bin/mysql -e "CREATE DATABASE IF NOT EXISTS $LOCAL_SQL_DB"
  MYSQL_USER=`cat $LOCAL_WWW/wp-config.php|grep DB_USER|awk {' print $2 '}|sed s/\'\)\;//|sed s/\'//`
  MYSQL_PW=`cat $LOCAL_WWW/wp-config.php|grep DB_PASSWORD|awk {' print $2 '}|sed s/\'\)\;//|sed s/\'//`
  /usr/bin/mysql -e "GRANT ALL PRIVILEGES ON $LOCAL_SQL_DB.* to $MYSQL_USER@localhost identified by '$MYSQL_PW'"  
fi
/usr/bin/mysql $LOCAL_SQL_DB < /store/backup/$BACKUP_NAME/sqlbackup-$6-$2-$3.sql
tar zcf /store/backup/$BACKUP_NAME/$BACKUP_NAME-$6-$2-$3.tgz $LOCAL_WWW

