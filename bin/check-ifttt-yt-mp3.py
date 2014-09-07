#!/usr/bin/python

import os
import subprocess
import tempfile
import json
import shutil

#~/Dropbox/IFTTT/YouTube/YouTube2MP3Hook

dropbox_filename='/home/rpetti/Dropbox/IFTTT/YouTube/youtube2mp3hook.txt'
artist_filter_file='/home/rpetti/Dropbox/IFTTT/YouTube/MusicArtists.txt'

artist_list = []

with open(artist_filter_file) as f:
	artist_list = f.readlines();

def is_url_from_approved_artist(url):
	json_data = subprocess.check_output(["youtube-dl","-j",url])
	metadata = json.loads(json_data)
	uploader = metadata[u'uploader']
	if uploader in artist_list:
		return True
	else:
		return False

def download_song(url):
	subprocess.call(["yt-mp3.py",url])

if os.path.isfile(dropbox_filename):
	tempdir = tempfile.mkdtemp()
	newfilename=tempdir+"/favoritelist"
	os.rename(dropbox_filename,newfilename)
	with open(newfilename) as f:
		for line in f:
			url = line.strip()
			if len(url) > 0:
				if is_url_from_approved_artist(url):
					download_song(url)
	shutil.rmtree(tempdir)
	#subprocess.call(["viper-nofify","yt-2-mp3","favorites downloaded"])
else:
	print "no new favorites to check"

