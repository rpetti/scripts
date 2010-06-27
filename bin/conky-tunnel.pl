#!/usr/bin/perl
$output = `nmap tauron -p 1028 | grep '^1028'`;
if($output =~ /open/){
	if($ARGV[0] eq "ISUP"){
		print "Work Tunnel is UP";
	}
}
else{
	if($ARGV[0] eq "ISDOWN"){
		print "Work Tunnel is DOWN";
	}
}
