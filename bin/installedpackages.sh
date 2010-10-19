#! /bin/sh
TEMPFILE=`tempfile`
cat /var/log/installer/initial-status.gz | gzip -d |grep '^Package:' | awk '{ print $2}' > $TEMPFILE
aptitude search -F %p '~i!~M' | awk '{ print $1}' | grep -v -F -f $TEMPFILE
rm $TEMPFILE
