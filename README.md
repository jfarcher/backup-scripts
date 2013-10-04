Repo to contain my various backup scripts for Linux:

backup-mail-hourly.sh:
This is a script which will create hourly backups of each Maildir found recursively in /home. It does a find for the Maildir keyword and uses the homedirectory it is found in as a name for the backup.
For example: /home/jon/Maildir would be backed up as jon

This is currently used to to backup to an external USB hard disk, which is mounted at the beginning of the script. a directory is created for each user found, and 12 directories beneath this.
The initial backup is a complete rsync of the maildir, but subsequent hourly (scheduled by cron) are rotated versions of this directory using hardlinks. So essentially only changes are stored extra, not 12 copies of said directory.
