#!/usr/bin/perl
$output = `nmap crashdown -p 22 | grep '^22'`;
if($output =~ /open/){
	print "Crashdown is ONLINE";
}
else {
	print "Crashdown is offline";
}
