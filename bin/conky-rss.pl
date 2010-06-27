#!/usr/bin/perl

use Text::Wrap;

$file="/tmp/rss.html";
$Text::Wrap::columns=60;
$tab="\t";

undef $/;

$topics=$ARGV[1];
$skip=$ARGV[2];

$topics = $topics + $skip;

my $buf = `wget --timeout=5 $ARGV[0] -O - 2>/dev/null | fromdos`;

#open(IN,$file);
my $i=0;
my $flag=0;
#my $buf = <IN>;

while($buf=~/<title>.*<\/title>/s && $i < $topics){	
	if($buf=~/<title>.*<\/title>/s){
		if($i >= $skip){print(&msg."\n");}else{&msg;}
		$i++;
	}
}


sub trim($){
	my $string = shift;
	$string =~ s/^[ \n\r\t]+//s;
	$string =~ s/[ \n\r\t]+$//s;
	return $string;
}


sub msg{
	$buf=~s/<title>([^<]*)<\/title>/$1/s;
	$title=trim($1);
	$title =~ s/^(.{50,50}).*$/$1.../;
	$title =~ s/\s*\.\.\.$/.../;
	return trim($title);
}
