#!/bin/sh

# Define semaphore file
sem=/var/run/backup.hourly
DRIVE="LABEL=usbbackup"
mount $DRIVE /backup
set $(date)
if [ -f ${sem} ]
then
   echo Aborting Hourly Backup, ${sem} exists
   exit 1
fi

# Set semaphore
> ${sem}


for DIR in `find /home/ -name "Maildir" -print`; do
        NAME=`echo $DIR|awk -F\/ {' print $3 '}`
#	NAME="accounts"
echo "Running hourly backup for $NAME"
	mv /backup/Maildirs/$NAME/Maildir.{12,tmp}
	rm /backup/Maildirs/$NAME/dumptime.12
	mv /backup/Maildirs/$NAME/dumptime.{11,12}
	mv /backup/Maildirs/$NAME/Maildir.{11,12}
	mv /backup/Maildirs/$NAME/dumptime.{10,11}
	mv /backup/Maildirs/$NAME/Maildir.{10,11}
        mv /backup/Maildirs/$NAME/dumptime.{9,10}
	mv /backup/Maildirs/$NAME/Maildir.{9,10}
        mv /backup/Maildirs/$NAME/dumptime.{8,9}
	mv /backup/Maildirs/$NAME/Maildir.{8,9}
        mv /backup/Maildirs/$NAME/dumptime.{7,8}
	mv /backup/Maildirs/$NAME/Maildir.{7,8}
        mv /backup/Maildirs/$NAME/dumptime.{6,7}
	mv /backup/Maildirs/$NAME/Maildir.{6,7}
        mv /backup/Maildirs/$NAME/dumptime.{5,6}
	mv /backup/Maildirs/$NAME/Maildir.{5,6}
        mv /backup/Maildirs/$NAME/dumptime.{4,5}
	mv /backup/Maildirs/$NAME/Maildir.{4,5}
        mv /backup/Maildirs/$NAME/dumptime.{3,4}
	mv /backup/Maildirs/$NAME/Maildir.{3,4}
        mv /backup/Maildirs/$NAME/dumptime.{2,3}
	mv /backup/Maildirs/$NAME/Maildir.{2,3}
        mv /backup/Maildirs/$NAME/dumptime.{1,2}
	mv /backup/Maildirs/$NAME/Maildir.{1,2}
        mv /backup/Maildirs/$NAME/dumptime.{0,1}
	mv /backup/Maildirs/$NAME/Maildir.{0,1}
	mv /backup/Maildirs/$NAME/Maildir.{tmp,0}
	cp -al /backup/Maildirs/$NAME/Maildir.{1/.,0}
	/usr/bin/rsync -av $DIR/. /backup/Maildirs/$NAME/Maildir.0/ --delete --exclude-from '/scripts/maildir-excludes'
	echo `date` >/backup/Maildirs/$NAME/dumptime.0
        done



# Remove semaphore
umount /backup
rm ${sem}

