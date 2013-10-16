#! /bin/sh
### BEGIN INIT INFO
# Provides:          scribe
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop scribe log server
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/scribed
NAME=scribe
DESC=scribe
DAEMON_OPTS="-c /etc/scribe/scribe.conf"
SCRIBE_CTRL=/usr/bin/scribe_ctrl
PIDFILE=/var/run/$NAME.pid

SCRIBE_USER="scribe"
SCRIBE_GROUP="scribe"

test -x $DAEMON || exit 0

# Include scribe defaults if available
if [ -f /etc/default/scribe ] ; then
	. /etc/default/scribe
fi

set -e

case "$1" in
  start)
	echo -n "Starting $DESC: "
	mkdir -p /var/log/scribe
	chown -R $SCRIBE_USER:$SCRIBE_GROUP /var/log/scribe
	start-stop-daemon --start --quiet --make-pidfile \
		--pidfile $PIDFILE --chuid $SCRIBE_USER:$SCRIBE_GROUP \
		--exec $DAEMON \
		-- $DAEMON_OPTS 2>&1 | multilog s16777215 n30 /var/log/scribe &
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	if $SCRIBE_CTRL stop; then
		rm -f $PIDFILE
	fi
	echo "$NAME."
	;;
  reload)
	echo "Reloading $DESC configuration files."
	$SCRIBE_CTRL reload
  	;;
  restart)
    echo -n "Restarting $DESC: "
	set +e;
	$0 stop
	set -e;
	sleep 1
	$0 start
	echo "$NAME."
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|reload}" >&2
	exit 1
	;;
esac

exit 0
