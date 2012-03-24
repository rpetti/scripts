#!/bin/sh

minecraft="java -Xmx1024M -Xms1024M -jar minecraft_server.jar"

unset DISPLAY

case "$1" in
start)
	if [ ! -e .pid ]; then
		nohup $minecraft >/dev/null 2>&1 &
		echo $! > .pid
		echo Minecraft server started
	else
		echo Minecraft server already running or stale .pid found!
	fi
;;

stop)
	if [ -e .pid ]; then
		kill `cat .pid`
		echo Minecraft server stopped
	else
		echo Minecraft server not running
	fi
	rm -f .pid
;;

restart)
	$0 stop
	$0 start
;;

update)
	$0 stop
	wget -O minecraft_server.jar https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar
	$0 start

esac
