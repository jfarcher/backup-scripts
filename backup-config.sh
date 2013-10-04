#!/bin/bash
#
# creates backups of essential files
#
DRIVE="LABEL=usbbackup"
CONFIG="/etc/"
LIST="/tmp/backlist_$$.txt"
#
mount $DRIVE /backup
set $(date)
#
        # weekly a full backup of all data and config. settings:
        #
	#Run backup of etc directory
        tar vcfz "/backup/etc/etc_full_$6-$2-$3.tgz" $CONFIG
	COUNTER=`ls -1 /backup/etc/|wc -l`	
	until [ $COUNTER -le 5 ]; do
		rm /backup/etc/`ls -1tr /backup/etc/|grep -v total|head -1`
		COUNTER=`ls -1 /backup/etc/|grep -v total|wc -l`
	done
#Daily differential backup
umount /backup
