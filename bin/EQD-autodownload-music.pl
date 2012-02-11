#!/usr/bin/perl

use LWP::Simple;
use HTML::Entities qw(decode_entities);

$debug = 1;

$basedir=".";

if($ARGV[0]){
	$basedir = $ARGV[0];
}

$downloadedListFile = "$basedir/.downloaded";

%downloadedDatabase = ();

my @searchPageUrls = (
"http://www.equestriadaily.com/search/label/Music",
"http://www.equestriadaily.com/search/label/Instrumental%20Music"
);

if(-e $downloadedListFile){
	open(FILE, "<", $downloadedListFile);
	while(<FILE>){
		chomp;
		$downloadedDatabase{$_} = 1;
	}
	close(FILE);
}

sub uniq {
	return keys %{{ map {$_ => 1 } @_}};
}

sub getTitle {
	my $content;
	my $url = $_;
	my %i = 0;
	while(1){
		if($content = get($url)){
			last;
		} else {
			if(++$i == 5){
				print "ERROR getting title for $url!\n";
				last;
			}
		}
	}
	
	my @title = $content =~ /meta *name="title" *content="([^"]*)"/;
	my $newtitle = decode_entities($title[0]);
	$newtitle =~ s/\// /g;
	$newtitle =~ s/://g;
	return $newtitle;
}

sub getShortUrl {
	my $url = shift;
	my $shorturl = $url;
	$shorturl =~ s/http:\/\/www.youtube.com\/watch\?v=/http:\/\/youtu.be\//;
	return $shorturl;
}

sub hasBeenDownloaded {
	my $url = shift;
	return $downloadedDatabase{$url};
}

sub markAsDownloaded {
	my $url = shift;
	unless($downloadedDatabase{$url}){
		open(FILE, ">>", $downloadedListFile);
		print FILE $url . "\n";
		close(FILE);
	}
	$downloadedDatabase{$url} = 1;
}

sub download {
	my $url = shift;
	if(hasBeenDownloaded($url)){
		print "Skipping $url, already downloaded.\n";
		return;
	}

	my $title = getTitle($url);
	my $filename = $basedir . "/" . $title . ".mp3";
	unless(-e $filename || hasBeenDownloaded($url)){
		print "Downloading '$title' from $url\n" if $debug;
		system("youtube2mp3", $url, $filename);
		system("id3v2", "-t", $title, "-A", "Brony", "-c", getShortUrl($url), $filename);
	} else {
		print "Skipping '$title', already downloaded.\n";
	}
	markAsDownloaded($url);
}


print "Getting main page\n" if $debug;


my $searchPageContent = "";

for $searchPageUrl (@searchPageUrls){
	$searchPageContent .= get $searchPageUrl;
}

#search for 'more' links

my @moreUrls = uniq($searchPageContent =~ /href='([^']*)#more'/g);

for $url (@moreUrls){
	print "Getting $url\n" if $debug;
	my $urlContent = get $url;
	my @youtubeLinks = $urlContent =~ /src="(http:\/\/www.youtube.com[^"]*)"/g;
	for (@youtubeLinks) {
		#convert to 'watch' link
		s/embed\//watch?v=/;
		download($_);
	}
}	
	
