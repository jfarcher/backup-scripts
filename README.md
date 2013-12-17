Repo to contain my various backup scripts for Linux:

backup-wp.sh
This is a script to take a copy of a wordpress site hosted elsewhere (via rsync and mysqldump), it does it in a secure manner by opening an ssh tunnel to the remote host and running a dump via a forwarded port. The script then restores the database to a local running mysql server. An rsync is of the web directory is also performed, this makes an up to date copy of the live site just in case. The final step takes a tarball of the local web directory into a backup store which is then synchronised to an online backup service. Intelligence is integrated into the script in the way that, if the site/database doesn't already exist it will be created and the relevant grants applied by reading the wordpress configuration file. site/local configuration details must be stored in a configuration file within /etc/backup with a suffix of conf - a sample configuration file also exists in this repository. (I may have this as a repository on it's own later).

backup-mail-hourly.sh:
This is a script which will create hourly backups of each Maildir found recursively in /home. It does a find for the Maildir keyword and uses the homedirectory it is found in as a name for the backup.
For example: /home/jon/Maildir would be backed up as jon

This is currently used to to backup to an external USB hard disk, which is mounted at the beginning of the script. a directory is created for each user found, and 12 directories beneath this.
The initial backup is a complete rsync of the maildir, but subsequent hourly (scheduled by cron) are rotated versions of this directory using hardlinks. So essentially only changes are stored extra, not 12 copies of said directory.

backup-config.sh:
This is a really simple script to take a tarball copy of the /etc directory. Nothing exciting really, just schedule it in as a cron job (I do it weekly) and away you go. Currently takes the copy to an external hard disk drive which is mounted at the top of the script.
